//
//  FilterTableViewCell.m
//  Yelp
//
//  Created by Nicolas Halper on 3/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterTableViewCell.h"

@interface FilterTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *switchView;

@end

@implementation FilterTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
