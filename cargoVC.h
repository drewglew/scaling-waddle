//
//  CargoInOutVC.h
//  RoastChicken
//
//  Created by andrew glew on 25/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "calculationNSO.h"
#import "CargoInOutTVCell.h"
#import "cargoioNSO.h"
#import "searchVC.h"

@class dbHelper;

@protocol cargoIODelegate <NSObject>
@end

@interface cargoVC : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) id <cargoIODelegate> delegate;
@property (strong, nonatomic) calculationNSO *c;
@property (strong, nonatomic) NSMutableArray *ports;
@property (strong, nonatomic) dbHelper *db;
@property (strong, nonatomic) NSIndexPath* buttonPressedIndexPath;
@end
