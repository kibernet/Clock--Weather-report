//
//  MainSetViewController.m
//  GeiniableClock
//
//  Created by yuan jun on 11-8-5.
//  Copyright 2011 the9. All rights reserved.
//

#import "MainSetViewController.h"
#import "UIColor_Random.h"
#import "AddClockViewCell.h"
#import "AddClockViewController.h"
#import "ClockCell.h"
#import "CustomerCell.h"
#import <QuartzCore/QuartzCore.h>
#import "WeatherMainViewController.h"

#import "GeiniableClockAppDelegate.h"

#define NAVIGATIONBARTITLE @"SetClock"

#define FIRSTSECTIONTITLE @"偏好设置"
#define SECONDSECTIONTITLE @"个性设置"
#define THIRDECTIONTITLE @"其他"

#define DISPLAYSECONDS @"显示秒:"
#define DISPLAYWEEKDAY @"显示星期:"
#define LANGUAGESET @"语言设置:"

#define MAXCLOCKCOUNT 64


#define BARBUTTON(TITLE, SELECTOR) [[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStyleBordered target:self action:SELECTOR] autorelease]

@implementation MainSetViewController

@synthesize mainNavigationBar;
@synthesize mainTableView;
@synthesize clockCount;
@synthesize activityClockCount;
@synthesize timeLabel;
@synthesize action;
@synthesize target;
@synthesize leftBarTitle;

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

- (void)setActivityClockCount:(int)count
{
	activityClockCount = count;
	if(count < 0)
		activityClockCount = 0;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.mainTableView.showsVerticalScrollIndicator = NO;
	//self.mainNavigationBar.topItem.title = NAVIGATIONBARTITLE;
	timeLabel.font = [UIFont fontWithName:@"DB LCD Temp" size:25.0f];
	self.mainNavigationBar.topItem.rightBarButtonItem = BARBUTTON(@"Weather", @selector(showWeatherReport:));
	dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"HH:mm:ss"];
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    [self initClockCount];
	[self updateActivityClockCount];
    
	[super viewDidLoad];
}

- (void)updateTime
{
	timeLabel.textColor = [UIColor randomColor];
	timeLabel.text = [dateFormatter stringFromDate:[NSDate date]];

}

- (void)restoreMainGUI
{
	self.mainNavigationBar.topItem.leftBarButtonItem = nil;
	[self.mainTableView setScrollEnabled:YES];
	[self.mainTableView reloadData];
}

- (void)initClockCount
{
	//从NSUserDefault中读取数据,填充表格
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	if (![userDefault objectForKey:@"ClockCount"])
		self.clockCount = 0;
	else
		self.clockCount = [[userDefault objectForKey:@"ClockCount"] intValue];
	self.activityClockCount = [[UIApplication sharedApplication] applicationIconBadgeNumber];
	
	if (![userDefault objectForKey:@"ActivityClockCount"])
		self.activityClockCount = 0;
	else
		self.activityClockCount = [[userDefault objectForKey:@"ActivityClockCount"] intValue];
}

- (NSString *)updateHeaderTitle
{
	return [NSString stringWithFormat:@"(Total: %d<^v^>Activity: %d)", self.clockCount, self.activityClockCount];
}

- (void)updateActivityClockCount
{
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:self.activityClockCount];
}

- (void)showWeatherReport:(UIBarButtonItem *)sender
{
	//exit(0);
	//show Weather report ViewController
    id musicDeleagate = ((GeiniableClockAppDelegate *)[[UIApplication sharedApplication] delegate]).musicDelegate;
    if (musicDeleagate) {
        [musicDeleagate performSelector:@selector(helpMethod)];
    }
	weatherMainViewController = [[WeatherMainViewController alloc] initWithNibName:@"WeatherMainViewController" bundle:nil];
	weatherMainViewController.delegate = self;
	CATransition *animation = [CATransition animation];
	animation.duration = 0.4f;
	animation.delegate = self;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.type = @"cube";
	animation.subtype = kCATransitionFromLeft;
	
	[[self.mainTableView layer] addAnimation:animation forKey:nil];
	[self.mainTableView addSubview:weatherMainViewController.view];
	CGPoint point = weatherMainViewController.view.center;
	point.y += self.mainTableView.contentOffset.y;
	weatherMainViewController.view.center = point;
    if (self.mainTableView.scrollEnabled == YES) {
		[self.mainTableView setScrollEnabled:NO];
		self.mainTableView.tag = 2048;
	}
	self.target = self.mainNavigationBar.topItem.leftBarButtonItem.target;
	self.action = self.mainNavigationBar.topItem.leftBarButtonItem.action;
	self.leftBarTitle = self.mainNavigationBar.topItem.leftBarButtonItem.title;
	[weatherMainViewController restoreGUI];
	
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
	[timeLabel release];
	[timer release];
	[dateFormatter release];
	[mainTableView release];
	[mainNavigationBar release];
	[addClockViewController release];
    [super dealloc];
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.clockCount + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//UITableViewCellStyle style = UITableViewCellStyleDefault;
	UITableViewCell *cell;
	if (indexPath.row == 0) {
		cell = (AddClockViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AddClockViewCell"];
		if (!cell) {
			cell = [[[NSBundle mainBundle] loadNibNamed:@"AddClockViewCell" owner:self options:nil] lastObject];
		}
		((AddClockViewCell *)cell).delegate = self;
	}
	else {
		cell = (ClockCell *)[tableView dequeueReusableCellWithIdentifier:@"ClockCell"];
		if (!cell) {
			cell =[[[NSBundle mainBundle] loadNibNamed:@"ClockCell" owner:self options:nil] lastObject];
		}
		((ClockCell *)cell).delegate = self;
		
		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		NSMutableDictionary *clockDictionary = [userDefault objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]];
		((ClockCell *)cell).clockSwitch.on = [[clockDictionary objectForKey:@"ClockState"] isEqualToString:@"开启"] ? YES : NO;
		((ClockCell *)cell).clockTimeLabel.text = [clockDictionary objectForKey:@"ClockTime"];
		((ClockCell *)cell).clockModeLabel.text = [clockDictionary objectForKey:@"ClockMode"];
		((ClockCell *)cell).clockSceneLabel.text = [clockDictionary objectForKey:@"ClockScene"];
		((ClockCell *)cell).clockMusic = [clockDictionary objectForKey:@"ClockMusic"];
		((ClockCell *)cell).clockRemember = [clockDictionary objectForKey:@"ClockRemember"];
		((ClockCell *)cell).numberID = indexPath.row;
		[((ClockCell *)cell) setUIFontAndColor];
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUserDefaults *userDefaule = [NSUserDefaults standardUserDefaults];
    int index = ((ClockCell *)[tableView cellForRowAtIndexPath:indexPath]).numberID;

    BOOL flag = NO;
    NSString *clockState = [[userDefaule objectForKey:[NSString stringWithFormat:@"%d", index]] objectForKey:@"ClockState"];
    if ([clockState isEqualToString:@"开启"]) {
        flag = YES;
    }
    [userDefaule removeObjectForKey:[NSString stringWithFormat:@"%d", index]];
    for (int i = index + 1; i <= clockCount; i++) {
        NSString *preClockID = [NSString stringWithFormat:@"%d", i - 1];
        NSString *clockID = [NSString stringWithFormat:@"%d", i];
        NSMutableDictionary *clockDic = [[userDefaule objectForKey:clockID] retain];
        [userDefaule removeObjectForKey:clockID];
        [userDefaule setObject:clockDic forKey:preClockID];
    }
    [userDefaule setObject:[NSNumber numberWithInt:--clockCount] forKey:@"ClockCount"];
    if (flag) {
        [userDefaule setObject:[NSNumber numberWithInt:--activityClockCount] forKey:@"ActivityClockCount"];
        [self shutdownClock:index];
    }
    [userDefaule synchronize];
    [self.mainTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [self updateHeaderTitle];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return [self updateHeaderTitle];
}


#pragma mark UITableViewDelegate
- (void)showAddClockView:(ClockCell *)sender
{
	if (self.clockCount == MAXCLOCKCOUNT && sender == nil) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Clock Warning!" message:[NSString stringWithFormat:@"You can not add clock more than %d!", MAXCLOCKCOUNT] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return;
	}
	addClockViewController = [[AddClockViewController alloc] initWithNibName:@"AddClockViewController" bundle:nil];
	addClockViewController.delegate = self;

	CATransition *animation = [CATransition animation];
	animation.duration = 0.4f;
	animation.delegate = self;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.type = kCATransitionPush;
	animation.subtype = kCATransitionFromLeft;
	
	[[self.mainTableView layer] addAnimation:animation forKey:nil];
	[self.mainTableView addSubview:addClockViewController.view];
	CGPoint point = addClockViewController.view.center;
	point.y += self.mainTableView.contentOffset.y;
	addClockViewController.view.center = point;
	[self.mainTableView setScrollEnabled:NO];

	addClockViewController.clockID = self.clockCount + 1;
	if (sender) {
		addClockViewController.clockState.text = (sender.clockSwitch.on == YES ? @"开启" : @"关闭");
		addClockViewController.clockTime.text = sender.clockTimeLabel.text;
		addClockViewController.clockMode.text = sender.clockModeLabel.text;
		addClockViewController.clockScene.text = sender.clockSceneLabel.text;
		addClockViewController.clockMusic.text = sender.clockMusic;
		addClockViewController.rememberTextView.text = sender.clockRemember;
		addClockViewController.clockID = sender.numberID;
	}
}

- (void)startClock:(int)clockID
{
	//首先查找以前是否存在此本地通知,若存在,则删除以前的该本地通知,
	//再重新发出新的本地通知
	
	[self shutdownClock:clockID];
	
	NSString *clockIDString = [NSString stringWithFormat:@"%d", clockID];
	[(GeiniableClockAppDelegate *)[[UIApplication sharedApplication] delegate] postLocalNotification:clockIDString isFirst:YES];

}

- (void)shutdownClock:(int)clockID
{
	NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
	for(UILocalNotification *notification in localNotifications)
	{
		if ([[[notification userInfo] objectForKey:@"ActivityClock"] intValue] == clockID) {
			NSLog(@"Shutdown localNotification:%@", [notification fireDate]);
			[[UIApplication sharedApplication] cancelLocalNotification:notification];
		}
	}
}

@end
