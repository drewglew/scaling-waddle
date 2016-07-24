//
//  CalcTVC.h
//  RoastChicken
//
//  Created by andrew glew on 20/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "calculationNSO.h"

@interface CalcTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descr;
@property (strong, nonatomic) calculationNSO *c;
@property (weak, nonatomic) IBOutlet UILabel *vesselfullname;
@property (strong, nonatomic) IBOutlet UIView *viewbackground;


@end
