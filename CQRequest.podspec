#
# Be sure to run `pod lib lint CWGJRequest.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CQRequest'
  s.version          = '1.0.1'
  s.summary          = 'An smart request component.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/luchunqing/CQRequest.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luchunqing' => '357406094@qq.com' }
  s.source           = { :git => 'https://github.com/luchunqing/CQRequest.git', :tag => s.version }

  s.ios.deployment_target = '8.0'

  s.source_files = 'CQRequest/*.{h,m}'

  s.public_header_files = 'CQRequest/*.h'
  s.dependency 'AFNetworking'
#  s.dependency 'YYModel'
end
