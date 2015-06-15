//
//  CityCell.m
//  GeiniableClock
//
//  Created by yuan jun on 11-8-29.
//  Copyright 2011 the9. All rights reserved.
//

#import "CityCell.h"
#import "WeatherMainViewController.h"


@implementation CityCell
@synthesize cityName;
@synthesize delegate;
@synthesize cityIdentifier;

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
	[cityName release];
	[cityIdentifier release];
    [super dealloc];
}


- (IBAction)showWeekWeatherBtn:(UIButton *)sender
{
	[self.delegate showWeekWeather:self.cityIdentifier];
}

@end
