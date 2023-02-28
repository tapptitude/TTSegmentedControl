Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '13.0'
s.license = 'MIT'
s.name = "TTSegmentedControl"
s.summary = "An elegant, animated and customizable segmented control for iOS."
s.requires_arc = true
s.version = "0.5.0"
s.author = { "Igor Dumitru" => "igor.dumitru@tapptitude.com" }
s.homepage = "https://tapptitude.com/"
s.framework = "UIKit", "SwiftUI"
s.source = { :git => 'https://github.com/dumitruigor/TTSegmentedControl.git', :tag => s.version }
s.source_files = 'Sources/TTSegmentedControl/*.{swift}', 'Sources/TTSegmentedControl/Models/*.{swift}', 'Sources/TTSegmentedControl/Helpers/*.{swift}',
'Sources/TTSegmentedControl/Extensions/*.{swift}',
'Sources/TTSegmentedControl/Builders/*.{swift}'

end
