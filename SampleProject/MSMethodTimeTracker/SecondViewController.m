//
//  SecondViewController.m
//  MSMethodTimeTracker
//
//  Created by ahimahas on 2017. 3. 16..
//  Copyright © 2017년 MS. All rights reserved.
//

#import "SecondViewController.h"
#import "NSObject+MethodTimeTracker.h"

@interface SecondViewController ()

@end


@implementation SecondViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self measureAllMethodsTime];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
