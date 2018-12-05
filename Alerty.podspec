#pod lib lint Alerty.podspec

Pod::Spec.new do |s|
  s.name = 'Alerty'
  s.version = '0.2.0'
  s.license = 'MIT'
  s.summary = 'An object that displays an alert message to the user.'
  s.homepage = 'https://github.com/mahmutpinarbasi/Alerty.git'
  s.authors = { 'Mahmut Pınarbaşı' => 'pinarbasimahmut@gmail.com' }
  s.source = { :git => 'https://github.com/mahmutpinarbasi/Alerty.git', :tag => s.version }
  s.ios.deployment_target = '10.0'
  s.source_files = 'Alerty/Classes/**/*.swift'
  s.resource_bundles = { 'Alerty' => [ "Alerty/**/*.{xib,png,lproj/Localizable.strings}"] }
  s.swift_version = "4.2"
end
