//
//  cargoCell.m
//  RoastChicken
//
//  Created by andrew glew on 28/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "cargoCell.h"

@implementation cargoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.viewbackground.layer.cornerRadius = 5.0;;
    self.viewbackground.layer.masksToBounds = YES;
    self.viewbackground.layer.borderWidth = 1.0f; //make border 1px thick
    self.viewbackground.layer.borderColor = [UIColor colorWithRed:43.0f/255.0f green:51.0f/255.0f blue:70.0f/255.0f alpha:1.0].CGColor;
    
    
}


- (IBAction)qtyEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    self.cargo.units = [f numberFromString:self.qtyText.text];
}
- (IBAction)typeEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    self.cargo.type_id = [f numberFromString:self.typeText.text];
}

- (IBAction)estEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    self.cargo.estimated = [f numberFromString:self.estText.text];
}
- (IBAction)pexEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    self.cargo.expense = [f numberFromString:self.PEXText.text];
    
}
- (IBAction)termsEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    self.cargo.terms_id = [f numberFromString:self.termsText.text];
    
}

- (IBAction)noticeEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    self.cargo.notice_time = [f numberFromString:self.noticeText.text];
}

- (IBAction)portEditingEnded:(id)sender {
    self.cargo.port.code = self.portText.text;
}


-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    [self.qtyText resignFirstResponder];
    [self.typeText resignFirstResponder];
    [self.estText resignFirstResponder];
    [self.PEXText resignFirstResponder];
    [self.termsText resignFirstResponder];
    [self.noticeText resignFirstResponder];
}



@end
