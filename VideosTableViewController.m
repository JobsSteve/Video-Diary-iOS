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

@interface VideosTableViewController ()


@end

@implementation VideosTableViewController

#pragma mark - Initializers

// Designated initializer
- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Video Diary";
        
        
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    [self.tableView registerClass:[UITableViewCell class]
//           forCellReuseIdentifier:@"UITableViewCell"];
    
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"VideoCellTableViewCell" bundle:nil];
    
    // Register this NIB, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"VideoCellTableViewCell"];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
