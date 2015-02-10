//
//  Video.m
//  Video Diary
//
//  Created by Andrew Bell on 2/9/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import "Video.h"


@implementation Video

@dynamic dateCreated;
@dynamic comment;
@dynamic fileKey;
@dynamic thumbnail;
@dynamic orderingValue;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    self.dateCreated = [NSDate date];
    
    // Create an NSUUID object - and get its string representation
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    self.fileKey = key;
}

@end
