//
//  MainSetViewController.h
//  GeiniableClock
//
//  Created by yuan jun on 11-8-5.
//  Copyright 2011 the9. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddClockViewController;
@class ClockCell;
@class WeatherMainViewController;
@interface MainSetViewController : UIViewController <UITextViewDelegate>{

	UITableView *mainTableView;
	UINavigationBar *mainNavigationBar;
	AddClockViewController *addClockViewController;

	int clockCount;
	int activityClockCount;
	
	NSTimer *timer;
	NSDateFormatter *dateFormatter;
	UILabel *timeLabel;
	WeatherMainViewController *weatherMainViewController;
	
	SEL action;
	id target;
	NSString *leftBarTitle;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *mainNavigationBar;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic) int clockCount;
@property (nonatomic) int activityClockCount;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic) SEL action;
@property (nonatomic, assign) id target;
@property (nonatomic, copy) NSString *leftBarTitle;

- (void)showWeatherReport:(UIBarButtonItem *)sender;

- (void)restoreMainGUI;
- (void)initClockCount;
- (NSString *)updateHeaderTitle;
- (void)updateActivityClockCount;

- (void)showAddClockView:(ClockCell *)sender;

- (void)startClock:(int)clockID;
- (void)shutdownClock:(int)clockID;

- (void)updateTime;


@end
