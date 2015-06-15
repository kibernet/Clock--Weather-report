//
//  AddClockViewController.h
//  GeiniableClock
//
//  Created by yuan jun on 11-8-5.
//  Copyright 2011 the9. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainSetViewController;
@class SetClockTimeController;
@class SetClockModeController;
@class SetClockSceneController;
@class SetClockMusicController;

@interface AddClockViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate> {

	MainSetViewController *delegate;
	CGPoint firstTouchPoint;
	CGPoint lastTouchPoint;
	
	SetClockTimeController *setClockTimeController;
	SetClockModeController *setClockModeController;
	SetClockSceneController *setClockSceneController;
	SetClockMusicController *setClockMusicController;
	
	UILabel *clockState;
	UILabel *clockTime;
	UILabel *clockMode;
	UILabel *clockScene;
	UILabel *clockMusic;
	UITextView *rememberTextView;
	
	int clockID;
    BOOL isKeyboardShowFlag;
}

@property (nonatomic, assign) MainSetViewController *delegate;

@property (nonatomic, retain) IBOutlet UILabel *clockState;
@property (nonatomic, retain) IBOutlet UILabel *clockTime;
@property (nonatomic, retain) IBOutlet UILabel *clockMode;
@property (nonatomic, retain) IBOutlet UILabel *clockScene;
@property (nonatomic, retain) IBOutlet UILabel *clockMusic;
@property (nonatomic, retain) IBOutlet UITextView *rememberTextView;
@property (nonatomic) int clockID;

- (void)saveClockData;
- (void)restoreGUI;
- (void)backToMainUI:(id)sender;
- (void)backToMainUIByDirection:(int)directionTag;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHidden:(NSNotification *)notification;

- (IBAction)setClockBtn:(UIButton *)sender;

- (void)showSetClockTimeController;
- (void)showSetClockModeController;
- (void)showSetClockMusicController;
- (void)showSetClockSceneController;

- (void)setUIFontAndColor;

@end
