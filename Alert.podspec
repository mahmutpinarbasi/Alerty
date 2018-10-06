#pod lib lint Alert.podspec

Pod::Spec.new do |s|
  s.name = 'Alert'
  s.version = '0.1.0'
  s.license = 'MIT'
  s.summary = 'An object that displays an alert message to the user.'
  s.homepage = 'https://github.com/mahmutpinarbasi/Alert.git'
  s.authors = { 'Mahmut Pınarbaşı' => 'pinarbasimahmut@gmail.com' }
  s.source = { :git => 'https://github.com/mahmutpinarbasi/Alert.git', :tag => s.version }
  s.ios.deployment_target = '10.0'
  s.source_files = 'Alert/Classes/**/*.swift'
  s.resource_bundles = { 'Alert' => [ "Alert/**/*.{xib,png,lproj/Localizable.strings}"] }
  s.swift_version = "4.2"
end
