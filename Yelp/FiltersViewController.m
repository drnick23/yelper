//
//  FiltersViewController.m
//  Yelp
//
//  Created by Nicolas Halper on 3/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "FilterTableViewCell.h"
#import "SeeAllTableViewCell.h"

@interface FiltersViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) FilterOptions *filterOptions; // of NSDictionary

@property (nonatomic,assign) BOOL expanded;

@property (nonatomic,strong) NSMutableDictionary *expandedCategories;

// TODO: enum all types.

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)onSearch:(id)sender;
- (IBAction)onCancel:(id)sender;

@end

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithOptions:(FilterOptions *)options {
    self = [super init];
    if (self) {
        if (!options) {
            self.filterOptions = [[FilterOptions alloc] init];
        }
        [self setupOptions];
    }
    return self;
}

- (void)setupOptions {
    self.expandedCategories = [[NSMutableDictionary alloc] initWithCapacity:4];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // register our custom cells
    UINib *filterCellNib = [UINib nibWithNibName:@"FilterTableViewCell" bundle:nil];
    [self.tableView registerNib:filterCellNib forCellReuseIdentifier:@"FilterCell"];
    UINib *seeAllCellNib = [UINib nibWithNibName:@"SeeAllTableViewCell" bundle:nil];
    [self.tableView registerNib:seeAllCellNib forCellReuseIdentifier:@"SeeAllCell"];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *category = [self.filterOptions.sections objectAtIndex:indexPath.section];
    NSString *sectionName = category[@"name"];
    NSString *itemName = [category[@"list"] objectAtIndex:indexPath.row];
    NSArray *selectedNames = [self.filterOptions selectedNamesForSection:sectionName];
    
    NSLog(@"---cellForRow %d:%d",indexPath.section,indexPath.row);
    NSLog(@"name: %@ type:%@",sectionName,itemName);
    if ([category[@"type"] isEqualToValue:@(kTypeExpandable)]) {
        
        FilterTableViewCell *filterCell = [self.tableView dequeueReusableCellWithIdentifier:@"FilterCell" forIndexPath:indexPath];
        
        NSString *selectedName = selectedNames[0];
        NSLog(@"Expandable Category selectedName %@",selectedNames[0]);
        
        if (!self.expandedCategories[sectionName] || [self.expandedCategories[sectionName] isEqualToValue:@NO]) {
            NSLog(@"is not expanded, so setting cell name to selected value %@",selectedName);
            filterCell.name = selectedName;
            [filterCell setSelection:2];
        } else {
            NSLog(@"Compare %@ and %@ for selected setting",itemName,selectedName);
            filterCell.name = itemName;
            if ([itemName isEqualToString:selectedName]) {
                [filterCell setSelection:1];
            } else {
                [filterCell setSelection:0];
            }
        }
        
        return filterCell;
    }
    else if ([category[@"type"] isEqualToValue:@(kTypeSwitches)]) {
        
        if (!self.expandedCategories[sectionName] && (indexPath.row > 3)) {
            SeeAllTableViewCell *seeAllCell = [self.tableView dequeueReusableCellWithIdentifier:@"SeeAllCell" forIndexPath:indexPath];
            return seeAllCell;
        } else {
            NSLog(@"Switchable type expanded");
            FilterTableViewCell *filterCell = [self.tableView dequeueReusableCellWithIdentifier:@"FilterCell" forIndexPath:indexPath];
            filterCell.name = itemName;
            if ([self.filterOptions isSelectedAtIndexPath:indexPath]) {
                [filterCell setSelection:1];
            } else {
                [filterCell setSelection:0];
            }
            return filterCell;
        }

        
        NSLog(@"unknown category setting to itemName %@",itemName);
        
    }
    return nil;

    //return filterCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSLog(@"numberOfSectionsInTableView:%@ %@ %d",self.filterOptions,self.filterOptions.sections,[self.filterOptions.sections count]);
    
    return [self.filterOptions.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *category = [self.filterOptions.sections objectAtIndex:section];
    
    NSLog(@"----");
    NSLog(@"Number of rows for section %d in %@ is %d",section,category[@"name"],[category[@"list"] count]);
    NSLog(@"Category type is: %@", category[@"type"]);
    
    if ([category[@"type"] isEqualToValue:@(kTypeExpandable)]) {
        
        NSString *keyName = category[@"name"];
        
        if ([self.expandedCategories[keyName] isEqualToValue:@YES]) {
            NSLog(@"Expandable type expanded");
            return [category[@"list"] count];
        } else {
            NSLog(@"Expandable type not expanded, count is 1");
            return 1;
        }
        
    }
    else if ([category[@"type"] isEqualToValue:@(kTypeSwitches)]) {
        NSString *keyName = category[@"name"];
        
        if ([self.expandedCategories[keyName] isEqualToValue:@YES] || [category[@"list"] count] <= 6) {
            NSLog(@"Switchable type expanded");
            return [category[@"list"] count];
        } else {
            NSLog(@"Expandable list not expanded, limited to 4");
            return MIN([category[@"list"] count],5);
        }

    }
    else return [category[@"list"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // this method must be very fast for smooth scrolling.
    if (self.expanded) {
        return 50;
    } else {
        return 50;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSMutableDictionary *category = [self.filterOptions.sections objectAtIndex:indexPath.section];
    NSString *sectionName = category[@"name"];
    
    if ([category[@"type"] isEqualToValue:@(kTypeExpandable)]) {
        
        
        
        NSLog(@"checking key value at %@ to be %@",sectionName,self.expandedCategories[sectionName]);
        // check our dictionary if this expandable class is expanded or not
        if ([self.expandedCategories[sectionName] isEqualToValue:@YES]) {
            NSLog(@"Already expanded, must compress");
            [self.expandedCategories setObject:@(NO) forKey:sectionName];
            NSLog(@"setting key:%@ to row:%d object:%@",sectionName,indexPath.row,[category[@"list"] objectAtIndex:indexPath.row]);
            [self.filterOptions selectedRowAtIndexPath:indexPath];
            //[defaults setObject:[category[@"list"] objectAtIndex:indexPath.row] forKey:keyName];
            //self.options[keyName] = !self.options[keyName];
        } else {
            NSLog(@"Not expanded, must expand!");
            [self.expandedCategories setObject:@(YES) forKey:sectionName];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if ([category[@"type"] isEqualToValue:@(kTypeSwitches)]) {

        if (!self.expandedCategories[sectionName] && (indexPath.row > 3)) {
            [self.expandedCategories setObject:@(YES) forKey:sectionName];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        } else {
             NSLog(@"toggling section at path %@",indexPath);
            [self.filterOptions selectedRowAtIndexPath:indexPath];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }

        
       
        
    }
        /*
        if ([category[@"expanded"] isEqualToValue:@YES]) {
            NSLog(@"Must compress expandable");
            [category setObject:@(NO) forKey:@"expanded"];
        } else {
            NSLog(@"Most expand section");
            [category setObject:@(YES) forKey:@"expanded"];
        }*/
        //[self.tableView reloadData];
        /*[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];*/
        
    
    

    
    /*
    self.expanded = !self.expanded;
    //[self.tableView reloadData];
    
    if (self.expanded) {
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
    */
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSDictionary *category = [self.filterOptions.sections objectAtIndex:section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,30)];
    headerView.backgroundColor = [UIColor grayColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,10,300,20)];
    label.text = category[@"name"];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12.0];
    [headerView addSubview:label];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSearch:(id)sender {
    NSLog(@"dismiss and search");
    [self.filterOptions save];
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: call main view controllers search functions...
    // TODO: pass back new parameters to save from main function instead of here...
    [self.delegate addItemViewController:self didSearch:YES];
}

- (IBAction)onCancel:(id)sender {
    NSLog(@"dismiss and cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
