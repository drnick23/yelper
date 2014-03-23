//
//  YelpResult.h
//  Yelp
//
//  Created by Nicolas Halper on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YelpResult : NSObject

-(id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic,assign) NSUInteger sequenceInList;

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSURL *mainImageURL;
@property (nonatomic,strong) NSURL *snippetImageURL;
@property (nonatomic,strong) NSURL *ratingImgURL;
@property (nonatomic,assign) NSUInteger reviewCount;

@property (nonatomic,strong) NSString *snippetText;
@property (nonatomic,strong) NSString *displayAddress;

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSURL *thumbURL;

@end
