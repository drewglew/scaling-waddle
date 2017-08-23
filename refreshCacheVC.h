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

@end
