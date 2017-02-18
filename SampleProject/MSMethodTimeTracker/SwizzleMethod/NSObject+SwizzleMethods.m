//
//  NSObject+SwizzleMethods.m
//  MSMethodTimeTracker
//
//  Created by ahimahas on 2017. 2. 14..
//  Copyright © 2017년 MS. All rights reserved.
//

#import "NSObject+SwizzleMethods.h"
#import "NSObject+SwizzleMethodPrivate.h"
#import "MSSwizzleMethodStatics.h"
#import "NSInvocation+SwizzleHelper.h"
#import <objc/runtime.h>


@implementation NSObject (SwizzleMethods)

#pragma mark - Public Methods

- (void)swizzlingWithMethodName:(NSString *)fromMethodName toMethodName:(NSString *)toMethodName {
    // will implement in later when it become needed
}

- (void)anonymousSwizzlingWithSelecotor:(SEL)selector
                           preProcudure:(OriginImpProcedure)preProcudure
                          postProcudure:(OriginImpProcedure)postProcudure {
    NSString *name = NSStringFromSelector(selector);
    [self anonymousSwizzlingAllWithMethodNames:@[name] preProcudure:preProcudure postProcudure:postProcudure];
}

- (void)anonymousSwizzlingWithSelecotors:(NSArray <NSValue *> *)selectors
                            preProcudure:(OriginImpProcedure)preProcudure
                           postProcudure:(OriginImpProcedure)postProcudure {
    NSMutableArray <NSString *> *methodNames = [NSMutableArray new];
    for (NSValue *value in selectors) {
        SEL selector = [value pointerValue];
        [methodNames addObject:NSStringFromSelector(selector)];
    }
    [self anonymousSwizzlingAllWithMethodNames:methodNames preProcudure:preProcudure postProcudure:postProcudure];
}

- (void)anonymousSwizzlingWithMethodName:(NSString *)methodName
                            preProcudure:(OriginImpProcedure)preProcudure
                           postProcudure:(OriginImpProcedure)postProcudure {
    [self anonymousSwizzlingAllWithMethodNames:@[methodName] preProcudure:preProcudure postProcudure:postProcudure];
}

- (void)anonymousSwizzlingAllWithMethodNames:(NSArray <NSString *> *)methodNames
                                preProcudure:(OriginImpProcedure)preProcudure
                               postProcudure:(OriginImpProcedure)postProcudure {
    if (self.originImps == nil) {
        self.originImps = [NSMutableDictionary<NSString *,MSOriginImpContainer *> new];
    }
    
    [methodNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *originName = (NSString *)obj;
        SEL originSelector = NSSelectorFromString(originName);
        if (originSelector == nil) {
            SWIZZLE_ERROR_LOG(@"there is no selector", originName);
            return;
        }
        
        Method originMethod = class_getInstanceMethod([self class], originSelector);
        if (originMethod == nil) {
            SWIZZLE_ERROR_LOG(@"there is no method", originName);
            return;
        }
        
        NSMethodSignature *signature = [self methodSignatureForSelector:originSelector];
        if ([NSInvocation validateArgumentsTypeInMethodSignature:signature] == NO) {
            SWIZZLE_ERROR_LOG(@"Unsupported arguments", originName);
            return;
        }
        
        IMP originImp = method_getImplementation(originMethod);
        if ([self saveOriginImp:originImp preProcudure:preProcudure postProcedure:postProcudure atKey:originName] == NO) {
            SWIZZLE_LOG(@"Skip - Method is already swizzled.", originName);
            return;
        }
        
        [self swizzleSelector:originSelector andMethod:originMethod];
    }];

}

- (void)rollBackSwizzledMethodForName:(NSString *)methodName {
    MSOriginImpContainer *impContainer = self.originImps[methodName];
    if (impContainer == nil) {
        SWIZZLE_ERROR_LOG(@"Swizzled method is not existed", methodName);
        return;
    }
    
    SEL originSelector = NSSelectorFromString(methodName);
    if (originSelector == nil) {
        SWIZZLE_ERROR_LOG(@"There is no selector", methodName);
        return;
    }
    
    Method originMethod = class_getInstanceMethod([self class], originSelector);
    method_setImplementation(originMethod, [impContainer.value pointerValue]);
    
    [self.originImps removeObjectForKey:methodName];
}

- (void)rollBackSwizzledMethodsForName:(NSArray <NSString *> *)methodNames {
    for (NSString *methodName in methodNames) {
        [self rollBackSwizzledMethodForName:methodName];
    }
}

- (void)rollBackAllSwizzledMethods {
    NSArray <NSString *> *allKeys = self.originImps.allKeys;
    for (NSString *key in allKeys) {
        [self rollBackSwizzledMethodForName:key];
    }
}


#pragma mark - Private Methods

- (BOOL)saveOriginImp:(IMP)originImp
         preProcudure:(OriginImpProcedure)preProcedure
        postProcedure:(OriginImpProcedure)postProcedure
                atKey:(NSString *)key {
    if (self.originImps[key] != nil) {
        return NO;
    }
    
    MSOriginImpContainer *originImpContainer = [MSOriginImpContainer new];
    originImpContainer.preProcedure = preProcedure;
    originImpContainer.postProcedure = postProcedure;
    originImpContainer.value = [NSValue valueWithPointer:originImp];
    self.originImps[key] = originImpContainer;
    
    return YES;
}

- (void)swizzleSelector:(SEL)selector andMethod:(Method)method {
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    IMP swizzledImp = [invocation selectSwizzledMethod];
    if (swizzledImp == nil) {
        SWIZZLE_ERROR_LOG(@"Cannot make swizzled method", NSStringFromSelector(selector));
        return;
    }
    
    method_setImplementation(method, (IMP)swizzledImp);
}


@end


