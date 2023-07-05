Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '15.0'
s.license = 'MIT'
s.name = "TTSegmentedControl"
s.summary = "An elegant, animated and customizable segmented control for iOS."
s.requires_arc = true
s.version = "0.4.10"
s.author = { "Igor Dumitru" => "igor.dumitru@tapptitude.com" }
s.homepage = "https://tapptitude.com/"
s.framework = "UIKit"
s.source = { :git => 'https://github.com/tapptitude/TTSegmentedControl.git', :tag => s.version }
s.source_files = 'TTSegmentedControl/*.{swift}'
s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }

end
