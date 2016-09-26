Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '8.0'
s.name = "TTSegmentedControl"
s.summary = "Customizeble segmented control for iOs."
s.requires_arc = true
s.version = "0.1.0"
s.author = { "Igor Dumitru" => "igor.dumitru@tapptitude.com" }
s.homepage = "www.tapptitude.com"
s.framework = "UIKit"
s.source = { :git => 'https://bitbucket.org/tapptitude/tapptitude-swift.git' }
s.source_files = 'TTSegmentedControl/*.{swift}'

end