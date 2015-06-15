//
//  FirstCityViewController.h
//  GeiniableClock
//
//  Created by yuan jun on 11-8-30.
//  Copyright 2011 the9. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherMainViewController;
@class SecondCityViewController;
@interface FirstCityViewController : UIViewController {

	UITableView *mainTableView;
	UISearchBar *searchBar;
	UISearchDisplayController *searchDC;
	WeatherMainViewController *delegate;
	NSMutableDictionary *firstCityDictionaryOur;
	NSMutableDictionary *firstCityDictionaryOther;
	NSArray *keysForOurDictionary;
	NSArray *keysForOtherDictionary;
	
	SecondCityViewController *secondCityViewController;

}

@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, assign) UISearchBar *searchBar;
@property (nonatomic, assign) UISearchDisplayController *searchDC;
@property (nonatomic, assign) WeatherMainViewController *delegate;
@property (nonatomic, retain) NSMutableDictionary *firstCityDictionaryOur;
@property (nonatomic, retain) NSMutableDictionary *firstCityDictionaryOther;
@property (nonatomic, retain) NSArray *keysForOurDictionary;
@property (nonatomic, retain) NSArray *keysForOtherDictionary;

- (void)initSearchBar;

- (void)initTableData;
- (void)backToMainWeatherGUI:(UIBarButtonItem *)sender;

- (void)showSecondCityViewController:(NSString *)keyName;

@end
