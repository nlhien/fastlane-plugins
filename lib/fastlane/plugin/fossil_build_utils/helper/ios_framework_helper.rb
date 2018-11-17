require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class IOSFrameworkHelper
      # class methods that you define here become available in your action
      # as `Helper::IOSFrameworkHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the fossil_build_utils plugin helper!")
      end

      def self.lipo(params)
        output = params[:output]
        framework_name = params[:framework_name]
        iphoneos_framework = params[:iphoneos_framework]
        simulator_framework = params[:simulator_framework]

        Fastlane::Actions::sh("/bin/rm -rf #{output}")
        Fastlane::Actions::sh("/bin/mkdir #{output}")
        
        # run lipo command
        Fastlane::Actions::sh("xcrun lipo -create #{simulator_framework}/#{framework_name} #{iphoneos_framework}/#{framework_name} -output #{iphoneos_framework}/#{framework_name}",
          log: true)
        # copy output folder.
        Fastlane::Actions::sh("/bin/cp -R #{iphoneos_framework} #{output}/", log: true)
      end
    end
  end
end
