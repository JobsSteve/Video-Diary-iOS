//
//  VideosTableViewController.m
//  Video Diary
//
//  Created by Andrew Bell on 1/26/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import "VideosTableViewController.h"

#import "DetailViewController.h"
#import "VideoStore.h"
#import "Video.h"
#import "VideoCellTableViewCell.h"
#import "VideoViewController.h"
#import "FileStore.h"

@interface VideosTableViewController () <UIPopoverControllerDelegate, UIDataSourceModelAssociation>

@property (strong, nonatomic) UIPopoverController *videoPopover;

@property (strong, nonatomic) UIToolbar *toolBar;

@end

@implementation VideosTableViewController

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[self alloc] init];
}

#pragma mark - Initializers

// Designated initializer
- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = NSLocalizedString(@"Video Diary", @"Name of application");
        
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        // Bar button item that will send addNewVideo: to VideosTableViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewVideo:)];
        
        // Set this bar button item as the right item in the navigationItem
        navItem.rightBarButtonItem = bbi;
        
        navItem.leftBarButtonItem = self.editButtonItem;
        
        
        
        // Register for dynamic type notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateTableViewForDynamicTypeSize)
                                                     name:UIContentSizeCategoryDidChangeNotification object:nil];
        
        
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

#pragma mark - App lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"VideoCellTableViewCell" bundle:nil];
    
    // Register this NIB, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"VideoCellTableViewCell"];
    
    self.tableView.restorationIdentifier = @"VideosTableViewController";

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Create bottom toolbar with bar button items
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)];
    NSArray *buttonItems = [NSArray arrayWithObjects:flexibleItem, searchButton,nil];
    [self.navigationController.toolbar setItems:buttonItems];
  
    
    
    [self updateTableViewForDynamicTypeSize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [[[VideoStore sharedStore] allVideos] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    
    // Get a new or recycled cell
    VideoCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCellTableViewCell"];

    
    
    // Configure the cell...
    NSArray *videos = [[VideoStore sharedStore] allVideos];
    Video *video = videos[indexPath.row];
    
    // Use NSDateFormatter to turn a date into a date string
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateIntervalFormatterFullStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    
    cell.dateLabel.text = [dateFormatter stringFromDate:[video dateCreated]];
    cell.commentLabel.text = video.comment;
    
    cell.thumbnailView.image = video.thumbnail;
    
    __weak VideoCellTableViewCell *weakCell = cell;
    
    cell.actionBlock = ^{
        
        VideoCellTableViewCell *strongCell = weakCell;
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            NSString *fileKey = video.fileKey;
            
            // Get the NSString for the video NSURL from the image store
            NSURL *tmpURL = [[FileStore sharedStore] videoURLForKey:fileKey];
            if (!tmpURL) {
                return;
            }
            // Make a rectangle from the frame of the thumbnail relative to the table view
            CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds fromView:strongCell.thumbnailView];
            
            VideoViewController *vvc = [[VideoViewController alloc] init];
            vvc.videoURL = tmpURL;
            
            // Present a 600 x 800 popover from the rect
            self.videoPopover = [[UIPopoverController alloc] initWithContentViewController:vvc];
            self.videoPopover.delegate = self;
            self.videoPopover.popoverContentSize = CGSizeMake(600, 800);
            [self.videoPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }
    };

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete selected video from VideoStore
        NSArray *videos = [[VideoStore sharedStore] allVideos];
        Video *video = videos[indexPath.row];
        [[VideoStore sharedStore] removeVideo:video];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    
    NSArray *videos = [[VideoStore sharedStore] allVideos];
    Video *selectedVideo = videos[indexPath.row];
    
    // Give detail view controller a pointer to the video object in row
    detailViewController.video = selectedVideo;
    
    // Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:detailViewController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBAction methods


- (IBAction)addNewVideo:(id)sender
{
    Video *newVideo = [[VideoStore sharedStore] createVideo];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    
    // Give detail view controller a pointer to the video object in row
    detailViewController.video = newVideo;
    
    // Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)updateTableViewForDynamicTypeSize
{
    static NSDictionary *cellHeightDictionary;
    
    if (!cellHeightDictionary) {
        cellHeightDictionary = @{UIContentSizeCategoryExtraSmall : @100,
                                 UIContentSizeCategorySmall : @100,
                                 UIContentSizeCategoryMedium : @100,
                                 UIContentSizeCategoryLarge : @100,
                                 UIContentSizeCategoryExtraLarge : @110,
                                 UIContentSizeCategoryExtraExtraLarge : @120,
                                 UIContentSizeCategoryExtraExtraExtraLarge: @130 };
    }
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSNumber *cellHeight = cellHeightDictionary[userSize];
    [self.tableView setRowHeight:cellHeight.floatValue];
    [self.tableView reloadData];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeBool:self.isEditing forKey:@"TableViewIsEditing"];
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    self.editing = [coder decodeBoolForKey:@"TableViewIsEditing"];
    
    [super decodeRestorableStateWithCoder:coder];
}

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view
{
    NSString *identifier = nil;
    
    if (idx && view) {
        // Return an identifier of the given NSIndexPath, in case next time the data source changes
        Video *video = [[VideoStore sharedStore] allVideos][idx.row];
        identifier = video.fileKey;
    }
    return identifier;
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view
{
    NSIndexPath *indexPath = nil;
    
    if (identifier && view) {
        NSArray *videos = [[VideoStore sharedStore] allVideos];
        for (Video *video in videos) {
            if ([identifier isEqualToString:video.fileKey]) {
                int row = [videos indexOfObjectIdenticalTo:video];
                indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                break;
            }
        }
    }
    return indexPath;
}


- (void)search {
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
