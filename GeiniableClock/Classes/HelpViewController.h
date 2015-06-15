//
//  HelpViewController.h
//  GeiniableClock
//
//  Created by yuan jun on 11-9-2.
//  Copyright 2011 the9. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HelpViewController : UIViewController {

	UIScrollView *scrollView;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

- (IBAction)closeView:(UIButton *)sender;

@end
