//
//  NSObject+SwizzleMethods.h
//  MSMethodTimeTracker
//
//  Created by ahimahas on 2017. 2. 14..
//  Copyright © 2017년 MS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSOriginImpContainer.h"

@interface NSObject (SwizzleMethods)

//! Swizzling a method to specified method
- (void)swizzlingWithMethodName:(NSString *)fromMethodName toMethodName:(NSString *)toMethodName;


//! Swizzle method with selector to anonymous implementation with pre/post procedures
- (void)anonymousSwizzlingWithSelecotor:(SEL)selector
                            preProcudure:(OriginImpProcedure)preProcudure
                           postProcudure:(OriginImpProcedure)postProcudure;

//! Swizzle method with selectors to anonymous implementation with pre/post procedures
- (void)anonymousSwizzlingWithSelecotors:(NSArray <NSValue *> *)selectors
                           preProcudure:(OriginImpProcedure)preProcudure
                          postProcudure:(OriginImpProcedure)postProcudure;

//! Swizzle method with name to anonymous implementation with pre/post procedures
- (void)anonymousSwizzlingWithMethodName:(NSString *)methodName
                            preProcudure:(OriginImpProcedure)preProcudure
                           postProcudure:(OriginImpProcedure)postProcudure;

//! Swizzle multiple methods with name to anonymous implementation with same pre/post procedures
- (void)anonymousSwizzlingAllWithMethodNames:(NSArray <NSString *> *)methodNames
                                preProcudure:(OriginImpProcedure)preProcudure
                               postProcudure:(OriginImpProcedure)postProcudure;


//! Rollback swizzled method to origin state
- (void)rollBackSwizzledMethodForName:(NSString *)methodName;

//! Rollback swizzled methods to origin states
- (void)rollBackSwizzledMethodsForName:(NSArray <NSString *> *)methodNames;

//! Rollback all swizzled methods to origin states
- (void)rollBackAllSwizzledMethods;


@end

