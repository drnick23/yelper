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
@property (weak, nonatomic) IBOutlet UIImageView *selectionIcon;
@end

@implementation FilterTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setName:(NSString *)name {
    self.nameLabel.text = name;
}


- (void)setSelection:(int)selectionState {
    NSLog(@"selectionState %d",selectionState);
    if (selectionState==1) {
        self.selectionIcon.image = [UIImage imageNamed:@"SelectedIcon"];
    } else if (selectionState==0) {
        self.selectionIcon.image = [UIImage imageNamed:@"DeselectedIcon"];
    } else if (selectionState==2) {
        self.selectionIcon.image = [UIImage imageNamed:@"ExpandableIcon"];
    }
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
