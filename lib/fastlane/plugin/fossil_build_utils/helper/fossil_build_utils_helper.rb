require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class FossilBuildUtilsHelper
      # class methods that you define here become available in your action
      # as `Helper::FossilBuildUtilsHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the fossil_build_utils plugin helper!")
      end
    end
  end
end
