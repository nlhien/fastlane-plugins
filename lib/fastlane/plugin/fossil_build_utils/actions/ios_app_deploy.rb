module Fastlane
  module Actions
    module SharedValues
      IOS_APP_DEPLOY_CUSTOM_VALUE = :IOS_APP_DEPLOY_CUSTOM_VALUE
    end

    class IosAppDeployAction < Action
      def self.run(params)
        phone_name      = params[:phone_name]
        phone_uuid      = params[:phone_uuid]
        ipa             = params[:ipa]
        app_name        = params[:app_name]

        if phone_name == nil and phone_uuid == nil
          self.available_options()
          UI.user_error!('Please...')
        end
        
        if phone_uuid != nil
          Helper::IOSAppHelper.deploy(device_id: phone_uuid, ipa: ipa, app_name: app_name)
        end

        connected_devices = Helper::IOSAppHelper.connected_devices()

        if phone_uuid == nil
          for it in connected_devices
            uuid = it[:uuid]
            name = it[:name]

            if phone_name.start_with?(name)
              phone_uuid = uuid
              break
            end
          end
        end

        if phone_uuid == nil
          UI.user_error!('Phone not found')
        end

        Helper::IOSAppHelper.deploy(device_id: phone_uuid, ipa: ipa, app_name: app_name)
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
        [
          FastlaneCore::ConfigItem.new(key: :ipa,
                                       description: "API to deploy", # a short description of this parameter
                                       verify_block: proc do |value|
                                        UI.user_error!("No ipa, pass using `ipa: 'ipa_path'`") unless (value and not value.empty?)
                                      end),
          FastlaneCore::ConfigItem.new(key: :app_name,
           description: "App name",
           is_string: true,
           default_value: false),
          FastlaneCore::ConfigItem.new(key: :phone_uuid,
           description: "Phone UUID",
           is_string: true,
           default_value: false),
          FastlaneCore::ConfigItem.new(key: :phone_name,
           description: "Phone Name",
           is_string: true,
           default_value: false),
        ]
      end

      def self.output
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
