//
//  vesselSuggestionVC.h
//  RoastChicken
//
//  Created by andrew glew on 29/08/2017.
//  Copyright © 2017 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "portNSO.h"
#import "vesselNSO.h"
#import "vesselPosNSO.h"
#import "dbHelper.h"
#import "vesselCell.h"

@interface vesselSuggestionVC : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) portNSO *loadport;
@property (weak, nonatomic) vesselNSO *vessel;
@property (strong, nonatomic) NSMutableArray *posData;
@property (strong, nonatomic) NSArray *posSortedData;
@property (strong, nonatomic) dbHelper *db;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndictor;
@property (weak, nonatomic) IBOutlet UILabel *labelHeader;

@end
