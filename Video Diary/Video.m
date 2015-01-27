//
//  Video.m
//  Video Diary
//
//  Created by Andrew Bell on 1/26/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import "Video.h"

@implementation Video

-(instancetype)initWithComment:(NSString *)comment
{
    // Call the superclass's designated initializer
    self = [super init];
    
    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        _comment = comment;
        
        // Set the _dateCreated to the current date and time
        _dateCreated = [[NSDate alloc]init];
        
       
    }
    
    // Return the address of the newly initialized object
    return self;
}

-(instancetype)init
{
    return [self initWithComment:@"No Comment"];
}


@end
