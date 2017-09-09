//
//  refreshCacheVC.h
//  RoastChicken
//
//  Created by andrew glew on 23/08/2017.
//  Copyright © 2017 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "vesselNSO.h"
#import "portNSO.h"
@class dbHelper;

@protocol refreshCacheDelegate <NSObject>
@end

@interface refreshCacheVC : UIViewController
@property (nonatomic, weak) id <refreshCacheDelegate> delegate;
@property (strong, nonatomic) dbHelper *db;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentZones;
@property (strong, nonatomic) NSMutableArray *vessels;
@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIStepper *stepperYear;
@property (weak, nonatomic) IBOutlet UILabel *labelYear;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentSpeed;

@end
