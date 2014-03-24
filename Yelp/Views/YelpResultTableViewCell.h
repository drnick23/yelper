//
//  YelpResultTableViewCell.h
//  Yelp
//
//  Created by Nicolas Halper on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpResult.h"

@interface YelpResultTableViewCell : UITableViewCell

@property (nonatomic, weak) YelpResult *result;

-(CGFloat)myHeightForResult: (YelpResult *)result;

@end
