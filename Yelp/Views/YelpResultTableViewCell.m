//
//  YelpResultTableViewCell.m
//  Yelp
//
//  Created by Nicolas Halper on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpResultTableViewCell.h"

@interface YelpResultTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation YelpResultTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - public methods

-(void) setResult:(YelpResult *)result {
    _result = result;
    
    self.titleLabel.text = result.title;
    self.addressLabel.text = result.address;
    
}


@end
