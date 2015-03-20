require 'spec_helper'

describe App do

  def app
    @app ||= App
  end

  describe " get urls" do

  	describe "/setup" do

			it "get endpoint added" do
      	setup_params = [{end_point: 'new/endpoint', method: 'get', response_body: "hahah", response_status: 200}]

				post '/setup', setup_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

				expect(last_response.status).to eq(200)
				expect(last_response.body).to eq([{success: true, message: 'GET new/endpoint status:200 added'}].to_json)
    	end

    	it "post endpoint added" do
      	setup_params = [{end_point: 'new/endpoint', method: 'post', response_body: "hahah", response_status: 200}]

	      post '/setup', setup_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

				expect(last_response.status).to eq(200)
				expect(last_response.body).to eq([{success: true, message: 'POST new/endpoint status:200 added'}].to_json)

    	end

    	it "payload malformed" do
      	setup_params = {end_point: 'new/endpoint', method: 'post', response_body: "hahah", response_status: 200}

	      post '/setup', setup_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

				expect(last_response.status).to eq(500)
				expect(last_response.body).to eq("Payload malformed, expecting array")
    	end

    		it "payload malformed nothing" do
      	setup_params = {end_point: 'new/endpoint', method: 'post', response_body: "hahah", response_status: 200}

	      post '/setup', "{", { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

				expect(last_response.status).to eq(500)
				expect(last_response.body).to eq("Payload malformed, json parse error: `{` is not json")
    	end


  		it "no endpoint error" do
      	setup_params = [{ method: 'get', response_body: "hahah", response_status: 500}]

      	post '/setup', setup_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

				expect(last_response.status).to eq(200)
				expect(last_response.body).to eq([{success: false, message: "`end_point` required"}].to_json)
    	end

  	end

  	describe "method GET" do
	    it " simple response body" do
	    	setup_params = [{end_point: 'new/endpoint', method: 'get', response_body: "hahah", response_status: 200}]
	      post '/setup', setup_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

				get '/new/endpoint'

				expect(last_response.status).to eq(200)
				expect(last_response.body).to eq("hahah")
	    end

	     it "simulate error response" do
	      setup_params = [{end_point: 'new/endpoint', method: 'get', response_body: "hahah", response_status: 500}]
	      post '/setup', setup_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

				get '/new/endpoint'

				expect(last_response.status).to eq(500)
				expect(last_response.body).to eq("hahah")
	    end

			it "no status assume 200" do
	     	setup_params = [{end_point: 'new/endpoint', method: 'get', response_body: "hahah"}]
	      post '/setup', setup_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

				get '/new/endpoint'

				expect(last_response.status).to eq(200)
				expect(last_response.body).to eq("hahah")
	    end

	     it "returns json response if asked" do
	     	json = {love: "is", all: "you", need: 1}
	     	setup_params = [{end_point: 'new/endpoint', method: 'get', response_body: json}]
	      post '/setup', setup_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

				get '/new/endpoint'

				expect(last_response.status).to eq(200)
				expect(last_response.body).to eq(json.to_json)
	    end
  	end



  	describe "method POST" do
	    it " simple response body" do
	    	setup_params = [{end_point: 'new/endpoint', method: 'post', response_body: "hahah", response_status: 200}]
	      post '/setup', setup_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

				post '/new/endpoint'

				expect(last_response.status).to eq(200)
				expect(last_response.body).to eq("hahah")
	    end

	     it "simulate error response" do
	      setup_params = [{end_point: 'new/endpoint', method: 'post', response_body: "hahah", response_status: 500}]
	      post '/setup', setup_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

				post '/new/endpoint'

				expect(last_response.status).to eq(500)
				expect(last_response.body).to eq("hahah")
	    end

			it "no status assume 200" do
	     	setup_params = [{end_point: 'new/endpoint', method: 'post', response_body: "hahah"}]
	      post '/setup', setup_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

				post '/new/endpoint'

				expect(last_response.status).to eq(200)
				expect(last_response.body).to eq("hahah")
	    end

	     it "returns json response if asked" do
	     	json = {love: "is", all: "you", need: 1}
	     	setup_params = [{end_point: 'new/endpoint', method: 'post', response_body: json}]
	      post '/setup', setup_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

				post '/new/endpoint'

				expect(last_response.status).to eq(200)
				expect(last_response.body).to eq(json.to_json)
	    end
  	end

  end
end

