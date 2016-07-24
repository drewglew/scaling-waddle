//
//  calculationDetailVC.h
//  RoastChicken
//
//  Created by andrew glew on 21/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "vesselNSO.h"
#import "portNSO.h"
#import "calculationNSO.h"
#import "searchVC.h"

@class dbHelper;

@protocol calcDetailDelegate <NSObject>
@end
@interface calculationDetailVC : UIViewController
@property (nonatomic, weak) id <calcDetailDelegate> delegate;
@property (strong, nonatomic) dbHelper *db;
@property (strong, nonatomic) calculationNSO *c;
@property (strong, nonatomic) NSNumber *cloneid;
@property (assign, nonatomic) NSUInteger currentpageindex;
@property (strong, nonatomic) NSMutableArray *opencalcs;
@property (strong, nonatomic) IBOutlet UIView *calcBackgroundView;
@property (strong, nonatomic) IBOutlet UILabel *calcRefLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@end
