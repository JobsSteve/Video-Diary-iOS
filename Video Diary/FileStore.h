//
//  FileStore.h
//  Video Diary
//
//  Created by Andrew Bell on 1/29/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FileStore : NSObject

+ (instancetype)sharedStore;


- (void)setVideoURL:(NSURL *)url forKey:(NSString *)key;
- (NSURL *)videoURLForKey:(NSString *)key;
- (void)deleteFileForKey:(NSString *)key;

@end
