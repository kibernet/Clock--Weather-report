//
//  TodayCell.m
//  GeiniableClock
//
//  Created by yuan jun on 11-8-31.
//  Copyright 2011 the9. All rights reserved.
//

#import "TodayCell.h"


@implementation TodayCell
@synthesize nameLabel;
@synthesize resultLabel;
@synthesize showImageView;

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
	[nameLabel release];
	[resultLabel release];
	[showImageView release];
    [super dealloc];
}


@end
