//
//  FirstCityCell.m
//  GeiniableClock
//
//  Created by yuan jun on 11-8-30.
//  Copyright 2011 the9. All rights reserved.
//

#import "FirstCityCell.h"
#import "FirstCityViewController.h"

@implementation FirstCityCell
@synthesize firstCityName;
@synthesize firstCityShortName;
@synthesize firstCitypinyin;
@synthesize delegate;

- (IBAction)showSecondCity:(UIButton *)sender
{
	[delegate showSecondCityViewController:firstCitypinyin];
}


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
	[firstCityName release];
	[firstCityShortName release];
	[firstCitypinyin release];
    [super dealloc];
}


@end
