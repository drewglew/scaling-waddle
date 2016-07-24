//
//  calculationPVC.h
//  RoastChicken
//
//  Created by andrew glew on 23/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "calculationNSO.h"
#import "vesselNSO.h"
#import "portNSO.h"
#import "calculationDetailVC.h"


@class dbHelper;


@protocol calculationPVCDelegate <NSObject>
@end

@interface calculationPVC : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (strong, nonatomic) UIPageViewController *PageViewController;

@property (nonatomic, weak) id <calculationPVCDelegate,UIPageViewControllerDelegate> delegate;
@property (strong, nonatomic) dbHelper *db;
@property (strong, nonatomic) calculationNSO *c;
@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) NSMutableArray *opencalcs;
@property int total;

- (calculationDetailVC *)viewControllerAtIndex:(NSUInteger)index;


@end
