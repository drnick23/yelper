//
//  FiltersViewController.h
//  Yelp
//
//  Created by Nicolas Halper on 3/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterOptions.h"

@class FiltersViewController;

@protocol FiltersViewControllerDelegate <NSObject>
//-(void) addItemViewController:(FiltersViewController *)controller didSearch:(BOOL)doSearch;
-(void) updateFilterOptions:(FilterOptions *)filterOptions;
@end

@interface FiltersViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) id <FiltersViewControllerDelegate> delegate;

-(id)initWithOptions:(FilterOptions *)options;

@end
