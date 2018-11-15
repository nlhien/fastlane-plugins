module Fastlane
  module Actions
    module SharedValues
      BUILD_IOS_FRAMEWORK_CUSTOM_VALUE = :BUILD_IOS_FRAMEWORK_CUSTOM_VALUE
    end

    class BuildIosFrameworkAction < Action
      def self.lipo(params)
        output = params[:output]
        framework_name = params[:framework_name]
        iphoneos_framework = params[:iphoneos_framework]
        simulator_framework = params[:simulator_framework]

        # run lipo command
        Fastlane::Actions.sh(
          "xcrun lipo -create #{simulator_framework}/#{framework_name} #{iphoneos_framework}/#{framework_name} -output #{iphoneos_framework}/#{framework_name}",
          log: true)

        Fastlane::Actions.sh("/bin/rm -rf #{output}")

        Fastlane::Actions.sh("/bin/mkdir #{output}")

        # copy output folder.
        Fastlane::Actions.sh("/bin/cp -R #{iphoneos_framework} #{output}/", log: true)
      end

      def self.run(params)
        workspace =  params[:workspace]
        scheme =  params[:scheme]
        project =  params[:project]
        configuration = "Debug"

        if params.key? :configuration
          configuration = params[:configuration]
        end

        derivedDataPath = 'derivedData'
        if params.key? :derivedDataPath
          derivedDataPath = params[:derivedDataPath]
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

        lipo(
          output: output,
          framework_name: "#{scheme}",
          iphoneos_framework: iphoneos_framework,
          simulator_framework: simulator_framework, 
          )

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
          ['configuration', 'build configuration']
        ]
      end

      def self.is_supported?(platform)
        return [:ios].include?(platform)
      end
    end
  end
end
