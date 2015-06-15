//
//  WeatherListViewController.m
//  GeiniableClock
//
//  Created by yuan jun on 11-8-29.
//  Copyright 2011 the9. All rights reserved.
//

#import "WeatherListViewController.h"
#import "WeatherCell.h"
#import "TodayCell.h"
#import <QuartzCore/QuartzCore.h>
#import "WeatherMainViewController.h"
#import "MainSetViewController.h"
#include "JSON.h"
#import "SecondCityViewController.h"
#import "FirstCityViewController.h"

#define CITYWEATHERURL(Identifier) [NSString stringWithFormat:@"http://m.weather.com.cn/data/%@.html", Identifier]

@interface WeatherListViewController (Private)

- (void)downloadAllDataFinished;
- (void)downloadWeatherDataFinished:(ASIHTTPRequest *)sender;
- (void)downloadWeatherDataFailed:(ASIHTTPRequest *)sender;

@end

@implementation WeatherListViewController
@synthesize delegate;
@synthesize secondCityDelegate;
@synthesize cityIdentifier;
@synthesize weatherInfoDic;
@synthesize dateArray;
@synthesize weekArray;
@synthesize mainTableView;
@synthesize levelArray;
@synthesize keyName;
@synthesize activityView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.weekArray = [NSArray arrayWithObjects:@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
	self.levelArray = [NSArray arrayWithObjects:@"穿衣指数", @"息斯敏过敏气象指数", @"晨练指数", @"舒适度指数", @"晾晒指数", @"旅游指数", @"紫外线指数", @"洗车指数", nil];
	self.keyName = [NSArray arrayWithObjects:@"index", @"index_ag", @"index_cl", @"index_co", @"index_ls", @"index_tr", @"index_uv", @"index_xc", nil];
	[self initDateAndWeek];
	[self initTableData];
}

- (void)initDateAndWeek
{
	self.dateArray = [NSMutableArray arrayWithCapacity:7];
	Byte i;
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
	NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit |  NSWeekdayCalendarUnit;
    NSDate *dateNow = [NSDate date];
	for (i = 0; i < 7 ; i++) {
		NSDate * newDate = [dateNow dateByAddingTimeInterval:i * 3600 * 24];
		comps = [calendar components:unitFlags fromDate:newDate];
		[self.dateArray addObject:[NSString stringWithFormat:@"%d月%d日-%@", [comps month], [comps day], [self.weekArray objectAtIndex:[comps weekday]-1]]];
	}
	[calendar release];
	//[comps release];
}

- (void)initTableData
{	
	[activityView startAnimating];
	if (!netWorkQueue) {
		netWorkQueue=[[ASINetworkQueue alloc] init];
	}
	[netWorkQueue reset];
	[netWorkQueue setQueueDidFinishSelector:@selector(downloadAllDataFinished)];
	[netWorkQueue setRequestDidFinishSelector:@selector(downloadWeatherDataFinished:)];
	[netWorkQueue setRequestDidFailSelector:@selector(downloadWeatherDataFailed:)];
	[netWorkQueue setDelegate:self];
	//weatherRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:GOOGLEREPORTAPIBYNAME(@"shanghai")]];
	weatherRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:CITYWEATHERURL(self.cityIdentifier)]];
    
	//NSLog(@"%@", CITYWEATHERURL(self.cityIdentifier));
	
	[netWorkQueue addOperation:weatherRequest];
	[netWorkQueue go];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[cityIdentifier release];
	[weatherRequest release];
	[netWorkQueue release];
	[weatherInfoDic release];
	[dateArray release];
	[weekArray release];
	[mainTableView release];
    [super dealloc];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) 
		return 7;
	return 8;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
	UITableViewCell *cell;
	NSString *cellName = @"WeatherCell";
	if (indexPath.section == 0) {
		if (isPMPublish == YES) {
			cellName = @"WeatherCellPM";
		}
		cell = (WeatherCell *)[tableView dequeueReusableCellWithIdentifier:cellName];
		if (!cell) {
			cell = [[[NSBundle mainBundle] loadNibNamed:cellName owner:self options:nil] lastObject];
			((WeatherCell *)cell).delegate = self;
		}
		((WeatherCell *)cell).dateLabel.text = [self.dateArray objectAtIndex:indexPath.row];
		if (self.weatherInfoDic) {
			((WeatherCell *)cell).tempLabel.text = [self.weatherInfoDic objectForKey:[NSString stringWithFormat:@"temp%d", indexPath.row + 1]];
		    ((WeatherCell *)cell).windLabel.text = [self.weatherInfoDic objectForKey:[NSString stringWithFormat:@"wind%d", indexPath.row + 1]];
		    ((WeatherCell *)cell).weatherLabel.text = [self.weatherInfoDic objectForKey:[NSString stringWithFormat:@"weather%d", indexPath.row + 1]];
			NSString *dayImageName = [self.weatherInfoDic objectForKey:[NSString stringWithFormat:@"img%d", 2*indexPath.row +1]];
			NSString *nightImageName = [self.weatherInfoDic objectForKey:[NSString stringWithFormat:@"img%d", 2*indexPath.row +2]];
            
			((WeatherCell *)cell).dayImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"d%@.png",dayImageName]];
			if ([nightImageName intValue] == 99) {
				((WeatherCell *)cell).nightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"n%@.png",dayImageName]];
			}
			else {
				((WeatherCell *)cell).nightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"n%@.png",nightImageName]];
			}
			
			((WeatherCell *)cell).dateLabel.textColor = [UIColor randomColor];
			((WeatherCell *)cell).tempLabel.textColor = [UIColor randomColor];
			((WeatherCell *)cell).windLabel.textColor = [UIColor randomColor];
			((WeatherCell *)cell).weatherLabel.textColor = [UIColor randomColor];
		}
	}
	else {
		cell = (TodayCell *)[tableView dequeueReusableCellWithIdentifier:@"TodayCell"];
		if (!cell) {
			cell = (TodayCell *)[[[NSBundle mainBundle] loadNibNamed:@"TodayCell" owner:self options:nil] lastObject];
		}
		((TodayCell *)cell).showImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"index%d.png", indexPath.row]];
		((TodayCell *)cell).nameLabel.text = [self.levelArray objectAtIndex:indexPath.row];
		if (self.weatherInfoDic) {
			((TodayCell *)cell).resultLabel.text = [self.weatherInfoDic objectForKey:[self.keyName objectAtIndex:indexPath.row]];
		}
		((TodayCell *)cell).resultLabel.textColor = [UIColor randomColor];
	}
	return cell;
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0) {
		return [NSString stringWithFormat:@"%@---发布时间:%@", [self.weatherInfoDic objectForKey:@"city"], [self.weatherInfoDic objectForKey:@"fchh"]];
	}
	return [NSString stringWithFormat:@"Notice:%@", [self.weatherInfoDic objectForKey:@"index_d"]];
}

- (void)backToMainWeatherGUI:(UIBarButtonItem *)sender
{ 
	self.delegate.delegate.mainNavigationBar.topItem.leftBarButtonItem.action = @selector(backToClock:);
	self.delegate.delegate.mainNavigationBar.topItem.leftBarButtonItem.target = self.delegate;
	CATransition *animation = [CATransition animation];
	animation.duration = 0.4f;
	animation.delegate = self;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.type = kCATransitionPush;
	animation.subtype = kCATransitionFromRight;
	[[[self.view superview] layer] addAnimation:animation forKey:nil];
	[self.view removeFromSuperview];
}

- (void)backToSecondCityGUI:(UIBarButtonItem *)sender
{
	self.secondCityDelegate.delegate.delegate.delegate.mainNavigationBar.topItem.leftBarButtonItem.action = @selector(backToFirstCityGUI:);
	self.secondCityDelegate.delegate.delegate.delegate.mainNavigationBar.topItem.leftBarButtonItem.target = self.secondCityDelegate;
	CATransition *animation = [CATransition animation];
	animation.duration = 0.4f;
	animation.delegate = self;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.type = kCATransitionPush;
	animation.subtype = kCATransitionFromRight;
	[[[self.view superview] layer] addAnimation:animation forKey:nil];
	[self.view removeFromSuperview];
}

- (void)downloadAllDataFinished
{
	
}

- (void)downloadWeatherDataFinished:(ASIHTTPRequest *)sender
{
	//NSLog(@"downloadWeatherDataFinished");
	self.weatherInfoDic = [[[sender responseString] JSONValue] objectForKey:@"weatherinfo"];
	[activityView stopAnimating];
	if(self.weatherInfoDic == NULL || !self.weatherInfoDic)
	{
		[self downloadWeatherDataFailed:nil];
		return;
	}
	isPMPublish = NO;
	if ([[self.weatherInfoDic objectForKey:@"fchh"] intValue] > 12) {
		isPMPublish = YES;
	}
	[self.mainTableView reloadData];
	
}

- (void)downloadWeatherDataFailed:(ASIHTTPRequest *)sender
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"天气预报" message:@"暂时无该城市天气信息!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //NSLog(@"Error:%@", [[sender error] localizedDescription]);
	[alertView show];
	[alertView release];
}

@end
