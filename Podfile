# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ChatMe' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ChatMe
  pod 'Firebase'
	pod 'FirebaseAuth'
  pod 'FirebaseCore'
  pod 'FirebaseStorage'
	pod 'FirebaseFirestore'
	pod 'FirebaseAnalytics'
	pod 'FirebaseMessaging'
  pod 'FirebaseFirestoreSwift'
  
	pod 'Gallery'
	pod 'RealmSwift'
  
	pod 'ProgressHUD'
  pod 'SKPhotoBrowser'
  
  pod 'MessageKit'
	pod 'InputBarAccessoryView'
  
  post_install do |installer|
    # First action: Remove '-GCC_WARN_INHIBIT_ALL_WARNINGS' from BoringSSL-GRPC
    installer.pods_project.targets.each do |target|
      if target.name == 'BoringSSL-GRPC'
        target.source_build_phase.files.each do |file|
          if file.settings && file.settings['COMPILER_FLAGS']
            flags = file.settings['COMPILER_FLAGS'].split
            flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
            file.settings['COMPILER_FLAGS'] = flags.join(' ')
          end
        end
      end
    end

    # Second action: Set IPHONEOS_DEPLOYMENT_TARGET to '13.0'
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        end
      end
    end
  end
  
end
