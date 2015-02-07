//
//  DetailViewController.m
//  Video Diary
//
//  Created by Andrew Bell on 1/27/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

#import "DetailViewController.h"
#import "Video.h"
#import "FileStore.h"

@interface DetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (strong, nonatomic) MPMoviePlayerController *videoController;
@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) UIImage *tempImage;

@end

@implementation DetailViewController

static NSDateFormatter *dateFormatter;

- (void)setVideo:(Video *)video
{
    _video = video;
    
    // Use NSDateFormatter to turn a date into a date string
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateIntervalFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    self.navigationItem.title = [dateFormatter stringFromDate:video.dateCreated];
    
}

#pragma mark - App lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.videoController = [[MPMoviePlayerController alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieThumbnailLoadComplete:)
                                                 name:MPMoviePlayerThumbnailImageRequestDidFinishNotification
                                               object:self.videoController];

    
    [self.videoController.view setFrame:self.videoView.bounds];
    self.videoController.view.contentMode = UIViewContentModeScaleAspectFit;
    self.videoController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.videoView addSubview: self.videoController.view];
    
    // The videoController should always match its superview constraints
    NSLayoutConstraint *width =[NSLayoutConstraint
                                constraintWithItem:self.videoController.view
                                attribute:NSLayoutAttributeWidth
                                relatedBy:0
                                toItem:self.videoView
                                attribute:NSLayoutAttributeWidth
                                multiplier:1.0
                                constant:0];
    NSLayoutConstraint *height =[NSLayoutConstraint
                                 constraintWithItem:self.videoController.view
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:0
                                 toItem:self.videoView
                                 attribute:NSLayoutAttributeHeight
                                 multiplier:1.0
                                 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:self.videoController.view
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.videoView
                               attribute:NSLayoutAttributeTop
                               multiplier:1.0f
                               constant:0.f];
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:self.videoController.view
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.videoView
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:0.f];
    [self.videoView addConstraint:width];
    [self.videoView addConstraint:height];
    [self.videoView addConstraint:top];
    [self.videoView addConstraint:leading];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.commentTextField.delegate = self;
    
    self.commentTextField.text = self.video.comment;
    
    NSString *fileKey = self.video.fileKey;
    
   // Get the NSString for the video NSURL from the image store
    NSURL *URL = [[FileStore sharedStore] videoURLForKey:fileKey];
    
    self.videoURL = URL;

    if (self.videoURL) {
        [self.videoController setContentURL:self.videoURL];
        
        [self.videoController prepareToPlay];
    }
    
    // Get thumbnail image from self.videoController
    
    [self.videoController requestThumbnailImagesAtTimes:@[@1.0f] timeOption:MPMovieTimeOptionExact];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [self.view endEditing:YES];
    
    // Save changes to video
    self.video.comment = self.commentTextField.text;
    self.video.thumbnail = self.tempImage;
    
    // Only stop video playing if DetailViewController is popped off the stack (keeps playing if self.videoController goes fullscree
    NSArray *viewControllers = self.navigationController.viewControllers;
    if ([viewControllers indexOfObject:self] == NSNotFound) {
        [self.videoController stop];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)takeVideo:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    NSArray *availableTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    
    // Make video the only media type allowed
    if ([availableTypes containsObject:(__bridge NSString *)kUTTypeMovie]) {
        [imagePicker setMediaTypes:@[(__bridge NSString *)kUTTypeMovie]];
    }
    
    // If the device has a camera, take a video, otherwise alert user the device has no camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    } else {
//        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No video camera!"
                                                       message:@"This device does not have a video camera"
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles: nil];
        [alert show];

        return;
    }
    
    imagePicker.delegate = self;
    
    // Place image picker on the screen
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.videoURL = info[UIImagePickerControllerMediaURL];
    
    // Find documents directory
    NSData *videoData = [NSData dataWithContentsOfURL:self.videoURL];

    NSString *tempPath = [[FileStore sharedStore] filePathForKey:self.video.fileKey];
    
    [videoData writeToFile:tempPath atomically:NO];
    
    [[NSFileManager defaultManager] removeItemAtPath:[self.videoURL path] error:nil];
    
    self.videoURL = [NSURL fileURLWithPath:tempPath];
    
    [[FileStore sharedStore] setVideoURL:self.videoURL forKey:self.video.fileKey];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


// UIControl resigns first responder

- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
    
    for (UIView *subview in self.view.subviews) {
        if ([subview hasAmbiguousLayout]) {
            [subview exerciseAmbiguityInLayout];
        }
    }
}

#pragma mark - MPMoviePlayer Notification 

- (void)movieThumbnailLoadComplete:(NSNotification *)receive
{
    NSDictionary *receiveInfo = [receive userInfo];
    self.tempImage = [receiveInfo valueForKey:MPMoviePlayerThumbnailImageKey];
    
}


@end
