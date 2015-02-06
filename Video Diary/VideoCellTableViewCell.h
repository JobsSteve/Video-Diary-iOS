//
//  VideoCellTableViewCell.h
//  Video Diary
//
//  Created by Andrew Bell on 2/5/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end
