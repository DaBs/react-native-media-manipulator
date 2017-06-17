
Pod::Spec.new do |s|
  s.name         = "RNMediaManipulator"
  s.version      = "1.0.0"
  s.summary      = "RNMediaManipulator"
  s.description  = <<-DESC
                  RNMediaManipulator
                   DESC
  s.homepage     = ""
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "dab@davidbjerremose.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/DaBs/RNMediaManipulator.git", :tag => "master" }
  s.source_files  = "RNMediaManipulator/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end
