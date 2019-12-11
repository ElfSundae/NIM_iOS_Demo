DEPLOYMENT_VERSION = '9.0'.freeze
DEPLOYMENT_TARGET_KEY = 'IPHONEOS_DEPLOYMENT_TARGET'.freeze
PODS_MIN_DEPLOYMENT_VERSION = '9.0'.freeze

platform :ios, DEPLOYMENT_VERSION

target 'NIMDemo' do
    pod 'NIMKit/Full_Free', '~> 2.12'
    pod 'Toast', '~> 3.0'

    pod 'SDWebImageFLPlugin'
    pod 'FMDB', '~> 2.7'
    pod 'Reachability', '~> 3.2'
    pod 'CocoaLumberjack', '~> 3.2'
    pod 'SSZipArchive', '~> 1.8'
    pod 'SVProgressHUD', '~> 2.1'
    pod 'Fabric'
    pod 'Crashlytics'
end

# https://github.com/CocoaPods/CocoaPods/issues/7314#issuecomment-489453484
def fix_deployment_targets(installer)
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configuration_list.build_configurations.each do |config|
        if config.build_settings[DEPLOYMENT_TARGET_KEY].to_f < PODS_MIN_DEPLOYMENT_VERSION.to_f
          config.build_settings[DEPLOYMENT_TARGET_KEY] = PODS_MIN_DEPLOYMENT_VERSION
          # puts "Successfully set #{DEPLOYMENT_TARGET_KEY} of target #{target.name} for config #{config.display_name} to #{PODS_MIN_DEPLOYMENT_VERSION}"
        end
      end
    end
  end
end

post_install do |installer|
  fix_deployment_targets installer
end
