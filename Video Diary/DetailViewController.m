//
//  DetailViewController.m
//  Video Diary
//
//  Created by Andrew Bell on 1/27/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>

#import "DetailViewController.h"
#import "Video.h"

@interface DetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    Video *video = self.video;
    
    self.commentTextView.text = video.comment;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [self.view endEditing:YES];
    
    // Save changes to video
    Video *video = self.video;
    video.comment = self.commentTextView.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)takeVideo:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If the device has a camera, take a picture, otherwise just pick from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    
    // Place image picker on the screen
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get picked image from info directory
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // Put that image onto the screen in our image view
    self.imageView.image = image;
    
    // Take the image picker off the screen
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}



@end
