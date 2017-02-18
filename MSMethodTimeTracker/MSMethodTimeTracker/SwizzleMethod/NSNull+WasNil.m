//
//  NSNull+WasNil.m
//  MSMethodTimeTracker
//
//  Created by ahimahas on 2017. 2. 16..
//  Copyright © 2017년 Coupang. All rights reserved.
//

#import "NSNull+WasNil.h"
#import "MSSwizzleMethodStatics.h"
#import <objc/message.h>

@implementation NSNull (WasNil)

- (void)setWasNil:(BOOL)wasNil {
    objc_setAssociatedObject(self, &categoryKeyWasNilKey, [NSNumber numberWithBool:wasNil], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)wasNil {
    NSNumber *value = objc_getAssociatedObject(self, &categoryKeyWasNilKey);
    return [value boolValue];
}

@end
