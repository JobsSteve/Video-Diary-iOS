//
//  DatePickerController.m
//  Video Diary
//
//  Created by Andrew Bell on 3/1/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import "DatePickerController.h"

@interface DatePickerController ()

@end

@implementation DatePickerController

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.datePicker = [[UIDatePicker alloc] init];
    [self.view addSubview:self.datePicker];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    button.center = CGPointMake(400,500);
    [button addTarget:self action:@selector(done) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
}

- (void)done
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
