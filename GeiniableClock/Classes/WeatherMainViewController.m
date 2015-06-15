//
//  WeatherMainViewController.m
//  GeiniableClock
//
//  Created by yuan jun on 11-8-29.
//  Copyright 2011 the9. All rights reserved.
//

#import "WeatherMainViewController.h"
#import "MainSetViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AddCityCell.h"
#import "CityCell.h"
#import "WeatherCell.h"
#import "WeatherListViewController.h"
#import "FirstCityViewController.h"
#import "HelpViewController.h"

#define BARBUTTON(TITLE, SELECTOR) [[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStyleBordered target:self action:SELECTOR] autorelease]
#define CITYLISTFILEPATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/CityList.plist"]
//#define CITYLISTFILEPATH [[NSBundle mainBundle] pathForResource:@"CityList" ofType:@"plist"]
@implementation WeatherMainViewController
@synthesize mainTableView;
@synthesize delegate;
@synthesize cityDictionary;
@synthesize hasChange;

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
	[self initMainTableView];
}

- (void)initMainTableView
{
//	cityDictionary = [[NSMutableDictionary alloc] init];
//	[cityDictionary setObject:@"南京" forKey:@"101190101"];
//	[cityDictionary setObject:@"上海" forKey:@"101020100"];
//	[cityDictionary setObject:@"北京" forKey:@"101010100"];
//	[cityDictionary writeToFile:CITYLISTFILEPATH atomically:YES];
	NSFileManager *fileManage = [NSFileManager defaultManager];
	if (![fileManage fileExistsAtPath:CITYLISTFILEPATH]) {
		[fileManage createFileAtPath:CITYLISTFILEPATH contents:nil attributes:nil];
	}
	self.cityDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:CITYLISTFILEPATH];
	if (!self.cityDictionary) {
		self.cityDictionary = [NSMutableDictionary dictionary];
	}
}

- (void)restoreGUI	
{
	self.delegate.mainNavigationBar.topItem.rightBarButtonItem.title = @"Clock";
	self.delegate.mainNavigationBar.topItem.rightBarButtonItem.target = self;
	self.delegate.mainNavigationBar.topItem.rightBarButtonItem.action = @selector(backToClock:);
	self.delegate.mainNavigationBar.topItem.leftBarButtonItem = BARBUTTON(@"Back",@selector(backToClock:));
}

- (void)backToClock:(UIBarButtonItem *)sender
{
	self.delegate.mainNavigationBar.topItem.rightBarButtonItem.title = @"Weather";
	self.delegate.mainNavigationBar.topItem.rightBarButtonItem.target = self.delegate;
	self.delegate.mainNavigationBar.topItem.rightBarButtonItem.action = @selector(showWeatherReport:);
	if (self.delegate.mainTableView.tag == 2048) {
		self.delegate.mainTableView.tag = 1024;
		self.delegate.mainTableView.scrollEnabled = YES;
		self.delegate.mainNavigationBar.topItem.leftBarButtonItem = nil;
	}
	else {
		self.delegate.mainNavigationBar.topItem.leftBarButtonItem.title = self.delegate.leftBarTitle;
		self.delegate.mainNavigationBar.topItem.leftBarButtonItem.target = self.delegate.target;
		self.delegate.mainNavigationBar.topItem.leftBarButtonItem.action= self.delegate.action;
	}
	CATransition *animation = [CATransition animation];
	animation.duration = 0.4f;
	animation.delegate = self;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.type = @"cube";
	animation.subtype = kCATransitionFromRight;
	
	[[self.delegate.mainTableView layer] addAnimation:animation forKey:nil];
	[self.view removeFromSuperview];
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
	[mainTableView release];
	[cityDictionary release];
	[weatherListViewController release];
	[firstCityViewController release];
	[helpViewController release];
    [super dealloc];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
		return 1;
	}
	return [self.cityDictionary count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
	UITableViewCell *cell;
	if (indexPath.section == 0) {
		cell = (AddCityCell *)[tableView dequeueReusableCellWithIdentifier:@"AddCityCell"];
		if (!cell) {
			cell = [[[NSBundle mainBundle] loadNibNamed:@"AddCityCell" owner:self options:nil] lastObject];
		}
		((AddCityCell *)cell).delegate = self;
	}
	else {
		cell = (CityCell *)[tableView dequeueReusableCellWithIdentifier:@"CityCell"];
		if (!cell) {
			cell = [[[NSBundle mainBundle] loadNibNamed:@"CityCell" owner:self options:nil] lastObject];
		}
		NSString *temp;
		temp = [[self.cityDictionary allKeys] objectAtIndex:indexPath.row];
		((CityCell *)cell).cityIdentifier = temp;
		((CityCell *)cell).cityName.text = [self.cityDictionary valueForKey:temp];
		((CityCell *)cell).cityName.textColor = [UIColor randomColor];
		
		((CityCell *)cell).delegate = self;
	}
	
	return cell;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	if (indexPath.section == 0)
//		return;
//	else
//	{
//		CityCell *cell = (CityCell *)[tableView cellForRowAtIndexPath:indexPath];
//		[self showWeekWeather:cell.cityIdentifier];
//	}
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	CityCell *cell = (CityCell *)[tableView cellForRowAtIndexPath:indexPath];
	[self.cityDictionary removeObjectForKey:cell.cityIdentifier];

	[self.cityDictionary writeToFile:CITYLISTFILEPATH atomically:NO];
	[self.mainTableView reloadData];
	NSIndexPath *addCityIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	
	AddCityCell *addCityCell = (AddCityCell *)[tableView cellForRowAtIndexPath:addCityIndexPath];
	[addCityCell setEditing:NO animated:NO];
}

- (void)showWeekWeather:(NSString *)cityID
{
	weatherListViewController = [[WeatherListViewController alloc] initWithNibName:@"WeatherListViewController" bundle:nil];
	weatherListViewController.delegate = self;
	weatherListViewController.cityIdentifier = cityID;
	self.delegate.mainNavigationBar.topItem.leftBarButtonItem.action = @selector(backToMainWeatherGUI:);
	self.delegate.mainNavigationBar.topItem.leftBarButtonItem.target = weatherListViewController;
	CATransition *animation = [CATransition animation];
	animation.duration = 0.4f;
	animation.delegate = self;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.type = kCATransitionPush;
	animation.subtype = kCATransitionFromLeft;
	[[self.view layer] addAnimation:animation forKey:nil];
	[self.view addSubview:weatherListViewController.view];
}

- (void)saveCityData
{
	
}

- (void)showAddCityViewController
{
	firstCityViewController = [[FirstCityViewController alloc] initWithNibName:@"FirstCityViewController" bundle:nil];
	firstCityViewController.delegate = self;
	self.delegate.mainNavigationBar.topItem.leftBarButtonItem.action = @selector(backToMainWeatherGUI:);
	self.delegate.mainNavigationBar.topItem.leftBarButtonItem.target = firstCityViewController;
	CATransition *animation = [CATransition animation];
	animation.duration = 0.4f;
	animation.delegate = self;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.type = kCATransitionPush;
	animation.subtype = kCATransitionFromTop;
	[[self.view layer] addAnimation:animation forKey:nil];
	[self.view addSubview:firstCityViewController.view];
}

- (void)showHelpViewController
{
	helpViewController = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
	
	CATransition *animation = [CATransition animation];
	animation.duration = 0.4f;
	animation.delegate = self;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.type = @"rippleEffect";
	//animation.subtype = kCATransitionFromBottom;
	[[self.view layer] addAnimation:animation forKey:nil];
	[self.view addSubview:helpViewController.view];
}

@end
