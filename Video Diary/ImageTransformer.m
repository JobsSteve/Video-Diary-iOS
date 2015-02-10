//
//  ImageTransformer.m
//  Video Diary
//
//  Created by Andrew Bell on 2/9/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ImageTransformer.h"


@implementation ImageTransformer

+ (Class)transformedValueClass
{
    return [NSData class];
}

- (id)transformedValue:(id)value
{
    if (!value) {
        return nil;
    }
    
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    
    return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:value];
}

@end
