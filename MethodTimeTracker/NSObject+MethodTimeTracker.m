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
    BOOL hasDeallocMethod = NO;
    
    for (SEL arg = selector; arg != nil; arg = va_arg(args, SEL)) {
        [selectors addObject:[NSValue valueWithPointer:arg]];
        if ([NSStringFromSelector(arg) isEqualToString:@"dealloc"]) {
            hasDeallocMethod = YES;
        }
    }
    va_end(args);
    
    if (hasDeallocMethod == NO) {
        [selectors addObject:[NSValue valueWithPointer:NSSelectorFromString(@"dealloc")]];
    }
    
    __block CFTimeInterval startTime;

    [self anonymousSwizzlingWithSelecotors:selectors preProcudure:^(NSString *methodName, NSArray<id> *arguments) {
        startTime = CACurrentMediaTime();
    } postProcudure:^(NSString *methodName, NSArray<id> *arguments) {
        NSLog(@"^ \t %f sec spent in \"%@\"", CACurrentMediaTime() - startTime, methodName);
    }];
}

- (void)trackingMethod:(NSString *)method {
    [self trackingMethods:@[method]];
}

- (void)trackingMethods:(NSMutableArray <NSString *> *)methods {
    __block CFTimeInterval startTime;
    
    if ([methods containsObject:@"dealloc"] == NO) {
        [methods addObject:@"dealloc"];
    }
    
    [self anonymousSwizzlingAllWithMethodNames:methods preProcudure:^(NSString *methodName, NSArray<id> *arguments) {
        startTime = CACurrentMediaTime();
    } postProcudure:^(NSString *methodName, NSArray<id> *arguments) {
        NSLog(@"^ \t %f sec spent in \"%@\"", CACurrentMediaTime() - startTime, methodName);
    }];
}

- (void)measureAllMethodsTime {
    [self trackAllMethodsShowingLogDynamically:YES];
}

- (void)trackAllMethodsShowingLogDynamically:(BOOL)showLog {
    unsigned int outCount = 0;
    Method *methods = class_copyMethodList(object_getClass(self), &outCount);
    NSMutableArray <NSString *> *methodNames = [NSMutableArray new];
    
    for(int i = 0; i < outCount; i++) {
        NSString *methodName = [NSString stringWithUTF8String:sel_getName(method_getName(methods[i]))];
        if ([methodName isEqualToString:@".cxx_destruct"]) {
            continue;
        }
        
        [methodNames addObject:methodName];
    }
    
    //! add "dealloc" method if it doesn't have
    if ([methodNames containsObject:@"dealloc"] == NO) {
        [methodNames addObject:@"dealloc"];
    }
    
    if (showLog) {
        NSLog(@"^ Time to spend in each method:");
    }
    
    self.measuredValues = [NSMutableArray new];
    
    __block CFTimeInterval startTime;
    
    __weak typeof(self) weakSelf = self;
    [self anonymousSwizzlingAllWithMethodNames:methodNames preProcudure:^(NSString *methodName, NSArray<id> *arguments) {
        startTime = CACurrentMediaTime();
    } postProcudure:^(NSString *methodName, NSArray<id> *arguments) {
        CFTimeInterval elapsedTime = CACurrentMediaTime() - startTime;
        [weakSelf.measuredValues addObject:@{methodName: [NSNumber numberWithFloat:elapsedTime]}];
        
        if (showLog) {
            NSLog(@"^ \t %f sec spent in \"%@\"", elapsedTime, methodName);
        }
    }];
}

- (void)showTrackedMethodTimeLogs {
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

    NSLog(@"^ =====================");
    NSLog(@"^ Time to spend in each method (sorted by desc):");
    for (NSDictionary *sortedValue in sortedValues) {
        NSLog(@"^ \t %f sec spent in \"%@\"", [sortedValue.allValues[0] floatValue], sortedValue.allKeys[0]);
    }
    NSLog(@"^ =====================");
}

@end







