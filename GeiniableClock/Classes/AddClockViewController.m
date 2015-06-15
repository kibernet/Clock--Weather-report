//
//  AddClockViewController.m
//  GeiniableClock
//
//  Created by yuan jun on 11-8-5.
//  Copyright 2011 the9. All rights reserved.
//

#import "AddClockViewController.h"
#import "MainSetViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "SetClockTimeController.h"
#import "SetClockModeController.h"
#import "SetClockSceneController.h"
#import "SetClockMusicController.h"

#define BARBUTTON(TITLE, SELECTOR) [[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStyleBordered target:self action:SELECTOR] autorelease]

@implementation AddClockViewController

@synthesize delegate;

@synthesize clockState;
@synthesize clockTime;
@synthesize clockMode;
@synthesize clockScene;
@synthesize clockMusic;
@synthesize rememberTextView;

@synthesize clockID;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[self setUIFontAndColor];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
	
	[self restoreGUI];
    [super viewDidLoad];
}

- (void)setUIFontAndColor
{
	UIFont *font = [UIFont fontWithName:@"DB LCD Temp" size:14.0f];
	self.clockState.font = font;
	self.clockTime.font = font;
	self.clockMode.font = font;
	self.clockScene.font = font;
	self.clockMusic.font = font;
	self.rememberTextView.font = font;
	
	self.clockState.textColor = [UIColor randomColor];
	self.clockTime.textColor = [UIColor randomColor];
	self.clockMode.textColor = [UIColor randomColor];
	self.clockScene.textColor = [UIColor randomColor];
	self.clockMusic.textColor = [UIColor randomColor];
	self.rememberTextView.textColor = [UIColor randomColor];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
     if (isKeyboardShowFlag) return;
	 if ([rememberTextView isFirstResponder] == NO) {
         return;
	 }
    
	 //获取键盘的大小
	 NSDictionary *dictionary=[notification userInfo];
	 
	 NSValue *aValue = [dictionary objectForKey:UIKeyboardFrameBeginUserInfoKey];
	 CGSize keyboardSize = [aValue CGRectValue].size;
	 [UIView beginAnimations:@"showKeyboard" context:nil];
	 [UIView setAnimationDuration:0.3f];
	 //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	 //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:toolbar cache:YES];
	 CGRect frame=[self.view frame];
	 frame.origin.y -= keyboardSize.height + 50;
	 self.view.frame = frame;
	 [UIView commitAnimations];
    isKeyboardShowFlag = YES;
}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    if (!isKeyboardShowFlag) return;
	//获取键盘的大小
	NSDictionary *dictionary=[notification userInfo];
	NSValue *aValue=[dictionary objectForKey:UIKeyboardFrameBeginUserInfoKey];
	CGSize keyboardSize=[aValue CGRectValue].size;
	[UIView beginAnimations:@"showKeyboard" context:nil];
	[UIView setAnimationDuration:0.3f];
	//[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	//[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:toolbar cache:YES];
	CGRect frame=[self.view frame];
	frame.origin.y += keyboardSize.height + 50;
	self.view.frame = frame;
	[UIView commitAnimations];
    isKeyboardShowFlag = NO;
}


///  
//UI数据持久化
///
- (void)saveClockData
{
	NSMutableDictionary *clockDictionary = [NSMutableDictionary dictionaryWithCapacity:6];
	[clockDictionary setObject:self.clockState.text forKey:@"ClockState"];
	[clockDictionary setObject:self.clockTime.text forKey:@"ClockTime"];
	[clockDictionary setObject:self.clockMode.text forKey:@"ClockMode"];
	[clockDictionary setObject:self.clockScene.text forKey:@"ClockScene"];
	[clockDictionary setObject:self.clockMusic.text forKey:@"ClockMusic"];
	[clockDictionary setObject:self.rememberTextView.text forKey:@"ClockRemember"];
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];

	[userDefault setObject:clockDictionary forKey:[NSString stringWithFormat:@"%d", self.clockID]];
	if (self.clockID > delegate.clockCount)
		++delegate.clockCount;
	[userDefault setObject:[NSNumber numberWithInt:delegate.clockCount] forKey:@"ClockCount"];
	
	if ([self.clockState.text isEqualToString:@"开启"]) {
		[delegate startClock:self.clockID];
	}
	[userDefault synchronize];
}

- (void)restoreGUI
{
	self.delegate.mainNavigationBar.topItem.leftBarButtonItem = BARBUTTON(@"Back", @selector(backToMainUI:));
    
}

- (void)backToMainUI:(id)sender
{
	[self backToMainUIByDirection:0];
}

- (void)backToMainUIByDirection:(int)directionTag
{
	
	CATransition *animation = [CATransition animation];
	animation.duration = 0.4f;
	animation.delegate = self;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.type = kCATransitionPush;
	switch (directionTag) {
		case 0:
			animation.subtype = kCATransitionFromRight;
			break;
		case 1:
			animation.subtype = kCATransitionFromLeft;
			break;
		case 2:
			animation.subtype = kCATransitionFromTop;
			break;
		case 3:
			animation.subtype = kCATransitionFromBottom;
            if (isKeyboardShowFlag) {
                [self.rememberTextView resignFirstResponder];
                return;
            }
			break;
		default:
			break;
	}
    [self saveClockData];
	[delegate restoreMainGUI];
	[[delegate.mainTableView layer] addAnimation:animation forKey:@"BackToMainUI"];
	[self.view removeFromSuperview];
}

- (IBAction)setClockBtn:(UIButton *)sender
{
	int index = [sender tag];
	switch (index) {
		case 100:
			[self showSetClockTimeController];
			break;
		case 111:
			[self showSetClockModeController];
			break;
		case 122:
			[self showSetClockSceneController];
			break;
		case 133:
			[self showSetClockMusicController];
			break;
		default:
			break;
	}
}

- (void)showSetClockTimeController
{
	setClockTimeController = [[SetClockTimeController alloc] initWithNibName:@"SetClockTimeController" bundle:nil];
	setClockTimeController.delegate = self;
	
	CATransition *animation = [CATransition animation];
	animation.duration = 0.4f;
	animation.delegate = self;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.type = kCATransitionPush;
	animation.subtype = kCATransitionFromLeft;
	[[self.view layer] addAnimation:animation forKey:@"ShowSetTime"];
	[self.view addSubview:setClockTimeController.view];
	delegate.mainTableView.scrollEnabled = NO;
}

- (void)showSetClockModeController
{
	setClockModeController = [[SetClockModeController alloc] initWithNibName:@"SetClockModeController" bundle:nil];
	setClockModeController.delegate = self;
	
	CATransition *animation = [CATransition animation];
	animation.duration = 0.4f;
	animation.delegate = self;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.type = kCATransitionPush;
	animation.subtype = kCATransitionFromLeft;
	[[self.view layer] addAnimation:animation forKey:@"ShowSetMode"];
	[self.view addSubview:setClockModeController.view];
	delegate.mainTableView.scrollEnabled = NO;
}

- (void)showSetClockMusicController
{
	setClockMusicController = [[SetClockMusicController alloc] initWithNibName:@"SetClockMusicController" bundle:nil];
	setClockMusicController.delegate = self;
	
	CATransition *animation = [CATransition animation];
	animation.duration = 0.4f;
	animation.delegate = self;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.type = kCATransitionPush;
	animation.subtype = kCATransitionFromLeft;
	[[self.view layer] addAnimation:animation forKey:@"ShowSetMusic"];
	[self.view addSubview:setClockMusicController.view];
	delegate.mainTableView.scrollEnabled = NO;
}

- (void)showSetClockSceneController
{
	setClockSceneController = [[SetClockSceneController alloc] initWithNibName:@"SetClockSceneController" bundle:nil];
	setClockSceneController.delegate = self;
	
	CATransition *animation = [CATransition animation];
	animation.duration = 0.4f;
	animation.delegate = self;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.type = kCATransitionPush;
	animation.subtype = kCATransitionFromLeft;
	[[self.view layer] addAnimation:animation forKey:@"ShowSetScene"];
	[self.view addSubview:setClockSceneController.view];
	delegate.mainTableView.scrollEnabled = NO;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [[touches allObjects] lastObject];
	firstTouchPoint = [touch locationInView:self.view];
	lastTouchPoint = CGPointZero;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [[touches allObjects] lastObject];
	lastTouchPoint = [touch locationInView:self.view];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([[[touches allObjects] lastObject] tapCount] >= 2) {
		[self.rememberTextView resignFirstResponder];
		return;
	}
	if (lastTouchPoint.x == 0 && lastTouchPoint.y == 0)
		return;
	if (lastTouchPoint.x - firstTouchPoint.x > 60) {
		[self backToMainUIByDirection:1];
	}
	else if(lastTouchPoint.x - firstTouchPoint.x < -60){
		[self backToMainUIByDirection:0];
	}
	else if(lastTouchPoint.y - firstTouchPoint.y > 60){
		[self backToMainUIByDirection:3];
	}
	else if(lastTouchPoint.y - firstTouchPoint.y < -60){
		[self backToMainUIByDirection:2];
	}
	
	
}

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
	[rememberTextView release];
    [super dealloc];
}


@end
