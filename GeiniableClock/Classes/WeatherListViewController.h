//
//  WeatherListViewController.h
//  GeiniableClock
//
//  Created by yuan jun on 11-8-29.
//  Copyright 2011 the9. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIHTTPRequest.h"
#import "Reachability.h"
#import "ASIHTTPRequestConfig.h"

#import "ASICacheDelegate.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIProgressDelegate.h"

#import "ASIAuthenticationDialog.h"
#import "ASIInputStream.h"
#import "ASIFormDataRequest.h"

#import "ASINetworkQueue.h"
#import "ASIDownloadCache.h"

@class WeatherMainViewController;
@class SecondCityViewController;
@interface WeatherListViewController : UIViewController {

	WeatherMainViewController *delegate;
	SecondCityViewController *secondCityDelegate;
	NSString *cityIdentifier;
	ASIHTTPRequest *weatherRequest;
	ASINetworkQueue *netWorkQueue;
	NSDictionary *weatherInfoDic;
	NSMutableArray *dateArray;
	NSArray *weekArray;
	UITableView *mainTableView;
	NSArray *levelArray;
	NSArray *keyName;
	BOOL isPMPublish;
	UIActivityIndicatorView *activityView;
}

@property (nonatomic, assign) WeatherMainViewController *delegate;
@property (nonatomic, assign) SecondCityViewController *secondCityDelegate;
@property (nonatomic, copy) NSString *cityIdentifier;
@property (nonatomic, retain) NSDictionary *weatherInfoDic;
@property (nonatomic, retain) NSMutableArray *dateArray;
@property (nonatomic, retain) NSArray *weekArray;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSArray *levelArray;
@property (nonatomic, retain) NSArray *keyName;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;

- (void)backToMainWeatherGUI:(UIBarButtonItem *)sender;

- (void)backToSecondCityGUI:(UIBarButtonItem *)sender;

- (void)initDateAndWeek;
- (void)initTableData;

@end
