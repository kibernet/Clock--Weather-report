//
//  CityCell.h
//  GeiniableClock
//
//  Created by yuan jun on 11-8-29.
//  Copyright 2011 the9. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherMainViewController;
@interface CityCell : UITableViewCell {

	UILabel *cityName;
	WeatherMainViewController *delegate;
	NSString *cityIdentifier;
}

@property (nonatomic, retain) IBOutlet UILabel *cityName;
@property (nonatomic, assign) WeatherMainViewController *delegate;
@property (nonatomic, copy) NSString *cityIdentifier;

- (IBAction)showWeekWeatherBtn:(UIButton *)sender;

@end
