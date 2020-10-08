module Spire
  Request = Struct.new "Request", :verb, :uri, :headers, :body, :user, :password
  Response = Struct.new "Response", :code, :headers, :body

  class SInternet
    class << self
      require "rest_client"

      def execute(request)
        try_execute request
      end

      private
        def try_execute(request)
          begin
            if request
              result = execute_core request
              body = result.body

              if request.verb == :post && result.headers[:location]
                body = { id: result.headers[:location].split("/").last }.to_json
              end

              Response.new(200, result.headers, body)
            end
          rescue RestClient::Exception => e
            raise if !e.respond_to?(:http_code) || e.http_code.nil?
            Response.new(e.http_code, {}, e.http_body)
          end
        end

        def execute_core(request)
          RestClient.proxy = ENV['HTTP_PROXY'] if ENV['HTTP_PROXY']
          RestClient::Request.execute(
            method: request.verb,
            url: request.uri.to_s,
            headers: request.headers,
            payload: request.body.to_json,
            user: request.user,
            password: request.password,
            verify_ssl: false,
            timeout: 10
          )
        end
    end
  end
end