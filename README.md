# MethodTimeTracker 

MethodTimeTracker is a module that can measure a time to spend in each method.


# When can be used

If you felt that your application works a bit slow and you want to know where is the bottleneck in the code level, you are in right place. 

Method time tracker measures for each method that how much time they spend. 
You can specify a single method you want to measure, or just check all methods in a class.


# Sample result

Here is the result of measuring all methods in Sample project.
The return value is a time in second.

![sameple screenshot](/Resources/screenshot.png)


# How to use

* Measure a single method 
```javascript
#import "NSObject+MethodTimeTracker.h"

//! in init method
- (instancetype)init {
  //! with method name in String value
  [self trackingMethod:@"viewDidLoad"];
  
  //! or with method name in Selector
  [self trackingMethodWithSelector:@selector(viewDidLoad)];
}
```

* Measure multiple methods
```javascript
#import "NSObject+MethodTimeTracker.h"

//! in init method
- (instancetype)init {
  //! with method name in String value
  [self trackingMethods:@[@"viewDidLoad", @"privateMethod:"]];
  
  //! or with method name in Selector
  [self trackingMethodWithSelectors:@selector(viewDidLoad), @selector(privateMethod:), nil];
}
```

* Measure all methods in class
```javascript
#import "NSObject+MethodTimeTracker.h"

//! in init method
- (instancetype)init {
  //! measure all methods
  [self trackAllMethods];
}
```


