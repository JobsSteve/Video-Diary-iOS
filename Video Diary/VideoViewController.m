//
//  VideoViewController.m
//  Video Diary
//
//  Created by Andrew Bell on 2/7/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController () 

@property (strong, nonatomic) UIView *videoView;
@property (strong, nonatomic) MPMoviePlayerController *videoController;


@end

@implementation VideoViewController

- (void)loadView
{
    self.videoView = [[UIView alloc] init];
    self.videoView.contentMode = UIViewContentModeScaleAspectFit;
    self.view = self.videoView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.videoController = [[MPMoviePlayerController alloc] init];
    
    [self.videoController.view setFrame:self.videoView.bounds];
    self.videoController.view.contentMode = UIViewContentModeScaleAspectFit;
    self.videoController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.videoView addSubview: self.videoController.view];
    
    if (self.videoURL) {
        [self.videoController setContentURL:self.videoURL];
        
        [self.videoController prepareToPlay];
    }
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
