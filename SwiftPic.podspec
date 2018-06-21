#
# Be sure to run `pod lib lint SwiftPic.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftPic'
  s.version          = '0.2.1'
  s.summary          = 'Image viewer/gallery built in Swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
An Image viewer and gallery built in swift, inspired by the iOS Photos app.
DESC

  s.homepage         = 'https://github.com/k2minc/SwiftPic.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'abrown252@gmail.com' => 'abrown252@gmail.com' }
  s.source           = { :git => 'https://github.com/k2minc/SwiftPic.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/alex_brown23'

  s.ios.deployment_target = '9.0'

  s.source_files = 'SwiftPic/Classes/**/*'
  
  s.resources = 'SwiftPic/Assets/*.xcassets'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
