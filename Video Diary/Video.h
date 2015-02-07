//
//  Video.h
//  Video Diary
//
//  Created by Andrew Bell on 1/26/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Video : NSObject <NSCoding>

@property (nonatomic, copy) NSString *comment;
@property (nonatomic, readonly, strong) NSDate *dateCreated;
@property (nonatomic, copy) NSString *fileKey;
@property (strong, nonatomic) UIImage *thumbnail;


// Designated initializer for Video
- (instancetype)initWithComment:(NSString *)comment;

@end
