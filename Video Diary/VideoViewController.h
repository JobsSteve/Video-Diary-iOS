//
//  VideoViewController.h
//  Video Diary
//
//  Created by Andrew Bell on 2/7/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideoViewController : UIViewController

@property (strong, nonatomic) NSURL *videoURL;

@end
