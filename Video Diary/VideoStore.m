//
//  VideoStore.m
//  Video Diary
//
//  Created by Andrew Bell on 1/26/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import "VideoStore.h"
#import "Video.h"
#import "FileStore.h"

@import CoreData;

@interface VideoStore ()

@property (nonatomic) NSMutableArray *privateVideos;
@property (nonatomic, strong) NSMutableArray *allAssetTypes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation VideoStore

+ (instancetype)sharedStore
{
    static VideoStore *sharedStore;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

- (instancetype)init
{
    [NSException raise:@"Singleton"
                format:@"Use + [VideoStore sharedStore]"];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        // Read in Video_Diary.xcdatamodeld
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        // Where does the SQLite file go?
        NSString *path = [self videoArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            [NSException raise:@"Open Failure"
                        format:[error localizedDescription]];
        }
        // Create the managed object context
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        [self loadAllVideos];
    }
    
    return self;
}

- (NSArray *)allVideos
{
    return [self.privateVideos copy];
}

- (Video *)createVideo
{
    double order;
    if ([self.allVideos count] == 0) {
        order = 1.0;
    } else {
        order = [[self.privateVideos lastObject] orderingValue] + 1.0;
    }
    NSLog(@"Adding after %lu videos, order = %.2f", (unsigned long)[self.privateVideos count], order);
    Video *video = [NSEntityDescription insertNewObjectForEntityForName:@"Video" inManagedObjectContext:self.context];
    video.orderingValue = order;
    [self.privateVideos insertObject:video atIndex:0];
    return video;
}

- (void)removeVideo:(Video *)video
{
    NSString *key = video.fileKey;
    
    [[FileStore sharedStore] deleteFileForKey:key];
    [self.context deleteObject:video];
    [self.privateVideos removeObjectIdenticalTo:video];
}

- (NSString *)videoArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Get the one document directory from the list
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveChanges
{
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (void)loadAllVideos
{
    if (!self.privateVideos) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"Video"
                                             inManagedObjectContext:self.context];
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue"
                                                             ascending:YES];
        request.sortDescriptors = @[sd];
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request
                                                      error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@",[error localizedDescription]];
        }
        self.privateVideos = [[NSMutableArray alloc] initWithArray:result];
    }
}



@end
