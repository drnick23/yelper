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

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)onFilter:(id)sender;

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic,strong) YelpResultList *results;
@property (nonatomic,strong) NSString *searchText;

@end

@implementation MainViewController

- (id)init {
    self = [super init];
    if (self) {
        NSLog(@"init main view controller with last search term %@",self.searchText);
        self.searchText = @"Thai";
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

- (void)doSearch {
    // perform search with all saved settings/filters
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *searchText = [defaults objectForKey:@"searchText"];
    
    NSLog(@"doSearch %@",searchText);
    
    NSLog(@"radius search %@",[defaults objectForKey:@"Distance"]);
    NSLog(@"sort by %@",[defaults objectForKey:@"Sort By"]);
    NSLog(@"category %@",[defaults objectForKey:@"Categories"]);
    
    [self.client searchWithTerm:searchText success:^(AFHTTPRequestOperation *operation, id response) {
        self.results = [[YelpResultList alloc] initWithResponse:response];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
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
    
    self.searchBar.text = [defaults objectForKey:@"searchText"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
    /*
    YelpResult *result = [self.results get:indexPath.row];
    
    CGSize textSize = [result.name sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(240, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
    
    float height = MIN(textSize.height+100.0f, 150.0f); //Some fix height is returned if height is small or change it to MAX(textSize.height, 150.0f); // whatever best fits for you
    
    return height;*/
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onFilter:(id)sender {
    NSLog(@"Go ahead and setup the filters view");
    
    UIViewController *filtersView = [[FiltersViewController alloc] init];
    filtersView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:filtersView animated:YES completion:nil];
    
}
@end
