#
# Be sure to run `pod lib lint SwiftPic.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftPic'
  s.version          = '0.1.0'
  s.summary          = 'A short description of SwiftPic.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/k2minc/SwiftPic.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'abrown252@gmail.com' => 'abrown252@gmail.com' }
  s.source           = { :git => 'https://github.com/k2minc/SwiftPic.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/alex_brown23'

  s.ios.deployment_target = '9.0'

  s.source_files = 'SwiftPic/Classes/**/*'
  
  s.resource_bundles = {
    'SwiftPic' => ['SwiftPic/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
