//
//  YelpResultTableViewCell.m
//  Yelp
//
//  Created by Nicolas Halper on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpResultTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface YelpResultTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *snippetTextLabel;


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
    
    /*self.titleLabel.text = @"A super long text lable that we don\'t know what to do with";//result.name;
    //self.titleLabel.text = @"balls";//[NSString stringWithFormat:@"23. %@",result.name];
    self.addressLabel.text = result.displayAddress;
    self.ratingsLabel.text = @"123 reviews";
    
    UIImage *placeholderImage = [UIImage imageNamed:@"LoadingPlaceholder"];
    [self.pictureImageView setImageWithURL:result.mainImageURL placeholderImage:placeholderImage];
    [self.ratingsImageView setImageWithURL:result.ratingImgURL placeholderImage:nil];*/
    
    self.nameLabel.text = [NSString stringWithFormat:@"%d. %@",result.sequenceInList,result.name];
    UIImage *placeholderImage = [UIImage imageNamed:@"LoadingPlaceholder"];
    [self.mainImageView setImageWithURL:result.mainImageURL placeholderImage:placeholderImage];
    [self.ratingImageView setImageWithURL:result.ratingImgURL placeholderImage:nil];
    
    //self.displayAddressLabel.text = result.displayAddress;
    self.snippetTextLabel.text = result.snippetText;
    
    
}


@end
