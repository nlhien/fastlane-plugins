module Fastlane
  module Actions
    module SharedValues
      SUBMIT_GITHUB_RELEASE_CUSTOM_VALUE = :SUBMIT_GITHUB_RELEASE_CUSTOM_VALUE
    end

    class SubmitGithubReleaseAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        version             = params[:version]
        branch_name         = params[:branch_name]
        is_prerelease       = params[:is_prerelease]
        api_token           = params[:api_token]
        repository          = params[:repository]
        server_url          = params[:server_url]
        allow_override      = params[:allow_override]

        release = other_action.get_github_release(url: repository, 
          version: version, api_token: api_token, server_url: server_url)

        if release
          if !allow_override
            if !UI.confirm("The release #{version} already exists. Do you want to override?")
              return nil
            end
          end

          release_id = release['id']
          UI.message("Removing the exists release with id: #{release_id}")
          result = other_action.delete_github_release(
            repository: repository,
            server_url: server_url,
            api_token: api_token,
            release_id: release_id,
            tag_name: "#{version}")
          
          if result == false
            UI.message("Failed to delete release")
            return nil
          end
        end

        return other_action.set_github_release(
          repository_name: repository,
          api_token: api_token,
          is_prerelease: is_prerelease,
          commitish: branch_name,
          description: (File.read("changelog") rescue "No changelog provided"),
          name: "#{version}",
          tag_name: "#{version}")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "A short description with <= 80 characters of what this action does"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "You can use this action to do cool things..."
      end

      def self.available_options
        # Define all options your action supports. 
        
        # Below a few examples
        [

          FastlaneCore::ConfigItem.new(key: :api_token,
                                       env_name: "FL_SUBMIT_GITHUB_RELEASE_API_TOKEN", # The name of the environment variable
                                       description: "API Token for SubmitGithubReleaseAction", # a short description of this parameter
                                       verify_block: proc do |value|
                                        UI.user_error!("No API token for SubmitGithubReleaseAction given, pass using `api_token: 'token'`") unless (value and not value.empty?)
                                          # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                        end),

          FastlaneCore::ConfigItem.new(key: :version,
           env_name: "FL_SUBMIT_GITHUB_RELEASE_DEVELOPMENT",
           description: "Create a development certificate instead of a distribution one",
                                       is_string: false, # true: verifies the input is a string, false: every kind of value
                                       default_value: false), # the default value if the user didn't provide one

          FastlaneCore::ConfigItem.new(key: :branch_name,
           env_name: "FL_SUBMIT_GITHUB_RELEASE_DEVELOPMENT",
           description: "Create a development certificate instead of a distribution one",
                                       is_string: false, # true: verifies the input is a string, false: every kind of value
                                       default_value: "master"), # the default value if the user didn't provide one

          FastlaneCore::ConfigItem.new(key: :is_prerelease,
           env_name: "FL_SUBMIT_GITHUB_RELEASE_DEVELOPMENT",
           description: "Create a development certificate instead of a distribution one",
                                       is_string: false, # true: verifies the input is a string, false: every kind of value
                                       default_value: false), # the default value if the user didn't provide one

          FastlaneCore::ConfigItem.new(key: :repository,
           env_name: "FL_SUBMIT_GITHUB_RELEASE_DEVELOPMENT",
           description: "Create a development certificate instead of a distribution one",
                                       is_string: true), # the default value if the user didn't provide one

          FastlaneCore::ConfigItem.new(key: :server_url,
           env_name: "FL_GITHUB_RELEASE_SERVER_URL",
           description: "The server url. e.g. 'https://your.github.server/api/v3' (Default: 'https://api.github.com')",
           default_value: "https://api.github.com",
           optional: true,
           verify_block: proc do |value|
             UI.user_error!("Please include the protocol in the server url, e.g. https://your.github.server") unless value.include?("//")
           end),

          FastlaneCore::ConfigItem.new(key: :allow_override,
           env_name: "FL_SUBMIT_GITHUB_RELEASE_DEVELOPMENT",
           description: "Allow to delete the current release",
                                       is_string: false, # true: verifies the input is a string, false: every kind of value
                                       default_value: false), # the default value if the user didn't provide one
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['SUBMIT_GITHUB_RELEASE_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["Your GitHub/Twitter Name"]
      end

      def self.is_supported?(platform)
        # you can do things like
        # 
        #  true
        # 
        #  platform == :ios
        # 
        #  [:ios, :mac].include?(platform)
        # 

        platform == :ios
      end
    end
  end
end
