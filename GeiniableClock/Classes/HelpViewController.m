//
//  HelpViewController.m
//  GeiniableClock
//
//  Created by yuan jun on 11-9-2.
//  Copyright 2011 the9. All rights reserved.
//

#import "HelpViewController.h"
#import <QuartzCore/QuartzCore.h>
#define NPAGES 4

@implementation HelpViewController
@synthesize scrollView;

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
	//scrollView.frame=CGRectMake(0.0f, 0.0f, 320.0f, 436.0f);
	scrollView.contentSize=CGSizeMake(NPAGES*290.0f, 336.0f);
	scrollView.showsHorizontalScrollIndicator=NO;
	scrollView.showsVerticalScrollIndicator=NO;
	
	int i=0;
	
	for (i=0; i<NPAGES; i++) {
		NSString *fileName=[NSString stringWithFormat:@"%d.png",i+1];
	    UIImageView *imageViewLR=[[UIImageView alloc] initWithImage:[UIImage imageNamed:fileName]];
		//UIImageView *imageViewUW=[[UIImageView alloc] initWithImage:[UIImage imageNamed:fileName]];
	    imageViewLR.frame=CGRectMake(i*290.0f, 0.0f, 290.0f, 336.0f);
		//imageViewUW.frame=CGRectMake(0.0f, i*480.0f, 320.0f, 480.0f);
		[scrollView addSubview:imageViewLR];
		//[scrollView addSubview:imageViewUW];
		[imageViewLR release];
		//[imageViewUW release];
	}
	
    [super viewDidLoad];
}

- (IBAction)closeView:(UIButton *)sender
{
	CATransition *animation = [CATransition animation];
	animation.duration = 0.4f;
	animation.delegate = self;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.type = @"suckEffect";
	//animation.subtype = kCATransitionFromTop;
	[[[self.view superview] layer] addAnimation:animation forKey:nil];
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
	[scrollView release];
    [super dealloc];
}


@end
