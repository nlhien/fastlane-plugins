module Fastlane
  module Actions
    module SharedValues
      UPLOAD_BUILD_TO_TESTER_CUSTOM_VALUE = :UPLOAD_BUILD_TO_TESTER_CUSTOM_VALUE
    end

    class UploadBuildToTesterAction < Action
      def self.run(params)
        require 'rest-client'

        appid         = params[:appid]
        build_version = params[:version]
        build_number  = params[:build_number]
        auth          = params[:auth]
        url           = params[:url]
        file          = params[:file]

        request = RestClient::Request.new(
          :method => :post,
          :url => "#{url}/api/app/#{appid}",
          :user => auth[:username],
          :password => auth[:password],
          :payload => {
            :multipart => true,
            :installfile => File.new(file, 'rb'),
            :subtitle => build_number,
            :version => build_version
          })

        begin
          response = request.execute
        rescue RestClient::ExceptionWithResponse => err
          UI.user_error! err.response
        end
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
        [
          ['appid', 'The authentication info: username:token'],
          ['build_version', 'The Jenkins URL'],
          ['build_number', 'The Job name to update description'],
          ['auth', 'The jenkin build number'],
          ['url', 'The description to submit'],
          ['file_url', 'The description to submit']
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['UPLOAD_BUILD_TO_TESTER_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        ["Hien Nguyen"]
      end

      def self.is_supported?(platform)
        [:ios, :android].include?(platform)
      end
    end
  end
end
