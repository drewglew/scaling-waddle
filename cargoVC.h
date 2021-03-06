//
//  CargoInOutVC.h
//  RoastChicken
//
//  Created by andrew glew on 25/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "calculationNSO.h"
#import "cargoCell.h"
#import "cargoNSO.h"
#import "searchVC.h"

@class dbHelper;

@protocol cargoIODelegate <NSObject>
@end

@interface cargoVC : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) id <cargoIODelegate> delegate;
@property (strong, nonatomic) calculationNSO *c;
@property (strong, nonatomic) NSMutableArray *ports;
@property (strong, nonatomic) IBOutlet UIButton *searchPortButton;
@property (strong, nonatomic) dbHelper *db;
@property (strong, nonatomic) NSIndexPath* buttonPressedIndexPath;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@end
