//
//  FiltersViewController.m
//  Yelp
//
//  Created by Nicolas Halper on 3/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "FilterTableViewCell.h"

enum FilterCategoryListTypes {
    kTypeSegmented,
    kTypeSwitches,
    kTypeExpandable,
    kTypeList
};

typedef enum FilterCategoryListTypes FilterCategoryListTypes;


@interface FiltersViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *categories;
@property (nonatomic,strong) NSMutableDictionary *options; // of NSDictionary

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

- (void)setupOptions {
    self.options = [[NSMutableDictionary alloc] initWithCapacity:20];
    self.expandedCategories = [[NSMutableDictionary alloc] initWithCapacity:4];
    
    self.categories = @[
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
            @"name":@"Categories",
            @"type":@(kTypeExpandable),
            @"list":@[@"All",@"Active Life",@"Arts & Entertainment",@"Automotive",@"Beauty & Spas",@"Education",@"Event Planning & Services",@"Financial Services",@"Food"],
        },
        @{
            @"name":@"Sort By",
            @"type":@(kTypeExpandable),
            @"list":@[@"Best Match",@"Distance",@"Rating"],
        }
   ];
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
    
    // create our categories
    [self setupOptions];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *category = [self.categories objectAtIndex:indexPath.section];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    static NSString *CellIdentifier = @"FilterCell";
    FilterTableViewCell *filterCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *itemName = [category[@"list"] objectAtIndex:indexPath.row];
    
    NSString *keyName = category[@"name"];
    NSString *selectedName = [defaults objectForKey:keyName];
    
    if ([category[@"type"] isEqualToValue:@(kTypeExpandable)]) {
        if ([self.expandedCategories[keyName] isEqualToValue:@NO]) {
            // if we're not expanded, override name is the saved default value
            NSLog(@"category %@ not expanded so getting NSDefaults saved value %@",category[@"name"],[defaults objectForKey:keyName]);
            itemName = selectedName;
            NSLog(@"setting state to 1");
            [filterCell setSelection:2];
        }
        else {
            NSLog(@"Compare %@ and %@",keyName,selectedName);
            if ([itemName isEqualToString:selectedName]) {
                [filterCell setSelection:1];
            } else {
                [filterCell setSelection:0];
            }
        }
    }

    
   
    
    
    
    filterCell.name = itemName;
    //filterCell = @"Test name";

    return filterCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSLog(@"numberOfSectionsInTableView:%d",[self.categories count]);
    
    return [self.categories count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *category = [self.categories objectAtIndex:section];
    
    //NSLog(@"Number of rows for section %d in %@ is %d",section,category[@"name"],[category[@"list"] count]);
    //NSLog(@"Category type is: %@", category[@"type"]);
    
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
    
    return [category[@"list"] count];
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSMutableDictionary *category = [self.categories objectAtIndex:indexPath.section];
    
    if ([category[@"type"] isEqualToValue:@(kTypeExpandable)]) {
        
        NSString *keyName = category[@"name"];
        
        NSLog(@"checking key value at %@ to be %@",keyName,self.expandedCategories[keyName]);
        // check our dictionary if this expandable class is expanded or not
        if ([self.expandedCategories[keyName] isEqualToValue:@YES]) {
            NSLog(@"Already expanded, must compress");
            [self.expandedCategories setObject:@(NO) forKey:keyName];
            NSLog(@"setting key:%@ to row:%d object:%@",keyName,indexPath.row,[category[@"list"] objectAtIndex:indexPath.row]);
            [defaults setObject:[category[@"list"] objectAtIndex:indexPath.row] forKey:keyName];
            //self.options[keyName] = !self.options[keyName];
        } else {
            NSLog(@"Not expanded, must expand!");
            [self.expandedCategories setObject:@(YES) forKey:keyName];
        }

        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    
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
    
    NSDictionary *category = [self.categories objectAtIndex:section];
    
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
