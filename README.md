# CelerPod

## SDK via CocoaPods
```ruby
platform :ios, '12.0'

# You need to set target when you use CocoaPods 1.0.0 or later.
target 'SampleTarget' do
  use_frameworks!
  pod 'Celer', :git => 'https://github.com/celer-network/CelerPod.git'
end
```
Note: Currently, our framework does not support bitcode, please disable it.
```ruby
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['ENABLE_BITCODE'] = 'NO'
      end
    end
  end
