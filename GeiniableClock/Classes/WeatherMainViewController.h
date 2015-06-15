//
//  WeatherMainViewController.h
//  GeiniableClock
//
//  Created by yuan jun on 11-8-29.
//  Copyright 2011 the9. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainSetViewController;
@class WeatherListViewController;
@class FirstCityViewController;
@class HelpViewController;
@interface WeatherMainViewController : UIViewController {

	UITableView *mainTableView;
	MainSetViewController *delegate;
	WeatherListViewController *weatherListViewController;
	FirstCityViewController *firstCityViewController;
	NSMutableDictionary  *cityDictionary;
	BOOL hasChange;
	HelpViewController *helpViewController;
}

@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, assign) MainSetViewController *delegate;
@property (nonatomic, retain) NSMutableDictionary  *cityDictionary;
@property (nonatomic, assign) BOOL hasChange;

- (void)initMainTableView;

- (void)restoreGUI;

- (void)backToClock:(UIBarButtonItem *)sender;

- (void)showWeekWeather:(NSString *)cityID;

- (void)saveCityData;

- (void)showAddCityViewController;

- (void)showHelpViewController;

@end
