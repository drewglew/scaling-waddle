//
//  searchVC.m
//  RoastChicken
//
//  Created by andrew glew on 21/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "searchVC.h"

@interface searchVC () <UISearchResultsUpdating>
@property (nonatomic, strong) id previewingContext;

@end

@implementation searchVC
@synthesize delegate;
@synthesize searchItems;
@synthesize filteredContentList;
@synthesize searchtype;
@synthesize loadport;



- (void)viewDidLoad {
    [super viewDidLoad];
    self.filteredContentList = [[NSMutableArray alloc] init];
     self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    if ([self isForceTouchAvailable]) {
        self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (isSearching) {
        return [self.filteredContentList count];
    }
    else {
        return [self.searchItems count];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



/* not working yet so TODO */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"searchCell";
    
    searchCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[searchCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if ([self.searchtype isEqual:@"vessel"]){
        
        vesselNSO *v;
        // Configure the cell...
        if (isSearching) {
            if (self.filteredContentList.count != 0) {
                v = [self.filteredContentList objectAtIndex:indexPath.row];
                cell.itemLabel.text = v.searchstring;
                cell.ref = v.nr;
                cell.indexLabel.text = [NSString stringWithFormat:@"%@",v.nr];
                cell.ref = v.nr;
            }
        }
        else {
            v = [self.searchItems objectAtIndex:indexPath.row];
            cell.itemLabel.text = v.searchstring;
            cell.ref = v.nr;
            cell.indexLabel.text = [NSString stringWithFormat:@"%@",v.nr];
            cell.ref = v.nr;
        }
        
    } else if ([self.searchtype isEqual:@"ballfromport"] || [self.searchtype isEqual:@"cargoport"] ){
        portNSO *p;
        // Configure the cell...
        if (isSearching) {
            if (self.filteredContentList.count != 0) {
                p = [self.filteredContentList objectAtIndex:indexPath.row];
                cell.itemLabel.text = p.searchstring;
                cell.portref = p.code;
            }
        }
        else {
            p = [self.searchItems objectAtIndex:indexPath.row];
            cell.itemLabel.text = p.searchstring;
            cell.portref = p.code;
        }
    }

    //[cell setNeedsDisplay];
    [cell.itemLabel setNeedsDisplay];
    
    return cell;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.searchtype isEqualToString:@"vessel"]) {
    
        vesselNSO *v;
    
        if (isSearching) {
            v = [self.filteredContentList objectAtIndex:indexPath.row];
        } else {
            v = [self.searchItems objectAtIndex:indexPath.row];
        }
        [self.delegate didPickItem:v.nr :@"vessel"];
    
    } else if ([self.searchtype isEqual:@"ballfromport"] || [self.searchtype isEqual:@"cargoport"]) {
        
        portNSO *p;
        
        if (isSearching) {
            p = [self.filteredContentList objectAtIndex:indexPath.row];
        } else {
            p = [self.searchItems objectAtIndex:indexPath.row];
        }
        [self.delegate didPickPortItem:p.code :self.searchtype];
    }
}


- (void)searchTableList {
    NSString *searchData = self.searchbar.text;

    
     if ([self.searchtype isEqualToString:@"vessel"]) {
    
         for (vesselNSO *v in self.searchItems) {
        
            NSRange range = [v.searchstring rangeOfString:searchData];
            if (range.location != NSNotFound) {
                [filteredContentList addObject:v];
            }
  
        }
         
     }  else if ([self.searchtype isEqual:@"ballfromport"] || [self.searchtype isEqual:@"cargoport"] ) {
         for (portNSO *p in self.searchItems) {
             
             NSRange range = [p.searchstring rangeOfString:searchData];
             if (range.location != NSNotFound) {
                 [filteredContentList addObject:p];
             }
             
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
    
    //Remove all objects first.
    [filteredContentList removeAllObjects];
    
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


/*
-(BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}
*/

- (void)didPickItem :(NSNumber*)ref :(NSString*)searchtype {
    
    
    
}

- (void)didPickPortItem :(NSString*)refport :(NSString*)searchitem {
    
}

- (BOOL)isForceTouchAvailable {
    BOOL isForceTouchAvailable = NO;
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    }
    return isForceTouchAvailable;
}


- (UIViewController *)previewingContext:(id )previewingContext viewControllerForLocation:(CGPoint)location{
    // check if we're not already displaying a preview controller (WebViewController is my preview controller)
    if ([self.presentedViewController isKindOfClass:[vesselSuggestionVC class]]) {
        return nil;
    }
    // without a loadport we are unable to suggest which vessel is closest to us.
    if (self.loadport.abc_code==nil) {
        return nil;
    }
    
    
    CGPoint cellPostion = [self.tableView convertPoint:location fromView:self.view];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:cellPostion];
    
    if (path) {
        
        // get your UIStoryboard
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        // set the view controller by initializing it form the storyboard
        vesselSuggestionVC *previewController = [storyboard instantiateViewControllerWithIdentifier:@"vesselPreview"];
        
        previewController.loadport = self.loadport;
        
        if ([self.searchtype isEqualToString:@"vessel"]) {
            
            vesselNSO *v;
            
            if (isSearching) {
                v = [self.filteredContentList objectAtIndex:path.row];
            } else {
                v = [self.searchItems objectAtIndex:path.row];
            }
            
            previewController.vessel = v;
            previewController.db = self.db;
        }
        // if you want to transport date use your custom "detailItem" function like this:
        //previewController.detailItem = [self.data objectAtIndex:path.row];
        
        //previewingContext.sourceRect = [self.view convertRect:tableCell.frame fromView:self.tableView];
        
        return previewController;
    }
    return nil;
}
 

- (void)previewingContext:(id )previewingContext commitViewController: (UIViewController *)viewControllerToCommit {
    
    // if you want to present the selected view controller as it self us this:
    // [self presentViewController:viewControllerToCommit animated:YES completion:nil];
    
    // to render it with a navigation controller (more common) you should use this:
    [self.navigationController showViewController:viewControllerToCommit sender:nil];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if ([self isForceTouchAvailable]) {
        if (!self.previewingContext) {
            self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
        }
    } else {
        if (self.previewingContext) {
            [self unregisterForPreviewingWithContext:self.previewingContext];
            self.previewingContext = nil;
        }
    }
}



@end
