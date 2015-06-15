//
//  TodayCell.h
//  GeiniableClock
//
//  Created by yuan jun on 11-8-31.
//  Copyright 2011 the9. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TodayCell : UITableViewCell {

	UIImageView *showImageView;
	UILabel *nameLabel;
	UILabel *resultLabel;
}

@property (nonatomic, retain) IBOutlet UIImageView *showImageView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *resultLabel;

@end
