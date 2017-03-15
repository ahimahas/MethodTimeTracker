//
//  NSObject+TRTMethodTracer.m
//  MSMethodTimeTracker
//
//  Created by ahimahas on 2017. 2. 15..
//  Copyright © 2017년 Coupang. All rights reserved.
//

#import "NSObject+MethodTimeTracker.h"
#import "NSObject+SwizzleMethods.h"
#import "MSSwizzleMethodStatics.h"
#import <objc/runtime.h>
#include <QuartzCore/QuartzCore.h>

//! Private Class for store measured value in category
@interface NSObject (MethodTimeTrackerPrivate)
@property (atomic, strong) NSMutableArray <NSDictionary *> *measuredValues;
@end


@implementation NSObject (MethodTimeTrackerPrivate)

- (void)setMeasuredValues:(NSMutableArray <NSDictionary *> *)measuredValues {
    objc_setAssociatedObject(self, &measuredMethodTimeValues, measuredValues, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray <NSDictionary *> *)measuredValues {
    return objc_getAssociatedObject(self, &measuredMethodTimeValues);
}

@end



@implementation NSObject (MethodTimeTracker)

- (void)trackingMethodWithSelector:(SEL)selector {
    [self trackingMethodWithSelectors:selector, nil];
}

- (void)trackingMethodWithSelectors:(SEL)selector, ... NS_REQUIRES_NIL_TERMINATION {
    va_list args;
    va_start(args, selector);
    NSMutableArray *selectors = [NSMutableArray new];
    for (SEL arg = selector; arg != nil; arg = va_arg(args, SEL)) {
        [selectors addObject:[NSValue valueWithPointer:arg]];
    }
    va_end(args);
    
    __block CFTimeInterval startTime;

    [self anonymousSwizzlingWithSelecotors:selectors preProcudure:^(NSString *methodName, NSArray<id> *arguments) {
        startTime = CACurrentMediaTime();
    } postProcudure:^(NSString *methodName, NSArray<id> *arguments) {
        NSLog(@"^ \t \"%@\" takes time: %f", methodName, CACurrentMediaTime() - startTime);
    }];
}

- (void)trackingMethod:(NSString *)method {
    [self trackingMethods:@[method]];
}

- (void)trackingMethods:(NSArray <NSString *> *)methods {
    __block CFTimeInterval startTime;
    
    [self anonymousSwizzlingAllWithMethodNames:methods preProcudure:^(NSString *methodName, NSArray<id> *arguments) {
        startTime = CACurrentMediaTime();
    } postProcudure:^(NSString *methodName, NSArray<id> *arguments) {
        NSLog(@"^ \t \"%@\" takes time: %f", methodName, CACurrentMediaTime() - startTime);
        
    }];
}

- (void)trackAllMethods {
    [self trackAllMethodsShowingLogDynamically:NO];
}

- (void)trackAllMethodsShowingLogDynamically {
    [self trackAllMethodsShowingLogDynamically:YES];
}

- (void)trackAllMethodsShowingLogDynamically:(BOOL)showLog {
    unsigned int outCount = 0;
    Method *methods = class_copyMethodList(object_getClass(self), &outCount);
    NSLog(@"^ \"%@\" has %d methods ===============================", NSStringFromClass([self class]), outCount);
    NSLog(@"^ {");
    
    NSMutableArray <NSString *> *methodNames = [NSMutableArray new];
    for(int i = 0; i < outCount; i++) {
        [methodNames addObject:[NSString stringWithUTF8String:sel_getName(method_getName(methods[i]))]];
        NSLog(@"^ \t \"%@\"", [NSString stringWithUTF8String:sel_getName(method_getName(methods[i]))]);
    }
    NSLog(@"^ }");
    
    if (showLog) {
        NSLog(@"^ Time to spend in each method:");
    }
    
    self.measuredValues = [NSMutableArray new];
    
    __block CFTimeInterval startTime;
    
    [self anonymousSwizzlingAllWithMethodNames:methodNames preProcudure:^(NSString *methodName, NSArray<id> *arguments) {
        startTime = CACurrentMediaTime();
    } postProcudure:^(NSString *methodName, NSArray<id> *arguments) {
        CFTimeInterval elapsedTime = CACurrentMediaTime() - startTime;
        [self.measuredValues addObject:@{methodName: [NSNumber numberWithFloat:elapsedTime]}];
        
        if (showLog) {
            NSLog(@"^ \t \"%@\" takes time: %f", methodName, elapsedTime);
        }
    }];
}

- (void)displayMethodTimeLogs {
    NSArray <NSDictionary *> *sortedValues = [self.measuredValues sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDictionary *obj1Dict = (NSDictionary *)obj1;
        NSDictionary *obj2Dict = (NSDictionary *)obj2;
        
        CGFloat obj1Value = [obj1Dict.allValues[0] floatValue];
        CGFloat obj2Value = [obj2Dict.allValues[0] floatValue];
        
        if (obj1Value > obj2Value) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if (obj1Value < obj2Value) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];

    NSLog(@"^ Time to spend in each method:");
    for (NSDictionary *sortedValue in sortedValues) {
        NSLog(@"^ \t %f sec spent in \"%@\"", [sortedValue.allValues[0] floatValue], sortedValue.allKeys[0]);
    }
}

@end







