require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = "RNMediaManipulator"
  s.version      = package['version']
  s.summary      = package['description']

  s.authors      = "David Bjerremose"
  s.homepage     = package['homepage']
  s.license      = package['license']
  s.platform     = :ios, "9.0"

  s.module_name  = 'RNMediaManipulator'

  s.source       = { :git => "https://github.com/DaBs/react-native-media-manipulator.git" }
  s.source_files  = "ios/**/*.{h,m}"

  s.dependency 'React'
end
