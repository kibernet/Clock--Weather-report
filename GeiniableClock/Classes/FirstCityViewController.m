//
//  FirstCityViewController.m
//  GeiniableClock
//
//  Created by yuan jun on 11-8-30.
//  Copyright 2011 the9. All rights reserved.
//

#import "FirstCityViewController.h"
#import "WeatherMainViewController.h"
#import "FirstCityCell.h"
#import "MainSetViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SecondCityViewController.h"

#define COOKBOOK_PURPLE_COLOR	[UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define FIRSTCITYLISTFILEPATH [[NSBundle mainBundle] pathForResource:@"FirstCityList" ofType:@"plist"]


@implementation FirstCityViewController
@synthesize mainTableView;
@synthesize searchBar;
@synthesize searchDC;
@synthesize delegate;
@synthesize firstCityDictionaryOur;
@synthesize firstCityDictionaryOther;
@synthesize keysForOurDictionary;
@synthesize keysForOtherDictionary;

- (void)backToMainWeatherGUI:(UIBarButtonItem *)sender
{
	self.delegate.delegate.mainNavigationBar.topItem.leftBarButtonItem.action = @selector(backToClock:);
	self.delegate.delegate.mainNavigationBar.topItem.leftBarButtonItem.target = self.delegate;
	CATransition *animation = [CATransition animation];
	animation.duration = 0.4f;
	animation.delegate = self;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.type = kCATransitionPush;
	animation.subtype = kCATransitionFromBottom;
	[[[self.view superview] layer] addAnimation:animation forKey:nil];
	[self.view removeFromSuperview];
}

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
	//[self initSearchBar];
	[self initTableData];
}

- (void)initTableData
{
	NSMutableDictionary *diction = [NSMutableDictionary dictionaryWithContentsOfFile:FIRSTCITYLISTFILEPATH];
    self.firstCityDictionaryOur = [diction objectForKey:@"Our"];
	self.firstCityDictionaryOther = [diction objectForKey:@"Other"];
	self.keysForOurDictionary = [self.firstCityDictionaryOur allKeys];
	self.keysForOtherDictionary = [self.firstCityDictionaryOther allKeys];
	self.keysForOurDictionary = [self.keysForOurDictionary sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	self.keysForOtherDictionary = [self.keysForOtherDictionary sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (void)initSearchBar
{
	// Create a search bar
	self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)] autorelease];
	self.searchBar.tintColor = COOKBOOK_PURPLE_COLOR;
	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
	self.mainTableView.tableHeaderView = self.searchBar;
	
	// Create the search display controller
	self.searchDC = [[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self] autorelease];
//	self.searchDC.searchResultsDataSource = self;
//	self.searchDC.searchResultsDelegate = self;
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

- (void)showSecondCityViewController:(NSString *)keyName
{
	secondCityViewController = [[SecondCityViewController alloc] initWithNibName:@"SecondCityViewController" bundle:nil];
	secondCityViewController.name = keyName;
	secondCityViewController.delegate = self;
	self.delegate.delegate.mainNavigationBar.topItem.leftBarButtonItem.action = @selector(backToFirstCityGUI:);
	self.delegate.delegate.mainNavigationBar.topItem.leftBarButtonItem.target = secondCityViewController;
	CATransition *animation = [CATransition animation];
	animation.duration = 0.4f;
	animation.delegate = self;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.type = kCATransitionPush;
	animation.subtype = kCATransitionFromLeft;
	[[self.view layer] addAnimation:animation forKey:nil];
	[self.view addSubview:secondCityViewController.view];
}

- (void)dealloc {
	[mainTableView release];
	[searchBar release];
	[searchDC release];
	[firstCityDictionaryOur release];
	[firstCityDictionaryOther release];
	[keysForOurDictionary release];
	[keysForOtherDictionary release];
	[secondCityViewController release];
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
		return 30;
	}
	return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	FirstCityCell *cell = (FirstCityCell *)[tableView dequeueReusableCellWithIdentifier:@"FirstCityCell"];
	if (!cell) {
		cell = [[[NSBundle mainBundle] loadNibNamed:@"FirstCityCell" owner:self options:nil] lastObject];
	}
	NSString *tempKey;
	NSArray *tempName;
	if (indexPath.section == 0) {
		tempKey = [self.keysForOurDictionary objectAtIndex:indexPath.row];
		cell.firstCitypinyin = tempKey;
		tempName = [[self.firstCityDictionaryOur objectForKey:tempKey] componentsSeparatedByString:@"&"];
		cell.firstCityName.text = [tempName objectAtIndex:0];
		cell.firstCityShortName.text = [tempName objectAtIndex:1];
	}
	else {
		tempKey = [self.keysForOtherDictionary objectAtIndex:indexPath.row];
		cell.firstCitypinyin = tempKey;
		cell.firstCityName.text = [self.firstCityDictionaryOther objectForKey:tempKey];
		cell.firstCityShortName.text = tempKey;
	}
	cell.firstCityShortName.textColor = [UIColor randomColor];
	cell.delegate = self;
	return cell;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	
}

@end
