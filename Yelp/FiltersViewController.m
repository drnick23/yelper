//
//  FiltersViewController.m
//  Yelp
//
//  Created by Nicolas Halper on 3/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "FilterTableViewCell.h"


@interface FiltersViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *categories;
@property (nonatomic,strong) NSArray *options; // of NSDictionary

@property (nonatomic,assign) BOOL expanded;

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
    self.categories = [NSMutableArray arrayWithObjects:
        @{
            @"name":@"Price",
            @"type":@"segmented",
            @"list":@[@"$",@"$$",@"$$$",@"$$$$"]
        },
        @{
            @"name":@"Most Popular",
            @"type":@"switches",
            @"list":@[@"Open Now",@"Hot & New",@"Offering a Deal",@"Delivery"]
        },
        @{
            @"name":@"Distance",
            @"type":@"expandable",
            @"list":@[@"Auto",@"2 blocks",@"6 blocks",@"1 mile",@"5 miles"]
        },
        @{
            @"name":@"Sort By",
            @"type":@"expandable",
            @"list":@[@"Best Match",@"Distance",@"Rating",@"Most Reviewed"]
        },
        @{
          @"name":@"General Features",
          @"type":@"expandable",
          @"list":@[@"Take-out",@"Good for Groups",@"Has TV",@"Accepts Credit Cards",@"Wheelchair Accessible",@"Full Bar",@"Beer & Wine only",@"Happy Hour",@"Free Wi-Fi",@"Paid Wi-fi"]
        },
         nil
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
    NSString *itemName = [category[@"list"] objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"FilterCell";
    
    FilterTableViewCell *filterCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    filterCell.name = itemName;
    //filterCell = @"Test name";

    return filterCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSLog(@"numberOfSectionsInTableView:%d",[self.categories count]);
    
    return [self.categories count];
    /*
    if (self.expanded) {
        return 2;
    } else {
        return 1;
    }*/
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *category = [self.categories objectAtIndex:section];
    NSLog(@"Number of rows for section %d in %@ is %d",section,category[@"name"],[category[@"list"] count]);
    return [category[@"list"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // this method must be very fast for smooth scrolling.
    if (self.expanded) {
        return 300;
    } else {
        return 150;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    self.expanded = !self.expanded;
    //[self.tableView reloadData];
    
    if (self.expanded) {
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
    
   }

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSDictionary *category = [self.categories objectAtIndex:section];
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,40)];
    headerView.backgroundColor = [UIColor redColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,10,300,20)];
    label.text = category[@"name"];
    
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
}

- (IBAction)onCancel:(id)sender {
    NSLog(@"dismiss and cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
