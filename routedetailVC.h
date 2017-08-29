//
//  routedetailVC.h
//  RoastChicken
//
//  Created by andrew glew on 17/08/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "routeCell.h"
#import "routeNSO.h"
#import "AppDelegate.h"

@protocol routedetailDelegate <NSObject>
@end
@interface routedetailVC : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) id <routedetailDelegate> delegate;
@property (nonatomic) NSDictionary *routing;
@property (nonatomic) UIImage *mapImage;
@property (strong, nonatomic) IBOutlet UIImageView *mapImageView;
@property (strong, nonatomic) IBOutlet UIScrollView *mapScrollView;
@property (strong, nonatomic) IBOutlet UITableView *routingTableView;
@property (strong, nonatomic) NSMutableArray *listing;
@property (nonatomic) NSNumber *total_distance;

@end
