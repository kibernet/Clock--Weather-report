//
//  SecondCityViewController.h
//  GeiniableClock
//
//  Created by yuan jun on 11-8-31.
//  Copyright 2011 the9. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FirstCityViewController;
@class WeatherListViewController;
@interface SecondCityViewController : UIViewController {

	NSString *name;
	FirstCityViewController *delegate;
	NSMutableDictionary *secondCityDictionary;
	NSArray *keyArray;
	WeatherListViewController *weatherListViewController;
	NSMutableDictionary *favoriteCitysListDic;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) FirstCityViewController *delegate;
@property (nonatomic, retain) NSMutableDictionary *secondCityDictionary;
@property (nonatomic, retain) NSArray *keyArray;
@property (nonatomic, retain) NSMutableDictionary *favoriteCitysListDic;


- (void)backToFirstCityGUI:(UIBarButtonItem *)sender;

- (void)initTableData;

- (void)addFavoriteCity:(NSString *)cityName byCityID:(NSString *)cityIdentifiy;

@end
