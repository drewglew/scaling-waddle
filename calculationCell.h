//
//  calculationCell.h
//  RoastChicken
//
//  Created by andrew glew on 28/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "calculationNSO.h"
#import "listingItemNSO.h"

@interface calculationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *descr;
@property (strong, nonatomic) listingItemNSO *l;
@property (weak, nonatomic) IBOutlet UILabel *vesselfullname;
@property (strong, nonatomic) IBOutlet UIView *viewbackground;
@property (strong, nonatomic) IBOutlet UILabel *lastmodifiedlabel;
@property (strong, nonatomic) IBOutlet UILabel *ldportslabel;

@end
