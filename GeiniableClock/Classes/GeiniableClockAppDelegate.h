//
//  GeiniableClockAppDelegate.h
//  GeiniableClock
//
//  Created by yuan jun on 11-8-5.
//  Copyright 2011 the9. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GeiniableClockViewController;
@interface GeiniableClockAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    GeiniableClockViewController *viewController;
    id musicDelegate;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GeiniableClockViewController *viewController;
@property (nonatomic, assign) id musicDelegate;

- (void)postLocalNotification:(NSString *)clockID isFirst:(BOOL)flag;

@end

