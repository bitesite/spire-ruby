module Spire
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a spire initializer."

      def setup_initializer
        template "spire.rb", "config/initializers/spire.rb"

        if yes?("\nAre you using the dotenv-rails gem to store your environment variables?")
          gsub_file "config/initializers/spire.rb", /(config\.company.+)/, "config.company = ENV['SPIRE_COMPANY']"
          gsub_file "config/initializers/spire.rb", /(config\.username.+)/, "config.username = ENV['SPIRE_USERNAME']"
          gsub_file "config/initializers/spire.rb", /(config\.password.+)/, "config.password = ENV['SPIRE_PASSWORD']"
          gsub_file "config/initializers/spire.rb", /(config\.host.+)/, "config.host = ENV['SPIRE_HOST']"
          gsub_file "config/initializers/spire.rb", /(config\.port.+)/, "config.port = ENV['SPIRE_PORT']"

          if yes?("\nDo you have the Spire configuration variables?")
            spire_company = ask("Spire Company:")
            spire_host = ask("Spire Host:")
            spire_port = ask("Spire Port:")
            spire_username = ask("Spire Username:")
            spire_password = ask("Spire Password:")

            spire_env_vars = <<~EOF
              SPIRE_COMPANY=#{spire_company}
              SPIRE_HOST=#{spire_host}
              SPIRE_PORT=#{spire_port}
              SPIRE_USERNAME=#{spire_username}
              SPIRE_PASSWORD=#{spire_password}
            EOF

            if File.file?(".env")
              inject_into_file ".env", spire_env_vars
            else
              create_file ".env", spire_env_vars
            end
          end
        end
      end
    end
  end
end
