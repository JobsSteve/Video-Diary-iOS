//
//  VideoStore.h
//  Video Diary
//
//  Created by Andrew Bell on 1/26/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Video;

@interface VideoStore : NSObject

@property (nonatomic, readonly, copy) NSArray *allVideos;

+ (instancetype)sharedStore;
- (Video *)createVideo;

@end
