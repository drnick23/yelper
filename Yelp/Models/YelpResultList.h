//
//  YelpResultList.h
//  Yelp
//
//  Created by Nicolas Halper on 3/23/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YelpResult.h"

@interface YelpResultList : NSObject

-(id)initWithResponse:(NSDictionary *)response;

-(void)add:(YelpResult *)result;
-(YelpResult *)get:(NSUInteger)index;
-(int) count;

@end
