#
# Be sure to run `pod lib lint FFText.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FFText'
  s.version          = '0.1.1'
  s.summary          = '富文本控件'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
简单易用，支持多种功能的富文本显示控件。支持如下功能：
1、基础富文本显示
2、图文排布，支持插入自定义视图
3、自动识别号码、URL、邮箱地址
4、镂空区域
5、AutoLayout
6、自定义截断
7、垂直布局
                       DESC

  s.homepage         = 'https://github.com/ijinfeng/FFText'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jinfeng' => '851406283@qq.com' }
  s.source           = { :git => 'https://github.com/ijinfeng/FFText.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'FFText/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FFText' => ['FFText/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
