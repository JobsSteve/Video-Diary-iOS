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

@interface VideoStore ()

@property (nonatomic) NSMutableArray *privateVideos;

@end

@implementation VideoStore

+ (instancetype)sharedStore
{
    static VideoStore *sharedStore;
    
    // Do I need to create a sharedStore?
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
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
        NSString *path = [self videoArchivePath];
        _privateVideos = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If the array hadn't been saved previously, create a new empty one
        if (!_privateVideos) {
            _privateVideos = [[NSMutableArray alloc] init];
        }
    }
    
    return self;
}

- (NSArray *)allVideos
{
    return [self.privateVideos copy];
}

- (Video *)createVideo
{
    Video *video = [[Video alloc] init];
    [self.privateVideos insertObject:video atIndex:0];
    return video;
}

- (void)removeVideo:(Video *)video
{
    NSString *key = video.fileKey;
    
    [[FileStore sharedStore] deleteFileForKey:key];
    
    [self.privateVideos removeObjectIdenticalTo:video];
}

- (NSString *)videoArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Get the one document directory from the list
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"videos.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self videoArchivePath];
    
    // Return YES on success
    return [NSKeyedArchiver archiveRootObject:self.privateVideos toFile:path];
}



@end
