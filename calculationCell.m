//
//  calculationCell.m
//  RoastChicken
//
//  Created by andrew glew on 28/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "calculationCell.h"

@implementation calculationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    UIView *bgColorView = [[UIView alloc] init];
    //Grey
    [bgColorView setBackgroundColor:[UIColor colorWithRed:138.0f/255.0f green:144.0f/255.0f blue:153.0f/255.0f alpha:1.0]];
    [self setSelectedBackgroundView:bgColorView];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.viewbackground.layer.cornerRadius = 5.0;;
    self.viewbackground.layer.masksToBounds = YES;
    self.viewbackground.layer.borderWidth = 1.0f; //make border 1px thick
    self.viewbackground.layer.borderColor = [UIColor colorWithRed:43.0f/255.0f green:51.0f/255.0f blue:70.0f/255.0f alpha:1.0].CGColor;
    
    
}


@end
