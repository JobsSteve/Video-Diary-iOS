//
//  DatePickerController.h
//  Video Diary
//
//  Created by Andrew Bell on 3/1/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePickerController;

@protocol DatePickerControllerDelegate

- (void) datePickerContoller:(DatePickerController *)controller didPickDate:(NSDate *)date;

@end


@interface DatePickerController : UIViewController 

@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, assign) NSObject <DatePickerControllerDelegate> *delegate;

@end
