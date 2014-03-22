//
//  FilterTableViewCell.m
//  Yelp
//
//  Created by Nicolas Halper on 3/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterTableViewCell.h"

@interface FilterTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *buttonSwitch;

@end

@implementation FilterTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setName:(NSString *)name {
    self.nameLabel.text = name;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    //NSLog(@"highlighted cell");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    //NSLog(@"selected cell");

    // Configure the view for the selected state
}

@end
