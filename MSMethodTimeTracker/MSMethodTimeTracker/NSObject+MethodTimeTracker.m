//
//  NSObject+TRTMethodTracer.m
//  MSMethodTimeTracker
//
//  Created by ahimahas on 2017. 2. 15..
//  Copyright © 2017년 Coupang. All rights reserved.
//

#import "NSObject+MethodTimeTracker.h"
#import "NSObject+SwizzleMethods.h"
#import <objc/runtime.h>
#include <QuartzCore/QuartzCore.h>

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
        NSLog(@"^\t \"%@\" takes time: %f", methodName, CACurrentMediaTime() - startTime);
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
        NSLog(@"^\t \"%@\" takes time: %f", methodName, CACurrentMediaTime() - startTime);
        
    }];
}

- (void)trackAllMethods {
    unsigned int outCount = 0;
    Method *methods = class_copyMethodList(object_getClass(self), &outCount);
    NSLog(@"^ \"%@\" has %d methods ===============================", NSStringFromClass([self class]), outCount);
    NSLog(@"^ {");
    
    NSMutableArray <NSString *> *methodNames = [NSMutableArray new];
    for(int i = 0; i < outCount; i++) {
        [methodNames addObject:[NSString stringWithUTF8String:sel_getName(method_getName(methods[i]))]];
        NSLog(@"^\t \"%@\"", [NSString stringWithUTF8String:sel_getName(method_getName(methods[i]))]);
    }
    NSLog(@"^ }");
    NSLog(@"^ Time to spend in each method:");
    
    __block CFTimeInterval startTime;
    
    [self anonymousSwizzlingAllWithMethodNames:methodNames preProcudure:^(NSString *methodName, NSArray<id> *arguments) {
        startTime = CACurrentMediaTime();
    } postProcudure:^(NSString *methodName, NSArray<id> *arguments) {
        NSLog(@"^\t \"%@\" takes time: %f", methodName, CACurrentMediaTime() - startTime);
    }];
}

@end
