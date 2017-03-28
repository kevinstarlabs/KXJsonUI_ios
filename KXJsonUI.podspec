Pod::Spec.new do |s|
  s.name = "KXJsonUI"
  s.version = "0.8.0"

  s.homepage = "https://github.com/kxzen/KXJsonUI_ios"
  s.summary = "powerful Json UI layout framework for iOS"

  s.author = { 'kxzen' => 'kevinapp38@gmail.com' }
  s.license = { :type => "MIT", :file => "LICENSE.md" }
  
  s.platform = :ios, '8.0'
  s.ios.deployment_target = '8.0'

  s.source = { :git => "https://github.com/kxzen/KXJsonUI_ios.git", :tag => s.version }

  s.requires_arc = true

  s.source_files = 'KXJsonUI_ios/KXJsonUI_ios/**/*.{h,m,mm}'
  s.public_header_files = 'KXJsonUI_ios/KXJsonUI_ios/**/*.h'
  s.private_header_files = 'KXJsonUI_ios/KXJsonUI_ios/Private/**/*.h'
  s.frameworks = 'UIKit', 'QuartzCore'
  s.requires_arc = true
end
