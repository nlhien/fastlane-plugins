require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class IOSAppHelper
      # class methods that you define here become available in your action
      # as `Helper::IOSAppHelper.your_method`
      #
      def self.deploy(params)
        device_id       = params[:device_id]
        timeout         = params[:timeout]
        ipa             = params[:ipa]
        app_name        = params[:app_name]
        noninteractive  = params[:noninteractive]

        temp_dir = Dir.mktmpdir
        ipa_full_path = File.expand_path(ipa)

        Dir.chdir(temp_dir) do 
          result = Fastlane::Actions::sh("unzip -o -q #{ipa_full_path}")

          if $?.exitstatus.nonzero?
            raise "extract operation failed with exit code #{$?.exitstatus}"
          end

          app_path = "#{temp_dir}/Payload/#{app_name}.app"

          cmd = "ios-deploy --id #{device_id} --bundle #{app_path}"
          if noninteractive 
            cmd += "--noninteractive"
          end
          
          Fastlane::Actions::sh(cmd)
        end
      end

      def self.connected_devices
        result = Fastlane::Actions::sh("ios-deploy -c")
        devices = result.split("\n")
        regx = /(\[....\] Found )([a-zA-Z0-9]{40})(.+?a.k.a. ')(.+?(?=' connected through ))/

        connected_devices = []
        for i in 1..(devices.length-1)
          captures = regx.match(devices[i])
          phone_uuid = captures[2]
          phone_name = captures[4]

          connected_devices << {uuid: phone_uuid, name: phone_name}
        end

        return connected_devices
      end
    end
  end
end
