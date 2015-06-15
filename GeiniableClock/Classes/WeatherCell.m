//
//  WeatherCell.m
//  GeiniableClock
//
//  Created by yuan jun on 11-8-29.
//  Copyright 2011 the9. All rights reserved.
//

#import "WeatherCell.h"
#import "WeatherMainViewController.h"

@implementation WeatherCell
@synthesize delegate;

@synthesize dateLabel;
@synthesize tempLabel;
@synthesize windLabel;
@synthesize weatherLabel;
@synthesize dayImageView;
@synthesize nightImageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	[dateLabel release];
	[tempLabel release];
	[windLabel release];
	[weatherLabel release];
	[dayImageView release];
	[nightImageView release];
    [super dealloc];
}



@end
