//
//  vesselCell.h
//  RoastChicken
//
//  Created by andrew glew on 28/08/2017.
//  Copyright © 2017 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface vesselCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *vesselNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *DistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *PortNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *VoyageLabel;

@end
