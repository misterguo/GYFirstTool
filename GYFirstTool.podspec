#
# Be sure to run `pod lib lint GYFirstTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GYFirstTool'
  s.version          = '0.1.3'
  s.summary          = 'A short description of GYFirstTool.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/misterguo/GYFirstTool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '18332122278' => '1258126099@qq.com' }
  s.source           = { :git => 'https://github.com/misterguo/GYFirstTool.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
  s.source_files = 'GYFirstTool/Classes/**/*'
  
  # s.resource_bundles = {
  #   'GYFirstTool' => ['GYFirstTool/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit', 'Foundation'
   s.dependency 'Alamofire'
   s.dependency 'KakaJSON'
   s.dependency 'FCUUID'
   s.dependency 'SystemServices'
   s.dependency 'QMUIKit'
   s.dependency 'SnapKit'
end
