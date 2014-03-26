//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "YelpResultTableViewCell.h"
#import "YelpResultList.h"
#import "MBProgressHUD.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <FiltersViewControllerDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)onFilter:(id)sender;

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic,strong) YelpResultList *results;
@property (nonatomic,strong) NSString *searchText;

@property (nonatomic,strong) FilterOptions *filterOptions; // of NSDictionary

@property (nonatomic,strong) YelpResultTableViewCell *prototypeCell;

@end

@implementation MainViewController

- (id)init {
    self = [super init];
    if (self) {
        NSLog(@"init main view controller with last search term %@",self.searchText);
        self.searchText = @"Thai";
        self.filterOptions = [[FilterOptions alloc] init];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
    }
    return self;
}

// perform search with all saved settings/filters
- (void)doSearch {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *searchText = [defaults objectForKey:@"searchText"];
    if (!searchText) searchText = @"";
    
    NSLog(@"doSearch %@",searchText);
    
    NSMutableDictionary *parameters = [self.filterOptions.searchParameters mutableCopy];
    [parameters setObject:searchText forKey:@"term"];
    
    // show progress indicator when searching
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.client searchWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
        
        // hide progress indicator.
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.results = [[YelpResultList alloc] initWithResponse:response];
        
        NSLog(@"got search results back");
         [self refreshAfterSearch];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
        // hide progress indicator.
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)refreshAfterSearch {
    NSLog(@"refreshing view after search");
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // customize nav bar
    self.navigationBar.tintColor = [UIColor redColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // register our custom cells
    UINib *yelpResultNib = [UINib nibWithNibName:@"YelpResultTableViewCell" bundle:nil];
    [self.tableView registerNib:yelpResultNib forCellReuseIdentifier:@"YelpResultCell"];
    
    NSString *searchText = [defaults objectForKey:@"searchText"];
    if (searchText) {
        self.searchBar.text = searchText;
    } else {
        self.searchBar.text = @"";
    }
    [self doSearch];
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"searchDisplayController reload search %@",searchString);
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    // You'll probably want to do this on another thread
    // SomeService is just a dummy class representing some
    // api that you are using to do the search
    //NSArray *results = [SomeService doSearch:searchBar.text];
	NSLog(@"Perform search %@",searchText);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setObject:searchBar.text forKey:@"searchText"];
    [searchBar setShowsCancelButton:NO animated:YES];
    
    [self doSearch];
    //[searchBar resignFirstResponder];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"row count %d", [self.results count]);
    return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"Cell for row %d",indexPath.row);
    static NSString *CellIdentifier = @"YelpResultCell";
    
    YelpResult *result = [self.results get:indexPath.row];
    //NSLog(@"got result for %d",indexPath.row);
    YelpResultTableViewCell *resultCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    resultCell.result = result;
    
    return resultCell;
}

- (YelpResultTableViewCell *)prototypeCell
{
    if (!_prototypeCell) {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"YelpResultCell"];
    }
    return _prototypeCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Data for the cell, e.g. text for label
    YelpResult *result = [self.results get:indexPath.row];
    
    // Prototype knows how to calculate its height for the given data
    return [self.prototypeCell myHeightForResult:result];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onFilter:(id)sender {
    NSLog(@"Go ahead and setup the filters view");
    
    FiltersViewController *filtersView = [[FiltersViewController alloc] initWithOptions:Nil];
    filtersView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    filtersView.delegate = self;
    
    [self presentViewController:filtersView animated:YES completion:nil];
}

-(void)addItemViewController:(FiltersViewController *)controller didSearch:(BOOL)doSearch {
    NSLog(@"Got call back from filters model with %hhd",doSearch);
    if (doSearch) {
        self.filterOptions = [[FilterOptions alloc] init];;
        [self doSearch];
    }
    
}

@end
