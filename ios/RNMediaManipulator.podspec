
Pod::Spec.new do |s|
  s.name         = "RNMediaManipulator"
  s.version      = "0.0.1"
  s.summary      = "RNMediaManipulator"
  s.description  = <<-DESC
                  RNMediaManipulator
                   DESC
  s.homepage     = ""
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "dab@davidbjerremose.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/DaBs/react-native-media-manipulator", :tag => "master" }
  s.source_files  = "**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end
