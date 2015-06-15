//
//  AddCityCell.m
//  GeiniableClock
//
//  Created by yuan jun on 11-8-29.
//  Copyright 2011 the9. All rights reserved.
//

#import "AddCityCell.h"
#import "WeatherMainViewController.h"


@implementation AddCityCell
@synthesize delegate;
@synthesize deleteButton;

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


- (IBAction)addCityBtnPre:(UIButton *)sender
{
	//[self setSelected:YES animated:YES];
	[delegate showAddCityViewController];
}

- (IBAction)deleteCityBtnPre:(UIButton *)sender
{
	if (sender.tag == 64) {
		[delegate.mainTableView setEditing:YES animated:YES];
		[self setEditing:NO animated:NO];
		[deleteButton setImage:[UIImage imageNamed:@"Done.png"] forState:UIControlStateNormal];
		deleteButton.tag = 128;
	}
	else {
		[delegate.mainTableView setEditing:NO animated:YES];
		[deleteButton setImage:[UIImage imageNamed:@"Delete.png"] forState:UIControlStateNormal];
		deleteButton.tag = 64;
	}

}

- (IBAction)showHelpViewController:(UIButton *)sender
{
	[self.delegate showHelpViewController];
}

- (void)dealloc {
	[deleteButton release];
    [super dealloc];
}


@end
