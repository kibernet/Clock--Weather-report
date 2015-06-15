//
//  SecondCityViewController.m
//  GeiniableClock
//
//  Created by yuan jun on 11-8-31.
//  Copyright 2011 the9. All rights reserved.
//
#import "WeatherMainViewController.h"
#import "FirstCityViewController.h"
#import "SecondCityViewController.h"
#import "MainSetViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WeatherListViewController.h"

#define SECONDCITYLISTFILEPATH [[NSBundle mainBundle] pathForResource:@"SecondCityList" ofType:@"plist"]
#define CITYLISTFILEPATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/CityList.plist"]
#define MAXCITYNUMBER 20

@implementation SecondCityViewController
@synthesize name;
@synthesize delegate;
@synthesize secondCityDictionary;
@synthesize keyArray;
@synthesize favoriteCitysListDic;

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
	[self initTableData];
}

- (void)initTableData
{
	NSMutableDictionary *allSecondCitysDic = [NSMutableDictionary dictionaryWithContentsOfFile:SECONDCITYLISTFILEPATH];
	self.secondCityDictionary = [allSecondCitysDic objectForKey:self.name];
	self.keyArray = [self.secondCityDictionary allKeys];
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
	[name release];
	[secondCityDictionary release];
	[keyArray release];
    [super dealloc];
}

- (void)backToFirstCityGUI:(UIBarButtonItem *)sender
{
	self.delegate.delegate.delegate.mainNavigationBar.topItem.leftBarButtonItem.action = @selector(backToMainWeatherGUI:);
	self.delegate.delegate.delegate.mainNavigationBar.topItem.leftBarButtonItem.target = self.delegate;
	CATransition *animation = [CATransition animation];
	animation.duration = 0.4f;
	animation.delegate = self;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.type = kCATransitionPush;
	animation.subtype = kCATransitionFromRight;
	[[[self.view superview] layer] addAnimation:animation forKey:nil];
	[self.view removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [secondCityDictionary count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCellStyle style = UITableViewCellStyleDefault;
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SecondCity"];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:@"SecondCity"] autorelease];
	}
	cell.textLabel.text = [secondCityDictionary objectForKey:[self.keyArray objectAtIndex:indexPath.row]];
	cell.detailTextLabel.text = [self.keyArray objectAtIndex:indexPath.row];
	cell.textLabel.textColor = [UIColor randomColor];
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	weatherListViewController = [[WeatherListViewController alloc] initWithNibName:@"WeatherListViewController" bundle:nil];
	weatherListViewController.secondCityDelegate = self;
	
	NSString *cityID = [self.keyArray objectAtIndex:indexPath.row];
	[self addFavoriteCity:[self.secondCityDictionary objectForKey:cityID] byCityID:cityID];
	
	weatherListViewController.cityIdentifier = cityID;
	self.delegate.delegate.delegate.mainNavigationBar.topItem.leftBarButtonItem.action = @selector(backToSecondCityGUI:);
	self.delegate.delegate.delegate.mainNavigationBar.topItem.leftBarButtonItem.target = weatherListViewController;
	CATransition *animation = [CATransition animation];
	animation.duration = 0.4f;
	animation.delegate = self;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.type = kCATransitionPush;
	animation.subtype = kCATransitionFromLeft;
	[[self.view layer] addAnimation:animation forKey:nil];
	[self.view addSubview:weatherListViewController.view];
}

- (void)addFavoriteCity:(NSString *)cityName byCityID:(NSString *)cityIdentifiy
{
	//self.favoriteCitysListDic = [NSMutableDictionary dictionaryWithContentsOfFile:CITYLISTFILEPATH];
	self.favoriteCitysListDic = self.delegate.delegate.cityDictionary;
	if ([self.favoriteCitysListDic objectForKey:cityIdentifiy]) {
		return;
	}
	else if ([self.favoriteCitysListDic count] < MAXCITYNUMBER){
		if ([self.favoriteCitysListDic count] == (MAXCITYNUMBER - 1)) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加城市" message:@"你最多可以添加20个城市!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
		[self.favoriteCitysListDic setObject:cityName forKey:cityIdentifiy];
		[self.favoriteCitysListDic writeToFile:CITYLISTFILEPATH atomically:YES];
		[self.delegate.delegate.mainTableView reloadData];
	}
	
}

@end
