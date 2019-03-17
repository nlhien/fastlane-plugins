module Fastlane
  module Actions
    module SharedValues
      BUILD_IOS_FRAMEWORK_CUSTOM_VALUE = :BUILD_IOS_FRAMEWORK_CUSTOM_VALUE
    end

    class BuildIosFrameworkAction < Action
      def self.run(params)
        workspace     =  params[:workspace]
        scheme        =  params[:scheme]
        project       =  params[:project]
        configuration = "Debug"

        if params.key? :configuration
          configuration = params[:configuration]
        end

        derivedDataPath = 'derivedData'
        if params.key? :derived_data_path
          derivedDataPath = params[:derived_data_path]
        end

        Fastlane::Actions::ClearDerivedDataAction.run(
          derived_data_path: derivedDataPath)

        # Build iphone
        Fastlane::Actions::XcodebuildAction.run(
          workspace: workspace,
          project: project,
          scheme: scheme,
          configuration: configuration,
          build: true,
          derivedDataPath: derivedDataPath,
          sdk: 'iphoneos')

        # Build iphonesimulator
        Fastlane::Actions::XcodebuildAction.run(
          workspace: workspace,
          project: project,
          scheme: scheme,
          configuration: configuration,
          build: true,
          derivedDataPath: derivedDataPath,
          sdk: 'iphonesimulator')

        iphoneos_framework = "#{derivedDataPath}/Build/Products/#{configuration}-iphoneos/#{scheme}.framework"
        simulator_framework = "#{derivedDataPath}/Build/Products/#{configuration}-iphonesimulator/#{scheme}.framework"

        output = "output"
        if params.key? :output_dir
          output = "#{params[:output_dir]}"
        end

        Helper::IOSFrameworkHelper.lipo(
          output: output,
          framework_name: "#{scheme}",
          iphoneos_framework: iphoneos_framework,
          simulator_framework: simulator_framework)

        Fastlane::Actions::ClearDerivedDataAction.run(derived_data_path: derivedDataPath)
      end

      def self.description
        "Fossil Build Utils"
      end

      def self.authors
        ["Hien Nguyen"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        ""
      end

      def self.available_options
        [
          ['workspace', 'The workspace to use'],
          ['scheme', 'The scheme to build'],
          ['configuration', 'build configuration'],
          ['derived_data_path', 'Derived data path'],
          ['output_dir', 'Output dir']
        ]
      end

      def self.is_supported?(platform)
        return [:ios].include?(platform)
      end
    end
  end
end
