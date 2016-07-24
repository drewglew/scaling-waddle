//
//  calculationNC.h
//  RoastChicken
//
//  Created by andrew glew on 21/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "calculationDetailVC.h"

#import "vesselNSO.h"
#import "portNSO.h"
#import "calculationNSO.h"



@interface calculationNC : UINavigationController

@property (strong, nonatomic) calculationNSO *c;

@end
