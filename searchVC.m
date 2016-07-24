//
//  searchVC.m
//  RoastChicken
//
//  Created by andrew glew on 21/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "searchVC.h"

@interface searchVC () <UISearchResultsUpdating>

@end

@implementation searchVC
@synthesize delegate;
@synthesize searchItems;
@synthesize filteredContentList;
@synthesize searchtype;



- (void)viewDidLoad {
    [super viewDidLoad];
    self.filteredContentList = [[NSMutableArray alloc] init];
    
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
    
    searchTVC *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[searchTVC alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if ([self.searchtype isEqual:@"vessel"]){
        
        vesselNSO *v;
        // Configure the cell...
        if (isSearching) {
            v = [self.filteredContentList objectAtIndex:indexPath.row];
        }
        else {
            v = [self.searchItems objectAtIndex:indexPath.row];
        }

        cell.itemLabel.text = v.searchstring;
        cell.ref = v.nr;
        cell.indexLabel.text = [NSString stringWithFormat:@"%@",v.nr];
        cell.ref = v.nr;
        
    } else if ([self.searchtype isEqual:@"ballfromport"] || [self.searchtype isEqual:@"fromport"] || [self.searchtype isEqual:@"toport"] ){
        portNSO *p;
        // Configure the cell...
        if (isSearching) {
            p = [self.filteredContentList objectAtIndex:indexPath.row];
        }
        else {
            p = [self.searchItems objectAtIndex:indexPath.row];
        }
        
        cell.itemLabel.text = p.searchstring;
        cell.portref = p.code;
    }

    //[cell setNeedsDisplay];
    [cell.itemLabel setNeedsDisplay];
    
    return cell;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //where indexPath.row is the selected cell

    
    if ([self.searchtype isEqualToString:@"vessel"]) {
    
        vesselNSO *v;
    
        if (isSearching) {
            v = [self.filteredContentList objectAtIndex:indexPath.row];
        } else {
            v = [self.searchItems objectAtIndex:indexPath.row];
        }
        [self.delegate didPickItem:v.nr :@"vessel"];
    
    } else if ([self.searchtype isEqual:@"ballfromport"] || [self.searchtype isEqual:@"fromport"] || [self.searchtype isEqual:@"toport"] ) {
        
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
         
     }  else if ([self.searchtype isEqual:@"ballfromport"] || [self.searchtype isEqual:@"fromport"] || [self.searchtype isEqual:@"toport"] ) {
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



@end
