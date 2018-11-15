module Fastlane
  module Actions
    module SharedValues
      SUBMIT_JENKINS_DESCRIPTION_CUSTOM_VALUE = :SUBMIT_JENKINS_DESCRIPTION_CUSTOM_VALUE
    end

    class SubmitJenkinsDescriptionAction < Action
      def self.run(params)
        require 'rest-client'

        auth        = params[:auth]
        url         = params[:url]
        job         = params[:job]
        build       = params[:build]

        begin
          UI.message("Submit description: #{params[:description]}")
          response = RestClient::Request.execute(
            :method => :post,
            :url => "#{url}/job/#{job}/#{build}/submitDescription",
            :user => auth[:username],
            :password => auth[:token],
            :payload => {
              :multipart => true,
              :description => params[:description]
            })
        rescue RestClient::ExceptionWithResponse => err
          UI.error(err.to_s)
          return 1
        end

        UI.message("Update build description success!!!")
        return 0
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
          ['auth', 'The authentication info: username:token'],
          ['url', 'The Jenkins URL'],
          ['job', 'The Job name to update description'],
          ['build', 'The jenkin build number'],
          ['description', 'The description to submit']
        ]
      end

      def self.output
        return []
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        ["Hien Nguyen"]
      end

      def self.is_supported?(platform)
        [:ios, :mac, :android].include?(platform)
      end
    end
  end
end
