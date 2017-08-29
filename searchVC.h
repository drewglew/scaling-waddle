//
//  searchVC.h
//  RoastChicken
//
//  Created by andrew glew on 21/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "searchCell.h"
#import "vesselNSO.h"
#import "portNSO.h"
#import "vesselSuggestionVC.h"


@protocol searchDelegate <NSObject>
- (void)didPickItem :(NSNumber*)ref :(NSString*) searchitem;
- (void)didPickPortItem :(NSString*)refport :(NSString*)searchitem;
@end

@interface searchVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate>  {
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
@property (strong, nonatomic) portNSO *loadport;
@property (strong, nonatomic) dbHelper *db;
@end
