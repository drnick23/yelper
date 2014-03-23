//
//  YelpResult.m
//  Yelp
//
//  Created by Nicolas Halper on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpResult.h"

@implementation YelpResult

-(id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        NSLog(@"should init result with dictionary object %@",nil);//dictionary);
        
        self.name = dictionary[@"name"];
        self.snippetText = dictionary[@"snippet_text"];
        self.displayAddress = dictionary[@"location"][@"display_address"];
        
        self.mainImageURL = [NSURL URLWithString:dictionary[@"image_url"]];
        self.snippetImageURL = [NSURL URLWithString:dictionary[@"snippet_image_url"]];
        self.ratingImgURL = [NSURL URLWithString:dictionary[@"rating_img_url_large"]];
        
    }
    return self;
}

@end
