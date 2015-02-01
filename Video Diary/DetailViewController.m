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

@interface DetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (strong, nonatomic) MPMoviePlayerController *videoController;
@property (strong, nonatomic) NSURL *videoURL;

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
    
    [self.videoController.view setFrame:self.videoView.bounds];
    [self.videoView addSubview: self.videoController.view];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.commentTextView.delegate = self;
    self.commentTextView.text = @"Comment on your diary entry here...";
    self.commentTextView.textColor = [UIColor lightGrayColor]; //optional
    
    NSString *fileKey = self.video.fileKey;
    
   // Get the NSString for the video NSURL from the image store
    NSURL *URL = [[FileStore sharedStore] videoURLForKey:fileKey];
    
    self.videoURL = URL;

    if (self.videoURL) {
        [self.videoController setContentURL:self.videoURL];
        
        [self.videoController prepareToPlay];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [self.view endEditing:YES];
    
    // Save changes to video
    Video *video = self.video;
    video.comment = self.commentTextView.text;
    
    // Stop movie playing if playing
    [self.videoController stop];
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
    
    // If the device has a camera, take a picture, otherwise just pick from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

// Creating textview placeholder

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Comment on your diary entry here..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"placeholder text here...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

// UIControl resigns first responder

- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}




@end
