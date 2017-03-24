# MethodTimeTracker ![CocoaPods](https://img.shields.io/cocoapods/v/MethodTimeTracker.svg) ![Platform](https://img.shields.io/cocoapods/p/MethodTimeTracker.svg?style=flat)



MethodTimeTracker is a module that can measure a time to spend in each method.


# When can be used

If you felt that your application works a bit slow and you want to know where is the bottleneck in the code level, you are in the right place. 

Method time tracker measures for each method that how much time they spend. 
You can specify a single method you want to measure, or just check all methods in a class.


# Sample result

Here is the result of measuring all methods in Sample project.
The return value is a time in second.

![sameple screenshot](/Resources/screenshot.png)

# Installation
Use the [CocoaPods](https://github.com/CocoaPods/CocoaPods)
> pod 'MethodTimeTracker'

and import header file
> \#import \<NSObject+MethodTimeTracker.h\>

If you want to use MethodTimeTracker without setting CocoaPods, you can download codes in MethodTimeTracker folder directly and add it to your project.


# How to use

* Measure a single method 
```javascript
- (instancetype)init {
  ...
  
  //! with method name in String value
  [self trackingMethod:@"viewDidLoad"];
  
  //! or with method name in Selector
  [self trackingMethodWithSelector:@selector(viewDidLoad)];
}
```

* Measure multiple methods
```javascript
- (instancetype)init {
  ...
  
  //! with method name in String value
  [self trackingMethods:@[@"viewDidLoad", @"privateMethod:"]];
  
  //! or with method name in Selector
  [self trackingMethodWithSelectors:@selector(viewDidLoad), @selector(privateMethod:), nil];
}
```

* Measure all methods in class
```javascript
- (instancetype)init {
  ...
  
  //! measure all methods
  [self measureAllMethodsTime];
}
```

* Want to show all measured time with sorted
```javascript
//! at a point that you want to see logs.
//! The result will be shown sorted by desc order
...
[self showTrackedMethodTimeLogs];
...
```

![sameple screenshot](/Resources/screenshot_showAll.png)


# Release history: 1.2.1
- bug fix when swizzling dealloc method
