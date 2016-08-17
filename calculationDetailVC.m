//
//  calculationDetailVC.m
//  RoastChicken
//
//  Created by andrew glew on 21/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//


//TODO - cargo placeholders and new button on calc detail need to clear fuel prices, rates and commissions

#import "calculationDetailVC.h"
#import "dbHelper.h"
#import "Reachability.h"
#import "cargoVC.h"

@interface calculationDetailVC () <searchDelegate, UITextFieldDelegate, calcDetailDelegate, cargoIODelegate,UIScrollViewDelegate>

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
@property (strong, nonatomic) IBOutlet UITextField *textAddHsfoAmt;
@property (strong, nonatomic) IBOutlet UITextField *textAddHsgoAmt;
@property (strong, nonatomic) IBOutlet UITextField *textAddLsgoAmt;
@property (strong, nonatomic) IBOutlet UITextField *textAddLsfoAmt;
@property (strong, nonatomic) IBOutlet UITextField *textAddBallastedDays;
@property (strong, nonatomic) IBOutlet UITextField *textAddLadenDays;
@property (strong, nonatomic) IBOutlet UITextField *textAddIdleDays;
@property (strong, nonatomic) IBOutlet UITextField *textAddExpenses;
@property (strong, nonatomic) IBOutlet UISwitch *switchUseLocalFlatRate;
@property (strong, nonatomic) IBOutlet UITextField *textFlatRate;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *calcScrollView;
@property (strong, nonatomic) IBOutlet UITextField *textTCEPerDay;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *atobviacActivity;
@property (strong, nonatomic) IBOutlet UIImageView *mapImageView;
@property (strong, nonatomic) IBOutlet UIScrollView *mapScrollView;



typedef void(^connection)(BOOL);

@end

@implementation calculationDetailVC
UITextField *activeField;

@synthesize delegate;
@synthesize opencalcs;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.atobviacActivity.hidden=true;
    
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
    
   // self.calcBackgroundView.layer.borderWidth = 1.0f; //make border 1px thick
    self.calcBackgroundView.layer.borderColor = [UIColor colorWithRed:43.0f/255.0f green:51.0f/255.0f blue:70.0f/255.0f alpha:1.0].CGColor;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIColor *buttonTintColour = [UIColor colorWithRed:0.0f/255.0f green:78.0f/255.0f blue:107.0f/255.0f alpha:1.0];
    
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
    
    
    
    UIView *inputAccesoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    // It´s good idea a view under the button in order to change the color...more custom option
    //inputAccesoryView.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width) - 110, 5, 100, 30)];
    // configure the button here... you choose.
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setBackgroundColor:[UIColor colorWithRed:76.0f/255.0f green:188.0f/255.0f blue:208.0f/255.0f alpha:1.0]];
    
    
    doneButton.layer.cornerRadius = 5.0;;
    doneButton.layer.masksToBounds = YES;
    
    [inputAccesoryView addSubview:doneButton];
    [inputAccesoryView setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:78.0f/255.0f blue:107.0f/255.0f alpha:1.0]];
    
    self.textAddHsfoAmt.inputAccessoryView = inputAccesoryView;
    self.textFlatRate.inputAccessoryView = inputAccesoryView;
    self.textMainRate.inputAccessoryView = inputAccesoryView;
    self.textHsfoPrice.inputAccessoryView = inputAccesoryView;
    self.textHsgoPrice.inputAccessoryView = inputAccesoryView;
    self.textLsgoPrice.inputAccessoryView = inputAccesoryView;
    self.textLsfoPrice.inputAccessoryView = inputAccesoryView;
    self.textAddHsgoAmt.inputAccessoryView = inputAccesoryView;
    self.textAddHsfoAmt.inputAccessoryView = inputAccesoryView;
    self.textAddLsgoAmt.inputAccessoryView = inputAccesoryView;
    self.textAddLsfoAmt.inputAccessoryView = inputAccesoryView;
    self.textAddIdleDays.inputAccessoryView = inputAccesoryView;
    self.textAddBallastedDays.inputAccessoryView = inputAccesoryView;
    self.textAddLadenDays.inputAccessoryView = inputAccesoryView;
    self.textAddExpenses.inputAccessoryView = inputAccesoryView;
    self.textAddressCommission.inputAccessoryView = inputAccesoryView;
    self.textBrokerCommission.inputAccessoryView = inputAccesoryView;

    
    self.mapScrollView.minimumZoomScale=0.1f;
    self.mapScrollView.maximumZoomScale=5.0f;
    self.mapScrollView.contentSize=CGSizeMake(4096, 3072);
    self.mapScrollView.delegate=self;
    
    [self checkInternet];
}



-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mapScrollView.zoomScale=0.1f;
}




-(void)doneButtonPressed {
    [self.textAddHsfoAmt resignFirstResponder];
    [self.textBrokerCommission resignFirstResponder];
    [self.textAddressCommission resignFirstResponder];
    [self.textFlatRate resignFirstResponder];
    [self.textMainRate resignFirstResponder];
    [self.textHsfoPrice resignFirstResponder];
    [self.textHsgoPrice resignFirstResponder];
    [self.textLsgoPrice resignFirstResponder];
    [self.textLsfoPrice resignFirstResponder];
    [self.textAddHsgoAmt resignFirstResponder];
    [self.textAddHsfoAmt resignFirstResponder];
    [self.textAddLsgoAmt resignFirstResponder];
    [self.textAddLsfoAmt resignFirstResponder];
    [self.textAddIdleDays resignFirstResponder];
    [self.textAddBallastedDays resignFirstResponder];
    [self.textAddLadenDays resignFirstResponder];
    [self.textAddExpenses resignFirstResponder];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadData];
    
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
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
        self.c.created =  [NSDate date];
        self.c = [self.db insertCalculationData :self.c];
        [self.db prepareld :self.c];
        
    } else {
        self.c = [self.db updateCalculationData :self.c];
    }
    self.statusLabel.text= [self.c getNiceLastModifiedDate];
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

/* modified 20160806 */
-(void) loadData {
    self.c = [self.opencalcs objectAtIndex:self.currentpageindex-1];
    
    self.textDesc.text = self.c.descr;
    self.textVessel.text = [self.c.vessel getVesselFullName];
    
    cargoNSO *d_port = [self.c.cargoios lastObject];
    cargoNSO *l_port = [self.c.cargoios firstObject];
    
    NSString *voyagestring;
    NSString *apikey;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    apikey = appDelegate.apikey;
    
    
    if (self.c.port_ballast_from !=nil) {
        voyagestring = [NSString stringWithFormat:@"Voyage?port=%@&port=%@&port=%@", self.c.port_ballast_from.abc_code, l_port.port.abc_code, d_port.port.abc_code];
    } else {
        voyagestring = [NSString stringWithFormat:@"Voyage?port=%@&port=%@&port=%@", l_port.port.abc_code, l_port.port.abc_code, d_port.port.abc_code];
    }
    
    
    if (![[self.c.result voyagestring] isEqualToString:voyagestring] && ![d_port.port.code isEqualToString:@""]  && ![l_port.port.code isEqualToString:@""]) {
        
        self.atobviacActivity.hidden=false;
        [self.atobviacActivity startAnimating];
        self.calculateButton.enabled = false;
        
        self.labelDistanceOutput.text = @"requesting distance";
        
        self.c.result.voyagestring = voyagestring;
        
        if ([self checkInternet]) {
            [self.c.result setRouteData :voyagestring :self.c :self.labelDistanceOutput :self.atobviacActivity :self.calculateButton];
        } else {
            self.labelDistanceOutput.text = @"no internet!";
            self.atobviacActivity.hidden=true;
            [self.atobviacActivity stopAnimating];
        }
    }
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setMinimumFractionDigits:2];
    self.textTCEPerDay.text = [formatter stringFromNumber:self.c.result.net_day];
    
    self.c.ld_ports = [self.c getldportnames];
    
    self.textLDPort.text = self.c.ld_ports;
    self.textBallastFromPort.text = self.c.port_ballast_from.name;
    self.calcRefLabel.text = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)self.currentpageindex,(unsigned long)[self.opencalcs count]];
    if ([self.c.rate floatValue]>0.0f) {
        self.textMainRate.text = [NSString stringWithFormat:@"%@",self.c.rate];
    } else {
        self.textMainRate.text = nil;
    }
    
    if ([self.c.flatrate floatValue]>0.0f) {
        self.textFlatRate.text = [NSString stringWithFormat:@"%@",self.c.flatrate];
    } else {
        self.textFlatRate.text = nil;
    }
    if ([self.c.result.hfo_bunker.price floatValue]>0.0f) {
        self.textHsfoPrice.text = [NSString stringWithFormat:@"%@",self.c.result.hfo_bunker.price];
    } else {
        self.textHsfoPrice.text = nil;
    }
    if ([self.c.result.do_bunker.price floatValue]>0.0f) {
         self.textHsgoPrice.text = [NSString stringWithFormat:@"%@",self.c.result.do_bunker.price];
    } else {
        self.textHsgoPrice.text = nil;
    }
    if ([self.c.result.mgo_bunker.price floatValue]>0.0f) {
        self.textLsgoPrice.text = [NSString stringWithFormat:@"%@",self.c.result.mgo_bunker.price];
    } else {
        self.textLsgoPrice.text = nil;
    }
    
    if ([self.c.result.lsfo_bunker.price floatValue]>0.0f) {
        self.textLsfoPrice.text = [NSString stringWithFormat:@"%@",self.c.result.lsfo_bunker.price];
    } else {
        self.textLsfoPrice.text = nil;
    }
    
    self.textAddHsfoAmt.text = [NSString stringWithFormat:@"%@",self.c.result.hfo_bunker.additionals];
    self.textAddHsgoAmt.text = [NSString stringWithFormat:@"%@",self.c.result.do_bunker.additionals];
    self.textAddLsgoAmt.text = [NSString stringWithFormat:@"%@",self.c.result.mgo_bunker.additionals];
    self.textAddLsfoAmt.text = [NSString stringWithFormat:@"%@",self.c.result.lsfo_bunker.additionals];
    
    if ([self.c.add_idle_days intValue]>0) {
        self.textAddIdleDays.text = [NSString stringWithFormat:@"%@",self.c.add_idle_days];
    } else {
        self.textAddIdleDays.text = nil;
    }
    if ([self.c.add_ballasted_days intValue]>0) {
        self.textAddBallastedDays.text = [NSString stringWithFormat:@"%@",self.c.add_ballasted_days];
    } else {
        self.textAddBallastedDays.text = nil;
    }
    if ([self.c.add_laden_days intValue]>0) {
        self.textAddLadenDays.text = [NSString stringWithFormat:@"%@",self.c.add_laden_days];
    } else {
        self.textAddLadenDays.text = nil;
    }
    
    if ([self.c.add_expenses floatValue]>0.0f) {
        self.textAddExpenses.text = [NSString stringWithFormat:@"%@",self.c.add_expenses];
    } else {
        self.textAddExpenses.text = nil;
    }
    
    if ([self.c.result.address_commission_percent floatValue]>0.0f) {
        self.textAddressCommission.text = [NSString stringWithFormat:@"%@",self.c.result.address_commission_percent];
    } else {
        self.textAddressCommission.text = nil;
    }
    
    if ([self.c.result.broker_commission_percent floatValue]>0.0f) {
        self.textBrokerCommission.text = [NSString stringWithFormat:@"%@",self.c.result.broker_commission_percent];
    } else {
        self.textBrokerCommission.text = nil;
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MMM-yy HH:mm"];
    NSString *dateLastModified=[dateFormat stringFromDate:self.c.lastmodified];
    if (self.c.lastmodified != nil) {
        self.c.statustext = dateLastModified;
    }
    self.statusLabel.text = self.c.statustext;
    if (self.c.flatrate==nil || [self.c.flatrate isEqual:@0]) {
        self.segRateType.selectedSegmentIndex=0;
        self.labelMainRate.text = @"Unit Rate:";
        self.switchUseLocalFlatRate.hidden = true;
        self.textFlatRate.hidden = true;
    } else {
        self.segRateType.selectedSegmentIndex=1;
        self.labelMainRate.text = @"WS Rate:";
        self.switchUseLocalFlatRate.hidden = false;
        self.textFlatRate.hidden = false;
    }
    
    if (self.c.result.mapImage==nil) {
        [self.mapImageView setImage:[UIImage imageNamed:@""]];
    } else {
        [self.mapImageView setImage:self.c.result.mapImage];
    }
    

}



- (IBAction)calculatePressed:(id)sender {
    [self calculate];
}





/* modified 20160803 */
-(void)calculate  {
    
    cargoNSO *d_port = [self.c.cargoios lastObject];
    cargoNSO *l_port = [self.c.cargoios firstObject];
    
    self.labelDistanceOutput.text = @"working...";
    
    if ([d_port.units floatValue] + [l_port.units floatValue]!=0.0f) {
        self.labelDistanceOutput.text = @"load/discharge mismatch!";
        
    } else {

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
                    self.c.rate = [f numberFromString:self.textFlatRate.text];
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
                                                                       
                                                                       [self.db insertWorldScaleRate:[self.c getldportcombo] :self.c.flatrate];
                                                                       [self updateResultsData :l_port :d_port];

                                                                       
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
                    [self updateResultsData :l_port :d_port];

                    self.textFlatRate.text = [NSString stringWithFormat:@"%@",self.c.flatrate];
                }
            }
            
        } else if (self.segRateType.selectedSegmentIndex==0 && self.c.rate!=[NSNumber numberWithFloat:0.0f])  {
            // Per MT
            [self updateResultsData :l_port :d_port];
            
        } else {
            self.labelDistanceOutput.text = @"empty rate amount!";
            
        }
        

    }
 
}



-(void) updateResultsData :(cargoNSO *) l_port :(cargoNSO *) d_port {
    
    [self.c.result setSailingData :self.c];
    // we set the total units to the single load amount
    [self.c.result setTotal_units:l_port.units];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *flatRate = [f numberFromString:self.textFlatRate.text];
    NSNumber *rateType = @(self.segRateType.selectedSegmentIndex);
    
    self.c.result.address_commission_percent = [f numberFromString:self.textAddressCommission.text];
    self.c.result.broker_commission_percent = [f numberFromString:self.textBrokerCommission.text];

    [self.c.result setRateData:self.c.rate :self.switchUseLocalFlatRate.selected :flatRate :rateType];
        
    [self.c.result setCommissionAmts];
    
    self.c.result.minutes_notice_time = [NSNumber numberWithInt:0];
    [self.c.result setAtPortMinutes :l_port];
    [self.c.result setAtPortMinutes :d_port];
    
    [self.c.result setAtPortData :self.c];
    
    [self.c.result setTotal_expenses:[NSNumber numberWithInt:[l_port.expense intValue] + [d_port.expense intValue]]];
    
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!

    [formatter setMaximumFractionDigits:2];
    [formatter setMinimumFractionDigits:2];
    self.textTCEPerDay.text = [formatter stringFromNumber:[self.c.result getTcEqv]];
    self.labelDistanceOutput.text = @"";
    
    /*
    NSLog(@"gross freight:%@",self.c.result.gross_freight);
    NSLog(@"bunker HFO expesnes:%@",self.c.result.hfo_bunker.getExpenses);
    NSLog(@"bunker HFO price:%@",self.c.result.hfo_bunker.price);
    NSLog(@"bunker HFO additonal:%@",self.c.result.hfo_bunker.additionals);
    NSLog(@"bunker HFO units:%@",self.c.result.hfo_bunker.units);
    */
    
    
    
    
}





- (bool)checkInternet
{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        
        return false;
    }
    else
    {
        //connection available
        return true;
    }

}




- (IBAction)descEditingStarted:(id)sender {
    UITextField *txtDesc = ((UITextField *)sender);
    activeField = txtDesc;
    
    
}

- (IBAction)descrEditingEnded:(id)sender {
    self.c.descr = self.textDesc.text;
    activeField = nil;

}

/* modified 20160815 */
- (IBAction)hsfoPriceEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    if (self.textHsfoPrice.text && self.textHsfoPrice.text.length>0 ) {
        self.c.result.hfo_bunker.price = [f numberFromString:self.textHsfoPrice.text];
    } else {
        self.c.result.hfo_bunker.price = [NSNumber numberWithFloat:0.0f];
    }
    self.textHsfoPrice.text = [NSString stringWithFormat:@"%@", self.c.result.hfo_bunker.price];
}

/* modified 20160815 */
- (IBAction)doPriceEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    if (self.textHsgoPrice.text && self.textHsgoPrice.text.length>0 ) {
        self.c.result.do_bunker.price = [f numberFromString:self.textHsgoPrice.text];
    } else {
        self.c.result.do_bunker.price = [NSNumber numberWithFloat:0.0f];
    }
    self.textHsgoPrice.text = [NSString stringWithFormat:@"%@", self.c.result.do_bunker.price];
}

/* modified 20160815 */
- (IBAction)mgoPriceEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    if (self.textLsgoPrice.text && self.textLsgoPrice.text.length>0 ) {
        self.c.result.mgo_bunker.price = [f numberFromString:self.textLsgoPrice.text];
    } else {
        self.c.result.mgo_bunker.price = [NSNumber numberWithFloat:0.0f];
    }
    self.textLsgoPrice.text = [NSString stringWithFormat:@"%@", self.c.result.mgo_bunker.price];
}

/* modified 20160815 */
- (IBAction)lsfoPriceEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    if (self.textLsfoPrice.text && self.textLsfoPrice.text.length>0 ) {
        self.c.result.lsfo_bunker.price = [f numberFromString:self.textLsfoPrice.text];
    } else {
        self.c.result.lsfo_bunker.price = [NSNumber numberWithFloat:0.0f];
    }
    self.textLsfoPrice.text = [NSString stringWithFormat:@"%@", self.c.result.lsfo_bunker.price];
}

/* modified 20160815 */
- (IBAction)commissionEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    if (self.textBrokerCommission.text && self.textBrokerCommission.text.length>0 ) {
        self.c.result.broker_commission_percent = [f numberFromString:self.textBrokerCommission.text];
    } else {
        self.c.result.broker_commission_percent = [NSNumber numberWithFloat:0.0f];
    }
    self.textBrokerCommission.text = [NSString stringWithFormat:@"%@",  self.c.result.broker_commission_percent];
}

/* modified 20160815 */
- (IBAction)addressCommissionEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    if (self.textAddressCommission.text && self.textAddressCommission.text.length>0 ) {
        self.c.result.address_commission_percent = [f numberFromString:self.textAddressCommission.text];
    } else {
        self.c.result.address_commission_percent = [NSNumber numberWithFloat:0.0f];
    }
    self.textAddressCommission.text = [NSString stringWithFormat:@"%@",  self.c.result.address_commission_percent];
}

/* modified 20160815 */
- (IBAction)mainRateEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    if (self.textMainRate.text && self.textMainRate.text.length>0 ) {
        self.c.rate = [f numberFromString:self.textMainRate.text];
    } else {
        self.c.rate = [NSNumber numberWithFloat:0.0f];
    }
    self.textMainRate.text = [NSString stringWithFormat:@"%@", self.c.rate];
}

/* modified 20160815 */
- (IBAction)flatRateEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    if (self.textFlatRate.text && self.textFlatRate.text.length>0 ) {
        self.c.flatrate = [f numberFromString:self.textFlatRate.text];
    } else {
        self.c.flatrate = [NSNumber numberWithFloat:0.0f];
    }
    self.textFlatRate.text = [NSString stringWithFormat:@"%@", self.c.flatrate];
}

/* modified 20160815 */
- (IBAction)addHSFOEditingEnded:(id)sender {

    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    if (self.textAddHsfoAmt.text && self.textAddHsfoAmt.text.length>0 ) {
        self.c.result.hfo_bunker.additionals = [f numberFromString:self.textAddHsfoAmt.text];
    } else {
        self.c.result.hfo_bunker.additionals = [NSNumber numberWithFloat:0.0f];
    }
    self.textAddHsfoAmt.text = [NSString stringWithFormat:@"%@", self.c.result.hfo_bunker.additionals];
    activeField = nil;
}
- (IBAction)addHSFOEditingStarted:(id)sender {

}

/* modified 20160815 */
- (IBAction)addHSGOEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    if (self.textAddHsfoAmt.text && self.textAddHsfoAmt.text.length>0 ) {
        self.c.result.do_bunker.additionals = [f numberFromString:self.textAddHsfoAmt.text];
    } else {
        self.c.result.do_bunker.additionals = [NSNumber numberWithFloat:0.0f];
    }
    self.textAddHsfoAmt.text = [NSString stringWithFormat:@"%@", self.c.result.do_bunker.additionals];
}

/* modified 20160815 */
- (IBAction)addLSGOEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    if (self.textAddLsgoAmt.text && self.textAddLsgoAmt.text.length>0 ) {
        self.c.result.mgo_bunker.additionals = [f numberFromString:self.textAddLsgoAmt.text];
    } else {
        self.c.result.mgo_bunker.additionals = [NSNumber numberWithFloat:0.0f];
    }
    self.textAddLsgoAmt.text = [NSString stringWithFormat:@"%@", self.c.result.mgo_bunker.additionals];
}

/* modified 20160815 */
- (IBAction)addLSFOEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    if (self.textAddLsfoAmt.text && self.textAddLsfoAmt.text.length>0 ) {
        self.c.result.lsfo_bunker.additionals = [f numberFromString:self.textAddLsgoAmt.text];
    } else {
        self.c.result.lsfo_bunker.additionals = [NSNumber numberWithFloat:0.0f];
    }
    self.textAddLsfoAmt.text = [NSString stringWithFormat:@"%@", self.c.result.lsfo_bunker.additionals];
}

/* modified 20160815 */
- (IBAction)addBallastedEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    if (self.textAddBallastedDays.text && self.textAddBallastedDays.text.length>0 ) {
        NSInteger minutes = [self.textAddBallastedDays.text integerValue] * 1440;
        self.c.result.additonal_minutes_sailing_ballasted = [NSNumber numberWithLong:minutes];
    } else {
        self.c.result.additonal_minutes_sailing_ballasted = 0;
    }
    self.textAddBallastedDays.text = [NSString stringWithFormat:@"%@", self.c.result.additonal_minutes_sailing_ballasted];
}

/* modified 20160815 */
- (IBAction)addLadenDaysEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    if (self.textAddLadenDays.text && self.textAddLadenDays.text.length>0 ) {
        NSInteger minutes = [self.textAddLadenDays.text integerValue] * 1440;
        self.c.result.additonal_minutes_sailing_laden = [NSNumber numberWithLong:minutes];
    } else {
        self.c.result.additonal_minutes_sailing_laden = 0;
    }
    self.textAddLadenDays.text = [NSString stringWithFormat:@"%@", self.c.result.additonal_minutes_sailing_laden];
}

/* modified 20160815 */
- (IBAction)addIdleDaysEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    if (self.textAddIdleDays.text && self.textAddIdleDays.text.length>0 ) {
        NSInteger minutes = [self.textAddIdleDays.text integerValue] * 1440;
        self.c.result.additonal_minutes_sailing_idle = [NSNumber numberWithLong:minutes];
    } else {
        self.c.result.additonal_minutes_sailing_idle = 0;
    }
    self.textAddIdleDays.text = [NSString stringWithFormat:@"%@", self.c.result.additonal_minutes_sailing_idle];
}

/* modified 20160815 */
- (IBAction)addExpensesEditingEnded:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    if (self.textAddExpenses.text && self.textAddExpenses.text.length>0 ) {
        self.c.result.additonal_expense_amt = [f numberFromString:self.textAddExpenses.text];
    } else {
        self.c.result.additonal_expense_amt = [NSNumber numberWithFloat:0.0f];
    }
    self.textAddExpenses.text = [NSString stringWithFormat:@"%@", self.c.result.additonal_expense_amt];

}



- (IBAction)textFieldDidBeginEdit:(id) sender {
    

    UITextField *txtFld = ((UITextField *)sender);
     NSLog(@"%@",txtFld.text);
    [txtFld selectAll:self];

}



- (IBAction)segmentRateTypeChanged:(id)sender {
    
    if (self.segRateType.selectedSegmentIndex == 0) {
        self.c.flatrate = [NSNumber numberWithFloat:0.0f];
        self.switchUseLocalFlatRate.hidden = true;
        self.textFlatRate.hidden = true;
        self.labelMainRate.text = @"Unit Rate:";
        
    } else {
        self.switchUseLocalFlatRate.hidden = false;
        self.textFlatRate.hidden = false;
        self.labelMainRate.text = @"WS Rate:";
        
    }
}

/* created 20160816 */
/* todo - optimize the calls by using its own imagestring like voyagestring; also pan and zoom would be nice! */
- (IBAction)getMap:(id)sender {
    
    cargoNSO *d_port = [self.c.cargoios lastObject];
    cargoNSO *l_port = [self.c.cargoios firstObject];
    
    NSString *voyagestring;
    NSString *apikey;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    apikey = appDelegate.apikey;
    
    
    if (self.c.port_ballast_from !=nil) {
        voyagestring = [NSString stringWithFormat:@"Image?port=%@&port=%@&port=%@&width=4096&height=3072&showSecaZones=false&antipiracy=true&envnavreg=true", self.c.port_ballast_from.abc_code, l_port.port.abc_code, d_port.port.abc_code];
    } else {
        voyagestring = [NSString stringWithFormat:@"Image?port=%@&port=%@&port=%@&width=4096&height=3072&showSecaZones=false&antipiracy=true&envnavreg=true", l_port.port.abc_code, l_port.port.abc_code, d_port.port.abc_code];
    }
    
    self.atobviacActivity.hidden=false;
    [self.atobviacActivity startAnimating];
    self.calculateButton.enabled = false;
        
    self.labelDistanceOutput.text = @"requesting map";
        
    self.c.result.voyagestring = voyagestring;
        
    if ([self checkInternet]) {
        [self.c.result setMapData :voyagestring :self.c :self.labelDistanceOutput :self.atobviacActivity :self.calculateButton :self.mapImageView];
    } else {
        self.labelDistanceOutput.text = @"no internet!";
        self.atobviacActivity.hidden=true;
        [self.atobviacActivity stopAnimating];
    }
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.mapImageView;
}




@end
