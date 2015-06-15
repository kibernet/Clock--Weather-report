//
//  GeiniableClockAppDelegate.m
//  GeiniableClock
//
//  Created by yuan jun on 11-8-5.
//  Copyright 2011 the9. All rights reserved.
//

#import "GeiniableClockAppDelegate.h"
#import "GeiniableClockViewController.h"

@implementation GeiniableClockAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize musicDelegate;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];
//	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
//	UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
//	if (notification) {
//		NSLog(@"didFinishLaunchingWithOptions");
//		UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"weet" message:@"dfs" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"123", nil];
//		[alert show];
//		[alert release];
//	}
	
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
        
    {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */	
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
//{
//	NSLog(@"didReceiveLocalNotification");
//	NSLog(@"I receive notification:%@", notification);
//	NSString *clockID = [[notification userInfo] objectForKey:@"ActivityClock"];
//	[self postLocalNotification:clockID isFirst:NO];
//}

/*
- (void)postLocalNotification:(NSString *)clockID isFirst:(BOOL)flag
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	//-----获取闹钟数据---------------------------------------------------------
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSMutableDictionary *clockDictionary = [userDefault objectForKey:clockID];
	
	NSString *clockTime = [clockDictionary objectForKey:@"ClockTime"];
	NSString *clockMode = [clockDictionary objectForKey:@"ClockMode"];
	//NSString *clockScene = [clockDictionary objectForKey:@"ClockScene"];
	NSString *clockMusic = [clockDictionary objectForKey:@"ClockMusic"];
	NSString *clockRemember = [clockDictionary objectForKey:@"ClockRemember"];
	//-----组建本地通知的fireDate-----------------------------------------------
	
	//------------------------------------------------------------------------
	NSArray *clockTimeArray = [clockTime componentsSeparatedByString:@":"];
	NSDate *dateNow = [NSDate date];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	//[calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    //[comps setTimeZone:[NSTimeZone timeZoneWithName:@"CMT"]];
	NSInteger unitFlags = NSEraCalendarUnit | 
	NSYearCalendarUnit | 
	NSMonthCalendarUnit | 
	NSDayCalendarUnit | 
	NSHourCalendarUnit | 
	NSMinuteCalendarUnit | 
	NSSecondCalendarUnit | 
	NSWeekCalendarUnit | 
	NSWeekdayCalendarUnit | 
	NSWeekdayOrdinalCalendarUnit | 
	NSQuarterCalendarUnit;
	
	comps = [calendar components:unitFlags fromDate:dateNow];
	Byte hourNow = [comps hour];
	Byte minuteNow = [comps minute];
	[comps setHour:[[clockTimeArray objectAtIndex:0] intValue]];
	[comps setMinute:[[clockTimeArray objectAtIndex:1] intValue]];
	[comps setSecond:0];

	//------------------------------------------------------------------------
	
	Byte weekday = [comps weekday];
	NSArray *array = [[clockMode substringFromIndex:1] componentsSeparatedByString:@"、"];
	Byte days = 0;
	Byte i;
	Byte j;
	Byte count = [array count];
	Byte clockDays[7];

	NSArray *tempWeekdays = [NSArray arrayWithObjects:@"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
	//查找设定的周期模式
	for (i = 0; i < count; i++) {
		for (j = 0; j < 7; j++) {
			if ([[array objectAtIndex:i] isEqualToString:[tempWeekdays objectAtIndex:j]]) {
				clockDays[i] = j + 1;
				break;
			}
		}
	}
	//处理收到前一次发出的通知(再次发出本地通知)
	for (i = 0; i < count; i++) {
		if (clockDays[i] == weekday) {
			SInt8 temp=0;
			temp = clockDays[(i + 1 + count) % count] - weekday;
			days = (temp > 0 ? temp : temp + 7);
			break;
		}
	}
	//判断是否为首次发出通知,即开启闹钟
	if (flag) {
		SInt8 temp=0;
		temp = clockDays[0] - weekday;
		days = (temp > 0 ? temp : temp + 7);
		for (i = 0; i < count; i++) {
			if (clockDays[i] == weekday) {
				if(([[clockTimeArray objectAtIndex:0] intValue] * 3600 + [[clockTimeArray objectAtIndex:1] intValue] * 60) > (hourNow * 3600 + minuteNow * 60))
				{
					days = 0;
				}
				else
				{
					temp = clockDays[(i + 1 + count) % count] - weekday;
					days = (temp > 0 ? temp : temp + 7);
				}
				break;
			}
			else if(clockDays[i] > weekday){
				temp = clockDays[i] - weekday;
				days = (temp > 0 ? temp : temp+ 7);
				break;
			}

		}
	}
	
	NSDate *newFireDate = [[calendar dateFromComponents:comps] dateByAddingTimeInterval:3600 * 24 * days];
	
	//NSLog(@"newFireDate:%@", newFireDate);
	UILocalNotification *newNotification = [[UILocalNotification alloc] init];
	if (newNotification) {
		newNotification.fireDate = newFireDate;
		newNotification.alertBody = clockRemember;
		newNotification.soundName = clockMusic;
		newNotification.alertAction = @"查看闹钟";
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:clockID forKey:@"ActivityClock"];
		newNotification.userInfo = userInfo;
		[[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
	}
	
	NSLog(@"clockMusic:%@", clockMusic);
	NSLog(@"Post new localNotification:%@", newNotification);
	[newNotification release];
	
	[pool release];
}
*/

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

- (void)postLocalNotification:(NSString *)clockID isFirst:(BOOL)flag
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	//-----获取闹钟数据---------------------------------------------------------
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSMutableDictionary *clockDictionary = [userDefault objectForKey:clockID];
	
	NSString *clockTime = [clockDictionary objectForKey:@"ClockTime"];
	NSString *clockMode = [clockDictionary objectForKey:@"ClockMode"];
	//NSString *clockScene = [clockDictionary objectForKey:@"ClockScene"];
	NSString *clockMusic = [clockDictionary objectForKey:@"ClockMusic"];
	NSString *clockRemember = [clockDictionary objectForKey:@"ClockRemember"];
	//-----组建本地通知的fireDate-----------------------------------------------
	
	//------------------------------------------------------------------------
	NSArray *clockTimeArray = [clockTime componentsSeparatedByString:@":"];
	NSDate *dateNow = [NSDate date];
	NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
	//[calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    //[comps setTimeZone:[NSTimeZone timeZoneWithName:@"CMT"]];
	NSInteger unitFlags = NSEraCalendarUnit | 
	NSYearCalendarUnit | 
	NSMonthCalendarUnit | 
	NSDayCalendarUnit | 
	NSHourCalendarUnit | 
	NSMinuteCalendarUnit | 
	NSSecondCalendarUnit | 
	NSWeekCalendarUnit | 
	NSWeekdayCalendarUnit | 
	NSWeekdayOrdinalCalendarUnit | 
	NSQuarterCalendarUnit;
	
	comps = [calendar components:unitFlags fromDate:dateNow];
	[comps setHour:[[clockTimeArray objectAtIndex:0] intValue]];
	[comps setMinute:[[clockTimeArray objectAtIndex:1] intValue]];
	[comps setSecond:0];
	
	//------------------------------------------------------------------------
	Byte weekday = [comps weekday];
	NSArray *array = [[clockMode substringFromIndex:1] componentsSeparatedByString:@"、"];
	Byte i = 0;
	Byte j = 0;
	int days = 0;
	int	temp = 0;
	Byte count = [array count];
	Byte clockDays[7];
	
	NSArray *tempWeekdays = [NSArray arrayWithObjects:@"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
	//查找设定的周期模式
	for (i = 0; i < count; i++) {
		for (j = 0; j < 7; j++) {
			if ([[array objectAtIndex:i] isEqualToString:[tempWeekdays objectAtIndex:j]]) {
				clockDays[i] = j + 1;
				break;
			}
		}
	}
	
	for (i = 0; i < count; i++) {
	    temp = clockDays[i] - weekday;
		days = (temp >= 0 ? temp : temp + 7);
		NSDate *newFireDate = [[calendar dateFromComponents:comps] dateByAddingTimeInterval:3600 * 24 * days];
		
		UILocalNotification *newNotification = [[UILocalNotification alloc] init];
		if (newNotification) {
			newNotification.fireDate = newFireDate;
			newNotification.alertBody = clockRemember;
			newNotification.soundName = [NSString stringWithFormat:@"%@.caf", clockMusic];
			newNotification.alertAction = @"查看闹钟";
			newNotification.repeatInterval = NSWeekCalendarUnit;
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:clockID forKey:@"ActivityClock"];
			newNotification.userInfo = userInfo;
			[[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
		}
		NSLog(@"Post new localNotification:%@", [newNotification fireDate]);
		[newNotification release];
		
	}
	[pool release];
}
@end
