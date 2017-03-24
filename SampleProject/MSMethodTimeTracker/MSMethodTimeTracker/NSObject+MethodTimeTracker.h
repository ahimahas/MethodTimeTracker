//
//  NSObject+TRTMethodTracer.h
//  MSMethodTimeTracker
//
//  Created by ahimahas on 2017. 2. 15..
//  Copyright © 2017년 Coupang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MethodTimeTracker)


#pragma mark - Main interface

//! Tracking all methods in class
- (void)measureAllMethodsTime;

//! Display measured time manually. It will shows up the result sorted by desc
- (void)showTrackedMethodTimeLogs;


@end
