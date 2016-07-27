//
//  CargoInOutTVCell.h
//  RoastChicken
//
//  Created by andrew glew on 25/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cargoioNSO.h"

@interface CargoInOutTVCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *portText;

@property (strong, nonatomic) IBOutlet UITextField *PEXText;
@property (strong, nonatomic) IBOutlet UITextField *qtyText;
@property (strong, nonatomic) IBOutlet UITextField *typeText;
@property (strong, nonatomic) IBOutlet UITextField *termsText;
@property (strong, nonatomic) IBOutlet UITextField *noticeText;
@property (strong, nonatomic) IBOutlet UITextField *estText;
@property (strong, nonatomic) IBOutlet UIButton *openPortButton;
@property (strong, nonatomic) IBOutlet UIView *viewbackground;
@property (strong, nonatomic) cargoioNSO *cio;
@property (strong, nonatomic) IBOutlet UILabel *ldLabel;



@end
