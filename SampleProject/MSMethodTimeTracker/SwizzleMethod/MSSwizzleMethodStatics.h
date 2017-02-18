//
//  CPSwizzleMethodStatics.h
//  MSMethodTimeTracker
//
//  Created by ahimahas on 2017. 2. 16..
//  Copyright © 2017년 MS. All rights reserved.
//

//! category variable keys
static NSString const *categoryKeySwizzledClasses = @"categoryKeySwizzledClasses";
static NSString const *categoryKeyWasNilKey = @"categoryKeyWasNilKey";


//! Default method argument count which are self and cmd
static const NSInteger defaultNumberOfMethodArguments = 2;


//! Log formats
#define SWIZZLE_LOG(message, arg) NSLog(@"^ [SwizzleMethod] %@, %@", message, arg)
#define SWIZZLE_ERROR_LOG(message, arg) NSLog(@"^ [SwizzleMethod] ERROR: %@, %@", message, arg)
