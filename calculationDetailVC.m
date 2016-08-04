//
//  calculationDetailVC.m
//  RoastChicken
//
//  Created by andrew glew on 21/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "calculationDetailVC.h"
#import "dbHelper.h"
#import "Reachability.h"
#import "cargoVC.h"

@interface calculationDetailVC () <searchDelegate, calcDetailDelegate, cargoIODelegate>
@property (weak, nonatomic) IBOutlet UITextField *textDesc;
@property (weak, nonatomic) IBOutlet UITextField *textVessel;
@property (weak, nonatomic) IBOutlet UITextField *textLDPort;
@property (strong, nonatomic) IBOutlet UITextField *textBallastFromPort;
@property (strong, nonatomic) IBOutlet UILabel *labelDistanceOutput;
@property (strong, nonatomic) IBOutlet UITextField *textHsfoPrice;
@property (strong, nonatomic) IBOutlet UITextField *textHsgoPrice;
@property (strong, nonatomic) IBOutlet UITextField *textLsgoPrice;
@property (strong, nonatomic) IBOutlet UITextField *textLsfoPrice;
@property (strong, nonatomic) IBOutlet UITextField *textBrokerCommission;
@property (strong, nonatomic) IBOutlet UITextField *textAddressCommission;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segRateType;
@property (strong, nonatomic) IBOutlet UILabel *labelMainRate;
@property (strong, nonatomic) IBOutlet UITextField *textMainRate;  // might be unit rate or WS rate
@property (strong, nonatomic) IBOutlet UISwitch *switchUseLocalFlatRate;
@property (strong, nonatomic) IBOutlet UITextField *textFlatRate;



typedef void(^connection)(BOOL);

@end

@implementation calculationDetailVC


@synthesize delegate;
@synthesize opencalcs;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(didSwipe:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
    

    self.currentpageindex = 1;
    [self loadData];

    self.calcBackgroundView.layer.cornerRadius = 5.0;;
    self.calcBackgroundView.layer.masksToBounds = YES;
    
    self.calcBackgroundView.layer.borderWidth = 1.0f; //make border 1px thick
    self.calcBackgroundView.layer.borderColor = [UIColor colorWithRed:43.0f/255.0f green:51.0f/255.0f blue:70.0f/255.0f alpha:1.0].CGColor;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    
    UIColor *buttonTintColour = [UIColor colorWithRed:222.0f/255.0f green:119.0f/255.0f blue:65.0f/255.0f alpha:1.0];
    
    UIImage *changecolourimage = [[UIImage imageNamed:@"rightarrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.expandLDButton setImage:changecolourimage forState:UIControlStateNormal];
    self.expandLDButton.tintColor = buttonTintColour;
    [self.expandAdditionalsButton setImage:changecolourimage forState:UIControlStateNormal];
    self.expandAdditionalsButton.tintColor = buttonTintColour;
    
    changecolourimage = [[UIImage imageNamed:@"lookup"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.searchVesselButton setImage:changecolourimage forState:UIControlStateNormal];
    self.searchVesselButton.tintColor = buttonTintColour;
    [self.searchBallastButton setImage:changecolourimage forState:UIControlStateNormal];
    self.searchBallastButton.tintColor = buttonTintColour;
    
    [self checkInternet];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)cloneCalcPressed:(id)sender {
    
    
    calculationNSO *clonecalc = [[calculationNSO alloc] init];
    clonecalc = [self.c copy];
    
    clonecalc.descr = [NSString stringWithFormat:@"<cloned> %@", self.c.descr];
    clonecalc.id = nil;
    clonecalc.statustext = @"unsaved clone";
    //[self.opencalcs addObject:clonecalc];
    [self.opencalcs insertObject:clonecalc atIndex:self.currentpageindex];
    self.currentpageindex ++;

    [self transitionNewCalc];
    NSLog(@"clone calculation generated");
}





- (IBAction)popCalculationPressed:(id)sender {
 //   [self.navigationController popViewControllerAnimated:YES];
    
}




- (IBAction)vesselSelectorPressed:(id)sender {

}


- (IBAction)newCalcPressed:(id)sender {
    // save the calclulation

    calculationNSO *newcalc = [[calculationNSO alloc] init];
    newcalc.descr = @"";
    newcalc.statustext = @"new unsaved";
    
    //[self.opencalcs addObject:newcalc];
    [self.opencalcs insertObject:newcalc atIndex:self.currentpageindex];
    
    self.currentpageindex ++;
    [self transitionNewCalc];
    
 //   success = [self.db insertCalculationData :self.c];
    NSLog(@"new calculation generated");
    
    
}

- (IBAction)disgardPressed:(id)sender {
    
    
}



/* created 20160722 */
/* modified 20160724 */
- (IBAction)keepCalculation:(id)sender {
    // save the calclulation
    self.c.descr = self.textDesc.text;
    NSNumber *existing = self.c.id;
    if (existing == nil) {
        // its a new calc that is not in the db
        self.c = [self.db insertCalculationData :self.c];
        [self.db prepareld :self.c];
        
    } else {
        self.c = [self.db updateCalculationData :self.c];
    }
    self.statusLabel.text=@"";
    // we can add perhaps the date here it was saved...
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"vesselsearch"]){
        
        searchVC *controller = (searchVC *)segue.destinationViewController;
        controller.delegate = self;
        
        
        //TODO - should pass the dbHelper through the segues
        controller.searchItems = [self.db getVessels];
        controller.searchtype = @"vessel";
        
        //controller.c = [sender c];
    
    } else if([segue.identifier isEqualToString:@"ballfromportsearch"]){
        
        searchVC *controller = (searchVC *)segue.destinationViewController;
        controller.delegate = self;
        
        
        //TODO - should pass the dbHelper through the segues
        controller.searchItems = [self.db getPorts];
        
        controller.searchtype = @"ballfromport";
        
    } else if([segue.identifier isEqualToString:@"toportsearch"]){
        
        searchVC *controller = (searchVC *)segue.destinationViewController;
        controller.delegate = self;
        
        
        //TODO - should pass the dbHelper through the segues
        controller.searchItems = [self.db getPorts];
        
        controller.searchtype = @"toport";
        
    } else if([segue.identifier isEqualToString:@"fromportsearch"]){
            
            searchVC *controller = (searchVC *)segue.destinationViewController;
            controller.delegate = self;
            
            
            //TODO - should pass the dbHelper through the segues
            controller.searchItems = [self.db getPorts];
            
            controller.searchtype = @"fromport";
            
            //controller.c = [sender c];
    } else if([segue.identifier isEqualToString:@"clonecalculation"]) {
        
        
        calculationDetailVC *controller = (calculationDetailVC *)segue.destinationViewController;
        controller.delegate = self;

        controller.c = self.c.copy;
        controller.c.descr = @"clone";
        controller.cloneid = [NSNumber numberWithInt:[self.cloneid intValue] + 1 ];
        
    } else if([segue.identifier isEqualToString:@"cargoes"]) {
        
        
        cargoVC *controller = (cargoVC *)segue.destinationViewController;
        controller.delegate = self;
        controller.ports = self.c.cargoios;
        controller.c = self.c.copy;
        controller.c.descr = @"clone";
        controller.db = self.db;
        
    }
    
    
    
    
}
- (IBAction)dismissKB:(id)sender {
    [sender resignFirstResponder];
}

- (void)didPickItem :(NSNumber*)ref :(NSString*)searchitem {

    if ([searchitem isEqualToString:@"vessel"]) {
        self.c.vessel = [self.db getVesselByVesselNr:ref :self.c.vessel];
        self.textVessel.text = [self.c.vessel getVesselFullName];
        
    }
    [self.navigationController popViewControllerAnimated:YES];

}




- (void)didPickPortItem :(NSString*)refport :(NSString*)searchitem {
    
   if ([searchitem isEqualToString:@"ballfromport"]) {
        self.c.port_ballast_from = [self.db getPortByPortCode :refport :self.c.port_ballast_from];
        self.textBallastFromPort.text = [self.c.port_ballast_from getPortFullName];
        
    }

    [self.navigationController popViewControllerAnimated:YES];
    
}

/* modified 20160724 */
/* can be optimized */

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    
    // TODO, bug in swipping.
    
    long calsccount = [self.opencalcs count];
    
    // next record
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Swipe Left");
        
         NSLog(@"Before %@", [NSString stringWithFormat:@"%lu:%lu",(unsigned long)[self.opencalcs count],(unsigned long)self.currentpageindex ]);
        if (self.currentpageindex < calsccount) {
            self.currentpageindex ++;
         

            CGRect initCalcViewFrame = self.calcBackgroundView.frame;
            
            CGRect movedcalcToLeftViewFrame = CGRectMake(initCalcViewFrame.origin.x - initCalcViewFrame.size.width, initCalcViewFrame.origin.y, initCalcViewFrame.size.width, initCalcViewFrame.size.height);
            
            CGRect movedcalcToRightViewFrame = CGRectMake(initCalcViewFrame.origin.x + initCalcViewFrame.size.width, initCalcViewFrame.origin.y, initCalcViewFrame.size.width, initCalcViewFrame.size.height);

            [UIView animateWithDuration:0.4
                             animations:^{self.calcBackgroundView.frame = movedcalcToLeftViewFrame;}
                             completion:^(BOOL finished)
            {
                [self loadData];
                
                self.calcBackgroundView.frame = movedcalcToRightViewFrame;
                
                [UIView animateWithDuration:0.2
                                 animations:^{self.calcBackgroundView.frame = initCalcViewFrame;}
                                 completion:nil];
            }];

        }
        NSLog(@"after %@", [NSString stringWithFormat:@"%lu:%lu",(unsigned long)[self.opencalcs count],(unsigned long)self.currentpageindex ]);
    
    // previous record
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Swipe Right");
         NSLog(@"Before %@", [NSString stringWithFormat:@"%lu:%lu",(unsigned long)[self.opencalcs count],(unsigned long)self.currentpageindex ]);
        if (self.currentpageindex > 1 ) {

            self.currentpageindex --;
            //to animate the view as new view is loaded
            CGRect initCalcViewFrame = self.calcBackgroundView.frame;
            
            CGRect movedcalcToLeftViewFrame = CGRectMake(initCalcViewFrame.origin.x - initCalcViewFrame.size.width, initCalcViewFrame.origin.y, initCalcViewFrame.size.width, initCalcViewFrame.size.height);
            
            CGRect movedcalcToRightViewFrame = CGRectMake(initCalcViewFrame.origin.x + initCalcViewFrame.size.width, initCalcViewFrame.origin.y, initCalcViewFrame.size.width, initCalcViewFrame.size.height);
            
            [UIView animateWithDuration:0.4
                             animations:^{self.calcBackgroundView.frame = movedcalcToRightViewFrame;}
                             completion:^(BOOL finished)
             {
                 [self loadData];
                 
                 self.calcBackgroundView.frame = movedcalcToLeftViewFrame;
                 
                 [UIView animateWithDuration:0.2
                                  animations:^{self.calcBackgroundView.frame = initCalcViewFrame;}
                                  completion:nil];
             }];
            
            
            
        }
     
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
    
        NSLog(@"Swipe Down");
        [self transitionnDiscardCalc];
    }
    NSLog(@"After %@", [NSString stringWithFormat:@"%lu:%lu",(unsigned long)[self.opencalcs count],(unsigned long)self.currentpageindex ]);

}


/* created 20160724 */
/* what do I do? - shift existing calculation view leftwards and then drop new calculation from above into position */
-(void) transitionNewCalc {
    
    //self.currentpageindex = [self.opencalcs count];
    
    /* move the original item left side to right odd the screen */
    CGRect initCalcViewFrame = self.calcBackgroundView.frame;
    
    CGRect movedcalcToLeftViewFrame = CGRectMake(initCalcViewFrame.origin.x - initCalcViewFrame.size.width, initCalcViewFrame.origin.y, initCalcViewFrame.size.width, initCalcViewFrame.size.height);
    
    CGRect movedcalcToTopViewFrame = CGRectMake(initCalcViewFrame.origin.x, initCalcViewFrame.origin.y - initCalcViewFrame.size.height, initCalcViewFrame.size.width, initCalcViewFrame.size.height);
    
    
    [UIView animateWithDuration:0.2
                     animations:^{self.calcBackgroundView.frame = movedcalcToLeftViewFrame;}
                     completion:^(BOOL finished)
     {
         /* now we load the view from the top position down */
         
         [self loadData];
         
         
         self.calcBackgroundView.frame = movedcalcToTopViewFrame;
         
         [UIView animateWithDuration:0.4
                          animations:^{self.calcBackgroundView.frame = initCalcViewFrame;}
                          completion:nil];
     }];
}

/* created 20160724 */
/* what do I do? called just on swipe, this method manages business logic when user discards a calculation from the active set what to do depending on page & number of calcs */
-(void) transitionnDiscardCalc {
    
    //self.currentpageindex = [self.opencalcs count];
    
        /* move the original item left side to right odd the screen */
        CGRect initCalcViewFrame = self.calcBackgroundView.frame;
        
        CGRect movedcalcToLeftViewFrame = CGRectMake(initCalcViewFrame.origin.x - initCalcViewFrame.size.width, initCalcViewFrame.origin.y, initCalcViewFrame.size.width, initCalcViewFrame.size.height);
        
        CGRect movedcalcToRightViewFrame = CGRectMake(initCalcViewFrame.origin.x + initCalcViewFrame.size.width, initCalcViewFrame.origin.y, initCalcViewFrame.size.width, initCalcViewFrame.size.height);
        
        CGRect movedcalcToBottomViewFrame = CGRectMake(initCalcViewFrame.origin.x, initCalcViewFrame.origin.y + initCalcViewFrame.size.height, initCalcViewFrame.size.width, initCalcViewFrame.size.height);
        
    
    
    NSUInteger calcsopenamount = self.opencalcs.count;
    [UIView animateWithDuration:0.2
                        animations:^{self.calcBackgroundView.frame = movedcalcToBottomViewFrame;}
                        completion:^(BOOL finished)
        {
        [self.opencalcs removeObjectAtIndex:self.currentpageindex-1];
            
        /* now we load the view from the top position down */
        if (self.currentpageindex==1 && calcsopenamount==1) {
            // the only calculation must be handled
            // TODO
            
            [self.navigationController popViewControllerAnimated:YES];
                 
                 
        } else if (self.currentpageindex==calcsopenamount) {
            // if the current page is the last we complete the transition by bringing in the view from the left side
                 
            self.currentpageindex--;
            [self loadData];
                 
            self.calcBackgroundView.frame = movedcalcToLeftViewFrame;
                 
            [UIView animateWithDuration:0.4
                                  animations:^{self.calcBackgroundView.frame = initCalcViewFrame;}
                                  completion:nil];
                 
        } else {
            // normal cirsumstance is we complete transition by bringing in the next view from the right.

            self.calcBackgroundView.frame = movedcalcToRightViewFrame;
            [self loadData];
                 
            [UIView animateWithDuration:0.4
                                  animations:^{self.calcBackgroundView.frame = initCalcViewFrame;}
                                  completion:nil];
        }
             
             
    }];
  
    
  }



-(void) loadData {
    self.c = [self.opencalcs objectAtIndex:self.currentpageindex-1];
    
    self.textDesc.text = self.c.descr;
    self.textVessel.text = [self.c.vessel getVesselFullName];
    self.c.ld_ports = [self.c getldportnames];
    self.textLDPort.text = self.c.ld_ports;
    self.textBallastFromPort.text = self.c.port_ballast_from.name;
    self.calcRefLabel.text = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)self.currentpageindex,(unsigned long)[self.opencalcs count]];
    self.textMainRate.text = [NSString stringWithFormat:@"%@",self.c.rate];
    
    self.textHsfoPrice.text = [NSString stringWithFormat:@"%@",self.c.result.hfo_bunker.price];
    self.textHsgoPrice.text = [NSString stringWithFormat:@"%@",self.c.result.do_bunker.price];
    self.textLsgoPrice.text = [NSString stringWithFormat:@"%@",self.c.result.mgo_bunker.price];
    self.textLsfoPrice.text = [NSString stringWithFormat:@"%@",self.c.result.lsfo_bunker.price];
    
    self.textAddressCommission.text = [NSString stringWithFormat:@"%@",self.c.result.address_commission_percent];
    
    self.textBrokerCommission.text = [NSString stringWithFormat:@"%@",self.c.result.broker_commission_percent];
    

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MMM-yy HH:mm"];
    NSString *dateLastModified=[dateFormat stringFromDate:self.c.lastmodified];
    if (self.c.lastmodified != nil) {
        self.c.statustext = dateLastModified;
    }
    self.statusLabel.text = self.c.statustext;
    
}

- (IBAction)calculatePressed:(id)sender {
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    self.c.rate = [f numberFromString:self.textMainRate.text];
    
    if (self.segRateType.selectedSegmentIndex==1 && self.c.rate!=[NSNumber numberWithFloat:0.0f])  {
        
        if (self.switchUseLocalFlatRate.selected) {
            
            if (self.c.flatrate==[NSNumber numberWithFloat:0.0f]) {
                
            } else {
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                // per MT - TODO validate this
                self.c.flatrate = [f numberFromString:self.textFlatRate.text];
            }
            
            
        } else {
            
            self.c.flatrate = [self.db getWorldScaleRate:[self.c getldportcombo]];
            
            if (self.c.flatrate==[NSNumber numberWithFloat:0.0f]) {
        
                UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle: @"WorldScale Rates"
                                    message: [NSString stringWithFormat:@"We do not have the worldscale rate for  port combination %@",[self.c getldportcombo]]
                                    preferredStyle:UIAlertControllerStyleAlert];
        
                UIAlertAction *ok = [UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action){
                                                       UITextField *alertTextField = alert.textFields.firstObject;
                                                       NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                                                       f.numberStyle = NSNumberFormatterDecimalStyle;
                                                       self.c.flatrate = [f numberFromString:alertTextField.text];
                                                      
                                                       if (self.c.flatrate == [NSNumber numberWithFloat:0.0f] || self.c.flatrate == nil) {
                                                           self.labelDistanceOutput.text = @"problem with worldscale rate!";
                                                       } else {
                                                           // we update the database and continue
                                                           self.textFlatRate.text = [NSString stringWithFormat:@"%@",self.c.flatrate];
                                                           
                                                           [self.db insertWorldScaleRate:[self.c getldportcombo] :self.c.rate];
                                                           [self processResultData];
                                                       }
                                                   }];
        
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                       handler: nil];
        
        
                [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            
                    textField.placeholder = @"Enter rate";
                    textField.keyboardType = UIKeyboardTypeDecimalPad;
            
                }];
        
                [alert addAction:ok];
                [alert addAction:cancel];
        
                [self presentViewController:alert animated:true completion:nil];
            } else {
            // we have the rate we just need to verify the rest.
            
                self.textFlatRate.text = [NSString stringWithFormat:@"%@",self.c.flatrate];
                [self processResultData];
            }
        }
        
    } else if (self.segRateType.selectedSegmentIndex==2 && self.c.rate!=[NSNumber numberWithFloat:0.0f])  {
        // Per MT
        [self processResultData];
    } else {
        
        self.labelDistanceOutput.text = @"empty rate amount!";
    }
    

}

/* modified 20160803 */
-(void)processResultData {
    if ([self checkInternet]) {
        cargoNSO *d_port = [self.c.cargoios lastObject];
        cargoNSO *l_port = [self.c.cargoios firstObject];
        
        if ([d_port.units floatValue] + [l_port.units floatValue]!=0.0f) {
             self.labelDistanceOutput.text = @"load/discharge mismatch!";
            
        } else {
            // we set the total units to the single load amount
            [self.c.result setTotal_units:l_port.units];
            
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *flatRate = [f numberFromString:self.textFlatRate.text];
            NSNumber *rateType = @(self.segRateType.selectedSegmentIndex);

            [self.c.result setRateData:self.c.rate :self.switchUseLocalFlatRate.selected :flatRate :rateType];
            
            [self.c.result setCommissionAmts];
            
            [self.c.result setAtPortMinutes :l_port];
            [self.c.result setAtPortMinutes :d_port];
            
            [self.c.result setRouteData:self.c.port_ballast_from :l_port.port :d_port.port :self.c];
            
            // TODO - additionals (where should they go??)
            
            // now we get the TC_EQV!
            
        }
        
    }
}


- (bool)checkInternet
{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        self.labelDistanceOutput.text = @"no internet";
        return false;
    }
    else
    {
        //connection available
        return true;
    }

}

- (IBAction)descrEditingEnded:(id)sender {
    self.c.descr = self.textDesc.text;
    
}

- (IBAction)hsfoPriceEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    self.c.result.hfo_bunker.price = [f numberFromString:self.textHsfoPrice.text];
    
}


- (IBAction)doPriceEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    self.c.result.do_bunker.price = [f numberFromString:self.textHsgoPrice.text];
}

- (IBAction)mgoPriceEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    self.c.result.mgo_bunker.price = [f numberFromString:self.textLsgoPrice.text];
}

- (IBAction)lsfoPriceEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    self.c.result.lsfo_bunker.price = [f numberFromString:self.textLsfoPrice.text];
}


- (IBAction)commissionEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    self.c.result.broker_commission_percent = [f numberFromString:self.textBrokerCommission.text];
    
}


- (IBAction)addressCommissionEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    self.c.result.address_commission_percent = [f numberFromString:self.textAddressCommission.text];
}


- (IBAction)segmentRateTypeChanged:(id)sender {
    
    if (self.segRateType.selectedSegmentIndex == 0) {
        self.switchUseLocalFlatRate.hidden = true;
        self.textFlatRate.hidden = true;
        self.labelMainRate.text = @"Unit Rate:";
        
    } else {
        self.switchUseLocalFlatRate.hidden = false;
        self.textFlatRate.hidden = false;
        self.labelMainRate.text = @"WS Rate:";
        
    }
}




@end
