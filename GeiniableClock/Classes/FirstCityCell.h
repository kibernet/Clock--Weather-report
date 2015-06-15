//
//  FirstCityCell.h
//  GeiniableClock
//
//  Created by yuan jun on 11-8-30.
//  Copyright 2011 the9. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FirstCityViewController;
@interface FirstCityCell : UITableViewCell {

	UILabel *firstCityName;
	UILabel *firstCityShortName;
	NSString *firstCitypinyin;
	FirstCityViewController *delegate;
}

@property (nonatomic, retain) IBOutlet UILabel *firstCityName;
@property (nonatomic, retain) IBOutlet UILabel *firstCityShortName;
@property (nonatomic, copy) NSString *firstCitypinyin;
@property (nonatomic, assign) FirstCityViewController *delegate;

- (IBAction)showSecondCity:(UIButton *)sender;

@end
