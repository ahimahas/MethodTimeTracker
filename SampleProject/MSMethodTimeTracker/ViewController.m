//
//  ViewController.m
//  MSMethodTimeTracker
//
//  Created by ahimahas on 2017. 2. 17..
//  Copyright © 2017년 MS. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+MethodTimeTracker.h"

static NSString * const kCellIdentifier = @"AutoCompleteCell";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end


@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //! declare target methods in here
        [self trackAllMethods];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)didShowButtonTouch:(id)sender {
    [self displayMethodTimeLogs];
}

#pragma mark - Unsupported Methods type

////! Struct type argument or return is not supported.
//- (CGSize)methodContainStruct:(CGSize)size {
//    return size;
//}
//
////! class method is not supported
//+ (void)classMethod {
//    return;
//}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }

    [cell.textLabel setText:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    
    return cell;
}

@end
