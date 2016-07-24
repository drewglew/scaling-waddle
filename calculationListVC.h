//
//  ViewController.h
//  RoastChicken
//
//  Created by andrew glew on 20/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

// THIS IS MASTER - need to redo page control based in the original project. DOH!

#import <UIKit/UIKit.h>
#import "calcTVC.h"
#import "calculationNC.h"
#import "calculationDetailVC.h"
#import "dbHelper.h"



@interface calculationListVC : UIViewController
@property (strong, nonatomic) dbHelper *db;
@property (strong, nonatomic) NSMutableArray *calculations;
@property (strong, nonatomic) NSMutableArray *selectedcalcs;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign) int displayState;
@end

