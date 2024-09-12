# Interface

function log_msg(client::AbstractAPIsClient, query::APIsRequest)
    return (
        base_url = client.base_url,
        method = query.method,
        endpoint = query.endpoint,
        query = Serde.to_json(query.query),
        num_calls = query.num_calls[],
    )
end

function perform_request(client::AbstractAPIsClient, query::APIsRequest)
    request_sign!(client, query.query, query.endpoint)
    @debug "sending request" log_msg(client, query)...
    req = http_request(
        query.method,
        curl_joinurl(client.base_url, query.endpoint);
        headers = request_headers(client, query.query),
        body = request_body(query.query),
        query = request_query(query.query),
        interface = client.interface,
        proxy = client.proxy,
        read_timeout = 60,
        connect_timeout = 60,
        status_exception = false,
    )
    @debug "received response" log_msg(client, query)... status_code = req.status headers =
        Serde.to_json(req.headers) response = String(view(req.body, 1:length(req.body)))
    return req
end

function prepare_json!(::Type{T}, json) where {T}
    return json
end

isretriable(::APIsResult{APIsUndefError}) = true
retry_timeout(e::APIsResult{APIsUndefError}) = e.response.headers.retry_after
retry_maxcount(::APIsResult{APIsUndefError})::Int64 = 1
isretriable(::Exception)::Bool = false
retry_timeout(::Exception)::Float64 = 1
retry_maxcount(::Exception)::Int64 = 10
isretriable(::CurlError)::Bool = true
retry_timeout(::CurlError)::Float64 = 10
retry_maxcount(::CurlError)::Int64 = 2
isretriable(e::APIsResult{<:Exception})::Bool = isretriable(e.result)
retry_timeout(e::APIsResult{<:Exception})::Real = retry_timeout(e.result)
retry_maxcount(e::APIsResult{<:Exception})::Int64 = retry_maxcount(e.result)

function (query::APIsRequest{T})(client::AbstractAPIsClient)::APIsResult where {T}
    fetch_data = try
        query.num_calls[] += 1
        response = perform_request(client, query)
        payload_data = try
            payload_json = Serde.parse_json(response.body)
            Serde.deser(T, prepare_json!(T, payload_json))
        catch ex
            err = try
                Serde.deser_json(error_type(client), response.body)
            catch
                APIsUndefError(ex, String(response.body))
            end
            headers = try
                Serde.deser(APIsHeaders, Dict(response.headers))
            catch ex
                @error ex
            end
            throw(APIsResult{typeof(err)}(client, query, APIsResponse(headers, response.status), err))
        end
        APIsResult{T}(client, query, nothing, payload_data)
    catch ex
        err = if ex isa APIsResult
            ex
        else
            APIsResult{typeof(ex)}(client, query, nothing, ex)
        end
        if isretriable(err) && retry_maxcount(err) >= query.num_calls[]
            @warn err log_msg(client, query)...
            sleep(retry_timeout(err))
            query(client)
        else
            err
        end
    end
    return iserror(fetch_data) ? throw(fetch_data) : fetch_data
end
