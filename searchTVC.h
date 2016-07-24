//
//  saerchTVC.h
//  RoastChicken
//
//  Created by andrew glew on 21/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (strong, nonatomic) NSNumber *ref;
@property (strong, nonatomic) NSString *portref;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@end
