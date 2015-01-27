//
//  VideoStore.m
//  Video Diary
//
//  Created by Andrew Bell on 1/26/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import "VideoStore.h"
#import "Video.h"

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
        _privateVideos = [[NSMutableArray alloc] init];
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
    [self.privateVideos addObject:video];
    return video;
}



@end
