//
//  ViewController.m
//  MSMethodTimeTracker
//
//  Created by ahimahas on 2017. 2. 17..
//  Copyright © 2017년 MS. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+MethodTimeTracker.h"
#import "SecondViewController.h"

static NSString * const kCellIdentifier = @"AutoCompleteCell";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end


@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //! declare target methods in here
        [self measureAllMethodsTime];
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
    [self showTrackedMethodTimeLogs];
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SecondViewController *vc = [SecondViewController new];
    [vc.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController pushViewController:vc animated:YES];
}

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
