//
//  NSInvocation+SwizzleHelper.h
//  MSMethodTimeTracker
//
//  Created by ahimahas on 2017. 2. 17..
//  Copyright © 2017년 Coupang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSInvocation (SwizzleHelper)

//! get arguments at index in valist
- (id)argumentInVaList:(va_list)args atIndex:(NSUInteger)index;

//! set arguments into invocation per each variable type
- (void)setArguments:(NSArray *)arguments;

//! get swizzled method name by invocation's return type
- (IMP)selectSwizzledMethod;

//! validate argument type that can be handled
+ (BOOL)validateArgumentsTypeInMethodSignature:(NSMethodSignature *)signature;

@end
