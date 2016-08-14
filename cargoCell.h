//
//  cargoCell.h
//  RoastChicken
//
//  Created by andrew glew on 28/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cargoNSO.h"

@interface cargoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *portText;

@property (strong, nonatomic) IBOutlet UITextField *PEXText;
@property (strong, nonatomic) IBOutlet UITextField *qtyText;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segType;
@property (strong, nonatomic) IBOutlet UIButton *searchPortButton;




@property (strong, nonatomic) IBOutlet UITextField *noticeText;
@property (strong, nonatomic) IBOutlet UITextField *estText;
@property (strong, nonatomic) IBOutlet UIButton *openPortButton;
@property (strong, nonatomic) IBOutlet UIView *viewbackground;
@property (strong, nonatomic) cargoNSO *cargo;
@property (strong, nonatomic) IBOutlet UILabel *ldLabel;
@end
