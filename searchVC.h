//
//  searchVC.h
//  RoastChicken
//
//  Created by andrew glew on 21/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "searchTVC.h"
#import "vesselNSO.h"
#import "portNSO.h"


@protocol searchDelegate <NSObject>
- (void)didPickItem :(NSNumber*)ref :(NSString*) searchitem;
- (void)didPickPortItem :(NSString*)refport :(NSString*)searchitem;
@end

@interface searchVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {
BOOL isSearching;
    NSMutableArray *searchItems;
    NSMutableArray *filteredContentList;
    NSString *searchtype;
    
}
@property (nonatomic, weak) id <searchDelegate> delegate;
@property (strong, nonatomic) NSString *searchtype;
@property (strong, nonatomic) NSMutableArray *searchItems;
@property (strong, nonatomic) NSArray *filteredContentList;
@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;
@property (strong, nonatomic) IBOutlet UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
