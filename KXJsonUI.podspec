Pod::Spec.new do |spec|
  spec.name = "KXJsonUI"
  spec.version = "0.8.0"

  spec.homepage = "https://github.com/kxzen/KXJsonUI_ios"
  spec.summary = "powerful Json UI layout framework for iOS"

  spec.author = { 'kxzen' => 'kevinapp38@gmail.com' }
  spec.license = { :type => "MIT", :file => "LICENSE.md" }
  
  spec.platform = :ios, '8.0'
  spec.ios.deployment_target = '8.0'

  spec.source = { :git => "https://github.com/kxzen/KXJsonUI_ios.git", :tag => spec.version }

  spec.requires_arc = true

  spec.source_files = 'KXJsonUI_ios/KXJsonUI_ios/**/*'
  spec.public_header_files = 'KXJsonUI_ios/Pod/PublicHeaders/**/*.h'
  spec.frameworks = 'UIKit', 'QuartzCore'
  spec.requires_arc = true
end
