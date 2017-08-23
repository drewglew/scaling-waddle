//
//  ViewController.h
//  RoastChicken
//
//  Created by andrew glew on 20/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

// THIS IS MASTER - need to redo page control based in the original project. DOH!

#import <UIKit/UIKit.h>
#import "calculationCell.h"
#import "calculationNC.h"
#import "calculationDetailVC.h"
#import "refreshCacheVC.h"
#import "dbHelper.h"
#import "dbManager.h"


@interface calculationListVC : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    BOOL isSearching;
    NSMutableArray *filteredContentList;
}


@property (strong, nonatomic) dbHelper *db;
@property (strong, nonatomic) NSMutableArray *calculations;
@property (strong, nonatomic) NSMutableArray *selectedcalcs;
@property (strong, nonatomic) NSMutableArray *listing;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign) int displayState;
@property (strong, nonatomic) IBOutlet UISearchBar *searchbar;

@property (strong, nonatomic) NSMutableArray *filteredContentList;






@end

