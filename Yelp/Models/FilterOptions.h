//
//  FilterOptions.h
//  Yelp
//
//  Created by Nicolas Halper on 3/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>


enum FilterSectionTypes {
    kTypeSegmented,
    kTypeSwitches,
    kTypeExpandable
};
typedef enum FilterSectionTypes FilterSectionTypes;

@interface FilterOptions : NSObject

@property (nonatomic,strong) NSArray *sections;
@property (nonatomic,strong) NSDictionary *searchParameters;

-(void)selectedRowAtIndexPath:(NSIndexPath *)indexPath;
-(BOOL)isSelectedAtIndexPath:(NSIndexPath *)indexPath;

-(NSArray *)selectedNamesForSection:(NSString *)sectionName;

@end
