//
//  VideoCellTableViewCell.m
//  Video Diary
//
//  Created by Andrew Bell on 2/5/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import "VideoCellTableViewCell.h"

@interface VideoCellTableViewCell ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *thumbnailViewHeightConstraint;

@end

@implementation VideoCellTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    [self updateInterfaceForDynamicTypeSize];
    // Register for dynamic type notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateInterfaceForDynamicTypeSize)
                                                 name:UIContentSizeCategoryDidChangeNotification object:nil];
    
    // Match thumbnail width to height constraints
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.thumbnailView
                                                                  attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.thumbnailView attribute:NSLayoutAttributeWidth multiplier:1
                                                                   constant:0];
    [self.thumbnailView addConstraint:constraint];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateInterfaceForDynamicTypeSize
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.dateLabel.font = font;
    self.commentLabel.font = font;
    
    static NSDictionary *thumbnailSizeDictionary;
    
    if (!thumbnailSizeDictionary) {
        thumbnailSizeDictionary = @{UIContentSizeCategoryExtraSmall : @86,
                                    UIContentSizeCategorySmall : @86,
                                    UIContentSizeCategoryMedium: @86,
                                    UIContentSizeCategoryLarge : @86,
                                    UIContentSizeCategoryExtraLarge : @91,
                                    UIContentSizeCategoryExtraExtraLarge : @96,
                                    UIContentSizeCategoryExtraExtraExtraLarge : @101 };
    }
    
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSNumber *thumbnailSize = thumbnailSizeDictionary[userSize];
    self.thumbnailViewHeightConstraint.constant = thumbnailSize.floatValue;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
