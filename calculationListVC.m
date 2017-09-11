//
//  ViewController.m
//  RoastChicken
//
//  Created by andrew glew on 20/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "calculationListVC.h"


@interface calculationListVC () <calcDetailDelegate, refreshCacheDelegate, UISearchResultsUpdating>

@end

@implementation calculationListVC
UIImageView *navBarHairlineImageView;
@synthesize db;
@synthesize calculations;
@synthesize filteredContentList;
@synthesize listing;


/* created 20150909 */
-(void)initDB {
    /* most times the database is already existing */
    self.db = [[dbHelper alloc] init];
    [self.db dbCreate :@"tankchartcalc.db"];
}



- (void)viewDidLoad {
    [super viewDidLoad];

    //dbManager *sharedDBManager = [dbManager shareDBManager];
    //[sharedDBManager dbInit:@"tankchartcalc.db"];
    
    [self initDB];
 self.filteredContentList = [[NSMutableArray alloc] init];
    
#if TARGET_IPHONE_SIMULATOR
    // where are you?
    NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
#endif
    
    self.selectedcalcs = [[NSMutableArray alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];

    [self setNeedsStatusBarAppearanceUpdate];
    
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    isSearching = NO;
    
    self.listing = [self.db getListing];
    
    [self.tableView reloadData];
    
    if (self.listing.count>0) {
    
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    navBarHairlineImageView.hidden = YES;
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearching) {
        tableView.rowHeight = self.tableView.rowHeight;
        return [self.filteredContentList count];
    }
    else {
        return [self.listing count];
    }
    
}



/* last modified 20160204 */

- (calculationCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"calculationCell";
    
    calculationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[calculationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    listingItemNSO *l;
    if (isSearching && self.filteredContentList.count!=0) {
        l = [self.filteredContentList objectAtIndex:indexPath.row];
    }
    else {
        l = [self.listing objectAtIndex:indexPath.row];
    }
    
    cell.descr.text = l.descr;
    cell.vesselfullname.text = l.full_name_vessel;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MMM-yyyy HH:mm"];
    NSString *dateLastModified=[dateFormat stringFromDate:l.lastmodified];
    cell.lastmodifiedlabel.text = [NSString stringWithFormat:@"%@",dateLastModified];
    cell.ldportslabel.text = l.ld_ports;
    cell.tcelabel.text = [NSString stringWithFormat:@"TCE Per Day: %.2f", [l.tce doubleValue]];
    cell.l = l;
    cell.multipleSelectionBackgroundView.backgroundColor = [UIColor clearColor];
    
    return cell;
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (IBAction)selectCalsPressed:(UIButton*)sender {
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    sender.selected =!sender.selected;
    
    if (sender.selected==true) {
        [self.tableView setEditing:sender.selected animated:true];
        
    } else {
        NSArray *rowsSelected = [self.tableView indexPathsForSelectedRows];
        BOOL selectedRows = rowsSelected.count > 0;
        
        if (selectedRows)
        {
            
            for (NSIndexPath *path in rowsSelected) {
                NSUInteger index = [path indexAtPosition:[path length] - 1];
                
                 if (isSearching) {
                     [self.selectedcalcs addObject:[self.filteredContentList objectAtIndex:index]];
                 } else {
                     [self.selectedcalcs addObject:[self.listing objectAtIndex:index]];
                 }
            }
            [self performSegueWithIdentifier:@"calculationwitharray" sender:sender];
            
        }
        [self.tableView setEditing:sender.selected animated:false];
        
    }
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Here the dataSource array is of dictionary objects
    listingItemNSO *l = [self.listing objectAtIndex:indexPath.row];
    
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.listing removeObjectAtIndex:indexPath.row];
        [self.db deleteCalculation: l.id];
        [self.tableView reloadData]; // tell table to refresh now
    }
}


- (void)addItemViewController:(calculationListVC *)controller keepDisplayState :(int)displayState {
    self.displayState = displayState;
}

- (void)searchTableList {
    NSString *searchData = self.searchbar.text;
    
    
    for (listingItemNSO *l in self.listing) {
        
        NSRange range = [l.searchstring rangeOfString:searchData];
        if (range.location != NSNotFound) {
            [self.filteredContentList addObject:l];
        }
        
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)theSearchBar {
    NSLog(@"searchBarTextDidEndEditing");
    isSearching = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"Text change - %d",isSearching);
    
    [self.filteredContentList removeAllObjects];
    
    if([searchText length] != 0) {
        isSearching = YES;
        [self searchTableList];
    }
    else {
        isSearching = NO;
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [self searchTableList];
}


-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return !self.tableView.isEditing;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    if (self.listing.count>0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    if([segue.identifier isEqualToString:@"calculation"]){
        calculationDetailVC *controller = (calculationDetailVC *)segue.destinationViewController;
        controller.delegate = self;
        [items addObject:[sender l]];
        
        controller.opencalcs = [self.db getCalculations :items];
        controller.c = [controller.opencalcs firstObject];
        controller.db = self.db;
        
    } else if([segue.identifier isEqualToString:@"newcalculation"]){
        calculationDetailVC *controller = (calculationDetailVC *)segue.destinationViewController;
        controller.delegate = self;
        calculationNSO *c = [[calculationNSO alloc] init];
        controller.c = c;
        [self.selectedcalcs addObject:c];
        controller.opencalcs = self.selectedcalcs;
        controller.db = self.db;
        
    } else if([segue.identifier isEqualToString:@"calculationwitharray"]){
        calculationDetailVC *controller = (calculationDetailVC *)segue.destinationViewController;
        controller.delegate = self;
        controller.db = self.db;
        controller.opencalcs = [self.db getCalculations :self.selectedcalcs];
        controller.c = [controller.opencalcs firstObject];
        
    } else if([segue.identifier isEqualToString:@"updateData"]){
        refreshCacheVC *controller = (refreshCacheVC *)segue.destinationViewController;
        controller.delegate = self;
        controller.db = self.db;
    }
}


@end
