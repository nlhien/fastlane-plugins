module Fastlane
  module Actions
    module SharedValues
      DELETE_GITHUB_RELEASE_CUSTOM_VALUE = :DELETE_GITHUB_RELEASE_CUSTOM_VALUE
    end

    class DeleteGithubReleaseAction < Action
      def self.run(params)

        release_id          = params[:release_id]
        api_token           = params[:api_token]
        repository          = params[:repository]
        server_url          = params[:server_url]
        tag_name            = params[:tag_name]

        UI.message("Deleting release on GitHub (#{params[:server_url]}/#{repository}: #{params[:release_id]})")
        
        # Deleting Release
        response = other_action.github_api(
          server_url: params[:server_url],
          api_token: params[:api_token],
          http_method: 'DELETE',
          path: "repos/#{repository}/releases/#{release_id}",
          error_handlers: {
            404 => proc do |result|
              UI.error("Repository #{repository} cannot be found, please double check its name and that you provided a valid API token (if it's a private repository).")
              return false              
            end,
            401 => proc do |result|
              UI.error("You are not authorized to access #{repository}, please make sure you provided a valid API token.")
              return false              
            end,
            '*' => proc do |result|
              UI.error("GitHub responded with #{result[:status]}:#{result[:body]}")
              return false
            end
        })
        # Deleting git tag
        response = other_action.github_api(
          server_url: params[:server_url],
          api_token: params[:api_token],
          http_method: 'DELETE',
          path: "repos/#{repository}/git/refs/tags/#{tag_name}",
          error_handlers: {
            404 => proc do |result|
              UI.error("Repository #{repository} cannot be found, please double check its name and that you provided a valid API token (if it's a private repository).")
              return false              
            end,
            401 => proc do |result|
              UI.error("You are not authorized to access #{repository}, please make sure you provided a valid API token.")
              return false              
            end,
            '*' => proc do |result|
              UI.error("GitHub responded with #{result[:status]}:#{result[:body]}")
              return false
            end
          })
        return true
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
        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :repository,
           env_name: "FL_GET_GITHUB_RELEASE_URL",
           description: "The path to your repo, e.g. 'KrauseFx/fastlane'",
           verify_block: proc do |value|
             UI.user_error!("Please only pass the path, e.g. 'KrauseFx/fastlane'") if value.include?("github.com")
             UI.user_error!("Please only pass the path, e.g. 'KrauseFx/fastlane'") if value.split('/').count != 2
           end),
          
          FastlaneCore::ConfigItem.new(key: :server_url,
           env_name: "FL_GITHUB_RELEASE_SERVER_URL",
           description: "The server url. e.g. 'https://your.github.server/api/v3' (Default: 'https://api.github.com')",
           default_value: "https://api.github.com",
           optional: true,
           verify_block: proc do |value|
             UI.user_error!("Please include the protocol in the server url, e.g. https://your.github.server") unless value.include?("//")
           end),
          
          FastlaneCore::ConfigItem.new(key: :release_id,
           env_name: "FL_GET_GITHUB_RELEASE_VERSION",
           is_string: false,
           description: "The id of the release to delete"),

          FastlaneCore::ConfigItem.new(key: :api_token,
           env_name: "FL_GITHUB_RELEASE_API_TOKEN",
           sensitive: true,
           description: "GitHub Personal Token (required for private repositories)",
           optional: true),

          FastlaneCore::ConfigItem.new(key: :tag_name,
           env_name: "FL_SUBMIT_GITHUB_RELEASE_DEVELOPMENT",
           description: "Create a development certificate instead of a distribution one")

        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['DELETE_GITHUB_RELEASE_CUSTOM_VALUE', 'A description of what this value contains']
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
        [:ios, :mac, :android].include?(platform)
      end
    end
  end
end
