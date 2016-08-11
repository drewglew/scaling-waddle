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
    
    UIView *inputAccesoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    // It´s good idea a view under the button in order to change the color...more custom option
    //inputAccesoryView.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width) - 110, 5, 100, 30)];
    // configure the button here... you choose.
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setBackgroundColor:[UIColor darkGrayColor]];
    doneButton.layer.cornerRadius = 5.0;;
    doneButton.layer.masksToBounds = YES;
    
    [inputAccesoryView addSubview:doneButton];
    [inputAccesoryView setBackgroundColor:[UIColor lightGrayColor]];

    self.estText.inputAccessoryView = inputAccesoryView;
    self.PEXText.inputAccessoryView = inputAccesoryView;
    self.noticeText.inputAccessoryView = inputAccesoryView;
    self.termsText.inputAccessoryView = inputAccesoryView;
    self.typeText.inputAccessoryView = inputAccesoryView;
    
    //UIView *inputAccesoryViewTwoButtons = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    
    UIButton *minusButton = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-300)/2, 5, 100, 30)];
    // configure the button here... you choose.
    [minusButton setTitle:@"-/+ sign" forState:UIControlStateNormal];
    [minusButton addTarget:self action:@selector(changeNumberSing) forControlEvents:UIControlEventTouchUpInside];
    [minusButton setBackgroundColor:[UIColor darkGrayColor]];
    minusButton.layer.cornerRadius = 5.0;;
    minusButton.layer.masksToBounds = YES;
    
    [inputAccesoryView addSubview:minusButton];
    [inputAccesoryView setBackgroundColor:[UIColor lightGrayColor]];
 
    self.qtyText.inputAccessoryView = inputAccesoryView;

    UIColor *buttonTintColour = [UIColor colorWithRed:0.0f/255.0f green:78.0f/255.0f blue:107.0f/255.0f alpha:1.0];
    
    UIImage *changecolourimage = [[UIImage imageNamed:@"lookup"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.searchPortButton setImage:changecolourimage forState:UIControlStateNormal];
    self.searchPortButton.tintColor = buttonTintColour;
    
}


-(void)doneButtonPressed {
    [self.qtyText resignFirstResponder];
    [self.estText resignFirstResponder];
    [self.PEXText resignFirstResponder];
    [self.noticeText resignFirstResponder];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews {
    [super layoutSubviews];
//    self.viewbackground.layer.cornerRadius = 5.0;;
//    self.viewbackground.layer.masksToBounds = YES;
//    self.viewbackground.layer.borderWidth = 1.0f; //make border 1px thick
//    self.viewbackground.layer.borderColor = [UIColor colorWithRed:43.0f/255.0f green:51.0f/255.0f blue:70.0f/255.0f alpha:1.0].CGColor;
    

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

- (IBAction)segTypeValueChanged:(id)sender {
    self.cargo.type_id = @(self.segType.selectedSegmentIndex);
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
    [self.noticeText resignFirstResponder];
}






-(void)changeNumberSing
{
    if ([self.qtyText.text hasPrefix:@"-"])
    {
        self.qtyText.text = [self.qtyText.text substringFromIndex:1];
    }else
    {
        self.qtyText.text = [NSString stringWithFormat:@"-%@",self.qtyText.text];
    }
}






@end
