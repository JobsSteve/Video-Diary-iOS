//
//  VideoCellTableViewCell.m
//  Video Diary
//
//  Created by Andrew Bell on 2/5/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import "VideoCellTableViewCell.h"

@implementation VideoCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)showVideo:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
