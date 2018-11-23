module Fastlane
  module Actions
    module SharedValues
      SETUP_PODSPECS_REPO_CUSTOM_VALUE = :SETUP_PODSPECS_REPO_CUSTOM_VALUE
    end

    class SetupPodspecsRepoAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        repos = Actions.sh('bundle exec pod repo list')
        if repos.include? params[:name]
          return true
        end
        
        return Actions.sh("pod repo add #{params[:name]} #{params[:url]}")
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
          FastlaneCore::ConfigItem.new(key: :url, default_value: false),
          FastlaneCore::ConfigItem.new(key: :name, default_value: false),
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['SETUP_PODSPECS_REPO_CUSTOM_VALUE', 'A description of what this value contains']
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
        platform == :ios
      end
    end
  end
end
