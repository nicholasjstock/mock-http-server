

require 'json'
class App < Sinatra::Base

  configure do
  	@@get_endpoints = {}
    @@post_endpoints = {}
	end

  def build_success_message_from_endpoint(endpoint_payload)
    endpoint_payload['method'].upcase + " " + endpoint_payload['end_point'] + " status:" + endpoint_payload['response_status'].to_s + " added"
  end
  def single_endppint_setup(endpoint_payload)
    if endpoint_payload['response_status'] == nil
      endpoint_payload['response_status'] = 200
    end

    if (endpoint_payload['end_point'].class != String)
      return {success: false, message: "`end_point` required"}
    else
      if (endpoint_payload['method'].downcase === 'post')
         @@post_endpoints[endpoint_payload['end_point']] = {body: endpoint_payload['response_body'], status: endpoint_payload['response_status']}
      else
        @@get_endpoints[endpoint_payload['end_point']] = {body: endpoint_payload['response_body'], status: endpoint_payload['response_status']}
      end
      return {success: true, message: build_success_message_from_endpoint(endpoint_payload)}
    end
  end

  def setup
  	request.body.rewind
    params = request.body.read
    begin
      json_params = JSON.parse params
    rescue
      status 500
      body "Payload malformed, json parse error: `"+ params + "` is not json"
      return
    end

    if (json_params.class != Array)
      status 500
      body "Payload malformed, expecting array"
      return
    end

    retun_value = json_params.collect do |x|
      single_endppint_setup(x)
    end
    status 200
    body retun_value.to_json
  end

  def hanle_request(end_points)
  	status end_points[params['splat'][0]][:status]
  	if end_points[params['splat'][0]][:body].class == String
	  		body end_points[params['splat'][0]][:body]
  	else
  		  body end_points[params['splat'][0]][:body].to_json
  	end
	end

  get '/*' do
    hanle_request(@@get_endpoints)
  end

	post '/*' do
		if (params['splat'][0] === "setup")
  		setup
  	else
      hanle_request(@@post_endpoints)
    end
  end
end