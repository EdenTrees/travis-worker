require 'faraday'

module Travis
  module Worker
    module Job
      # Build configuration job: read .travis.yml and return it
      class Config < Base
        attr_reader :config

        def start
        end

        def update(data)
        end

        def finish
          payload = reporting_payload(:config => config)
          notify(:finish, payload)
        end

        protected

          def perform
            @config = fetch.merge('.configured' => true)
          end

          def fetch
            response = Faraday.new(nil, connection_options).get(url)
            response.success? ? parse(response.body) : {}
          end

          def url
            "#{repository.raw_url}/#{build.commit}/.travis.yml"
          end

          def parse(yaml)
            YAML.load(yaml) || {}
          rescue Exception => e
            # TODO should report this exception back as part of the log!
            {}
          end

        private

          def connection_options
            options = {}
            if Travis::Worker.config.ssl_ca_path
              options[:ssl] = { :ca_path => Travis::Worker.config.ssl_ca_path }
            else
              options[:ssl] = { :ca_file => File.expand_path('certs/cacert.pem') }
            end
            options
          end
      end
    end # Job
  end # Worker
end # Travis
