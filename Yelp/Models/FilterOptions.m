//
//  FilterOptions.m
//  Yelp
//
//  Created by Nicolas Halper on 3/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterOptions.h"

@interface FilterOptions()

@property (nonatomic,strong) NSDictionary *mapYelpCategories;
@property (nonatomic,strong) NSDictionary *mapSortBy;
@property (nonatomic,strong) NSDictionary *mapDistanceToRadius;

@property (nonatomic,strong) NSMutableDictionary *selections;

@end

@implementation FilterOptions

-(id)init {
    self = [super init];
    if (self) {
        self.sections = @[
                          @{
                              @"name":@"Most Popular",
                              @"type":@(kTypeSwitches),
                              @"list":@[@"Offering a Deal"]
                              },
                          @{
                              @"name":@"Distance",
                              @"type":@(kTypeExpandable),
                              @"list":@[@"Auto",@"2 blocks",@"6 blocks",@"1 mile",@"5 miles"],
                              },
                          @{
                              @"name":@"Sort By",
                              @"type":@(kTypeExpandable),
                              @"list":@[@"Best Match",@"Distance",@"Rating"],
                              },
                          @{
                              @"name":@"Categories",
                              @"type":@(kTypeSwitches),
                              @"list":@[@"Active Life",@"Arts & Entertainment",@"Automotive",@"Beauty & Spas",@"Education",@"Event Planning & Services",@"Financial Services",@"Food"],
                              }
                          ];
        self.mapYelpCategories = @{
                                            @"All":@"",
                                            @"Active Life":@"active",
                                            @"Arts & Entertainment":@"arts",
                                            @"Automotive":@"auto",
                                            @"Beauty & Spas":@"beautysvc",
                                            @"Education":@"education",
                                            @"Event Planning & Services":@"eventservices",
                                            @"Financial Services":@"financialservices",
                                            @"Food":@"food",
                                            @"Health & Medical":@"health",
                                            @"Home Services":@"homeservices",
                                            @"Hotels & Travel":@"hotelstravel",
                                            @"Local Flavor":@"localflavor"
                                            };
        
        self.mapDistanceToRadius = @{
                                              @"Auto":@0,
                                              @"2 blocks":@200,
                                              @"6 blocks":@600,
                                              @"1 mile":@1600,
                                              @"5 miles":@10000
                                              };
        
        self.mapSortBy = @{
                                    @"Best Match":@0,
                                    @"Distance":@1,
                                    @"Rating":@2
                        };

        // TODO: load selections from NSDefaults...
        //self.selections = [[NSMutableDictionary alloc] initWithCapacity:20];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.selections = [[defaults objectForKey:@"FilterOptions"] mutableCopy];
        
        // if no saved selections, then start with a default set.
        if (!self.selections) {
                            self.selections = [@{
                             @"Most Popular": [@[@"Offering a Deal"] mutableCopy],
                             @"Distance": [@[@"2 blocks"] mutableCopy],
                             @"Sort By": [@[@"Best Match"] mutableCopy],
                             @"Categories": [@[@"Automotive",@"Food"] mutableCopy]
                           } mutableCopy];
        }
    }
    return self;
}

-(NSDictionary *)searchParameters {
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    NSString *searchText = @"thai";
    NSLog(@"returning search parameters");
    NSDictionary *parameters = @{@"term": searchText, @"location" : @"San Francisco"};
    return parameters;
}

-(void)selectedRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *section = [self.sections objectAtIndex:indexPath.section];
    
    if ([section[@"type"] isEqualToValue:@(kTypeExpandable)]) {
        NSLog(@"selected row in expandable section");
        [self.selections setObject:@[[section[@"list"] objectAtIndex:indexPath.row]] forKey:section[@"name"]];
    } else {
        
        NSString *sectionName = section[@"name"];
        NSString *itemName = [section[@"list"] objectAtIndex:indexPath.row];
        NSMutableArray *selectedNames = [[self selectedNamesForSection:sectionName] mutableCopy];
        if ([selectedNames containsObject:itemName]) {
            NSLog(@"toggle on %@:%@",sectionName,itemName);
            [selectedNames removeObject:itemName];
        } else {
            NSLog(@"toggle off %@:%@",sectionName,itemName);
            [selectedNames addObject:itemName];
        }
        [self.selections setObject:selectedNames forKey:sectionName];
        NSLog(@"Selections now: %@",self.selections);
    }
}

-(BOOL)isSelectedAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *section = [self.sections objectAtIndex:indexPath.section];
    NSString *sectionName = section[@"name"];
    NSString *itemName = [section[@"list"] objectAtIndex:indexPath.row];
    NSArray *selectedNames = [self selectedNamesForSection:sectionName];
    
    BOOL isTheObjectThere = [selectedNames containsObject:itemName];
    return isTheObjectThere;
}

-(NSString *)selectionNameForSection:(NSString *)sectionName {
    NSArray *selections = [self.selections objectForKey:sectionName];
    return selections[0];
}
-(NSArray *)selectedNamesForSection:(NSString *)sectionName {
    return [self.selections objectForKey:sectionName];
}
-(void)save {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.selections forKey:@"FilterOptions"];
    NSLog(@"Saved options");
}

@end
