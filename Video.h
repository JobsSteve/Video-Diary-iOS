//
//  Video.h
//  Video Diary
//
//  Created by Andrew Bell on 2/9/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>


@interface Video : NSManagedObject

@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * fileKey;
@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic) double orderingValue;



@end
