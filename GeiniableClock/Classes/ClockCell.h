//
//  ClockCell.h
//  GeiniableClock
//
//  Created by yuan jun on 11-8-9.
//  Copyright 2011 the9. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainSetViewController;
@interface ClockCell : UITableViewCell {

	UISwitch *clockSwitch;
	UILabel *clockTimeLabel;
	UILabel *clockModeLabel;
	UILabel *clockSceneLabel;
	NSString *clockMusic;
	NSString *clockRemember;
	MainSetViewController *delegate;
	int numberID;
	
	CGPoint firstTouchPoint;
	CGPoint lastTouchPoint;
}

@property (nonatomic,assign) MainSetViewController *delegate;
@property (nonatomic,retain) IBOutlet UISwitch *clockSwitch;
@property (nonatomic,retain) IBOutlet UILabel *clockTimeLabel;
@property (nonatomic,retain) IBOutlet UILabel *clockModeLabel;
@property (nonatomic,retain) IBOutlet UILabel *clockSceneLabel;
@property (nonatomic,copy) NSString *clockMusic;
@property (nonatomic,copy) NSString *clockRemember;
@property (nonatomic) int numberID;

- (IBAction)clockBtn:(UIButton *)sender;

- (IBAction)switchBtn:(UISwitch *)sender;

- (void)setUIFontAndColor;

@end
