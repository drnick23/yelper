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
@property (weak, nonatomic) IBOutlet UILabel *categoriesLabel;


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
    
    self.nameLabel.text = [NSString stringWithFormat:@"%d. %@",result.sequenceInList,result.name];
    UIImage *placeholderImage = [UIImage imageNamed:@"LoadingPlaceholder"];
    [self.mainImageView setImageWithURL:result.mainImageURL placeholderImage:placeholderImage];
    [self.ratingImageView setImageWithURL:result.ratingImgURL placeholderImage:nil];
    
    self.displayAddressLabel.text = result.displayAddress;
 
    
}

- (CGFloat)heightOfLabel:(UILabel *)label withText:(NSString *)text {
    
    //CGRect *bounds = [text boundingRectWithSize:[CGSizeMake(label.bounds.size.width),1000.0] options:<#(NSStringDrawingOptions)#> attributes:<#(NSDictionary *)#> context:<#(NSStringDrawingContext *)#>
    if (text) {
        label.text = text;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
    //NSLog(@"label width for %@ is %f", text, label.bounds.size.width);
    CGSize maximumLabelSize = CGSizeMake(label.bounds.size.width,1000.0);
    CGSize expectedSize = [label sizeThatFits:maximumLabelSize];
    return expectedSize.height;
    
}

-(CGFloat)myHeightForResult: (YelpResult *)result {
   
    
    //[self configureCell:cell];
    /*self.nameLabel.text = result.name;
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGFloat height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
   */
    
    CGFloat height = [self heightOfLabel:self.nameLabel withText:result.name];
    height += [self heightOfLabel:self.reviewCountLabel withText:nil];
    height += [self heightOfLabel:self.displayAddressLabel withText:nil];
    height += [self heightOfLabel:self.categoriesLabel withText:nil];
    
    // and our padding for cell height that we might adjust manually.
    height += 30.0f;
   // NSLog(@"height for %@ is %f",result.name,height);
    return height;
}


@end
