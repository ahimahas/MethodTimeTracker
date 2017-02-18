//
//  OriginImp.h
//  MSMethodTimeTracker
//
//  Created by ahimahas on 2017. 2. 15..
//  Copyright © 2017년 MS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OriginImpProcedure)(NSString *methodName, NSArray <id> *arguments);

//! Contains pre/post procedure and origin imp location as NSValue
@interface MSOriginImpContainer : NSObject

@property (nonatomic, copy) OriginImpProcedure preProcedure;
@property (nonatomic, copy) OriginImpProcedure postProcedure;
@property (nonatomic, strong) NSValue *value;


@end
