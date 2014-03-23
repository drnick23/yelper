//
//  YelpResultList.m
//  Yelp
//
//  Created by Nicolas Halper on 3/23/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpResultList.h"

@interface YelpResultList()

@property (strong,nonatomic) NSMutableArray *results; // of YelpResult

@end

@implementation YelpResultList

- (void)add:(YelpResult *)result {
    [self.results addObject:result];
}

-(id)initWithResponse:(NSDictionary *)response {
    self = [super init];
    if (self) {
    
        //NSLog(@"should init with response");
        
        if([[response objectForKey:@"businesses"] isKindOfClass:[NSArray class]]) {
            
            NSArray *businessResults = [response objectForKey:@"businesses"];
            
            for (NSDictionary *dictionary in businessResults) {
                YelpResult *result =[[YelpResult alloc] initWithDictionary:dictionary];
                result.sequenceInList = [self.results count]+1;
                [self add:result];
                
            }
        }
    }
    return self;
}

- (NSMutableArray *)results {
    if (!_results) _results = [[NSMutableArray alloc] init];
    return _results;
}



- (YelpResult *)get:(NSUInteger)index {
    return [self.results objectAtIndex:index];
}

- (int) count {
    return [self.results count];
}


@end
