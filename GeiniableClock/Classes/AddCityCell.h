//
//  AddCityCell.h
//  GeiniableClock
//
//  Created by yuan jun on 11-8-29.
//  Copyright 2011 the9. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherMainViewController;
@interface AddCityCell : UITableViewCell {
	
	WeatherMainViewController *delegate;
	UIButton *deleteButton;
}

@property (nonatomic, assign) WeatherMainViewController *delegate;
@property (nonatomic, retain) IBOutlet UIButton *deleteButton;

- (IBAction)addCityBtnPre:(UIButton *)sender;
- (IBAction)deleteCityBtnPre:(UIButton *)sender;
- (IBAction)showHelpViewController:(UIButton *)sender;

@end
