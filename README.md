KXJsonUI
===

[![Pod Version](http://img.shields.io/cocoapods/v/KXJsonUI.svg?style=flat)](http://cocoadocs.org/docsets/KXJsonUI)
[![Pod Platform](http://img.shields.io/cocoapods/p/KXJsonUI.svg?style=flat)](http://cocoadocs.org/docsets/KXJsonUI)
[![Pod License](http://img.shields.io/cocoapods/l/KXJsonUI.svg?style=flat)](http://opensource.org/licenses/MIT)

KXJsonUI is a JSON layout framework for iOS, which enables you contstruct your user interfaces using JSON files. You can build your UI without using interface builder.

# Features
- Create and manage UIViews using Json
- Supports RelativeLayout and LinearLayout
- Suppports rotations
- Supports adding unknown view class
- Supports dynamic change layouts
- Works with ARC and iOS >= 8.0 

# Installation

### CocoaPods
The easiest way of installing KXJsonUI is via [CocoaPods](http://cocoapods.org/). 

```
pod 'KXJsonUI'
```

### Old-fashioned way

- Add all subfolders and *.h, *.m, *.mm from folder `KXJsonUI_ios/KXJsonUI_ios/` to your project.
- Add `QuartzCore.framework` to your linked frameworks.
- `#import "KXJsonUI_ios.h"` where you want to add the control.
