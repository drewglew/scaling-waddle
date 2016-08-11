//
//  CargoInOutVC.m
//  RoastChicken
//
//  Created by andrew glew on 25/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "cargoVC.h"
#import "dbHelper.h"

@interface cargoVC () <searchDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end



@implementation cargoVC
@synthesize c;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

}
/*
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
*/

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES]; // This line is needed for the 'auto slide up'
    // Do other stuff
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    

    
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidDisappear:(BOOL)animated {
    NSLog(@"here is where we save the object");
    
     NSLog(@"%@",self.ports);
}



- (void)viewWillDisappear:(BOOL)animated {
    /*
     your code here
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [super viewWillDisappear:animated];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    //get the end position keyboard frame
    NSDictionary *keyInfo = [notification userInfo];
    CGRect keyboardFrame = [[keyInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    //convert it to the same view coords as the tableView it might be occluding
    keyboardFrame = [self.tableView convertRect:keyboardFrame fromView:nil];
    //calculate if the rects intersect
    CGRect intersect = CGRectIntersection(keyboardFrame, self.tableView.bounds);
    if (!CGRectIsNull(intersect)) {
        //yes they do - adjust the insets on tableview to handle it
        //first get the duration of the keyboard appearance animation
        NSTimeInterval duration = [[keyInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
        //change the table insets to match - animated to the same duration of the keyboard appearance
        [UIView animateWithDuration:duration animations:^{
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, intersect.size.height, 0);
            self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, intersect.size.height, 0);
        }];
    }
}

- (void) keyboardWillHide:  (NSNotification *) notification{
    NSDictionary *keyInfo = [notification userInfo];
    NSTimeInterval duration = [[keyInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    //clear the table insets - animated to the same duration of the keyboard disappearance
    [UIView animateWithDuration:duration animations:^{
        self.tableView.contentInset = UIEdgeInsetsZero;
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
 
    
    if([segue.identifier isEqualToString:@"portsearch"]){
        
        searchVC *controller = (searchVC *)segue.destinationViewController;
        controller.delegate = self;
        
        

        
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
        self.buttonPressedIndexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
       
        //TODO - should pass the dbHelper through the segues
        controller.searchItems = [self.db getPorts];
        controller.searchtype = @"cargoport";
        
        //controller.c = [sender c];
        
    }
 
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.c.cargoios count];
}



/* last modified 20160204 */

- (cargoCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cargoport";
    
    cargoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[cargoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cargoNSO *cargo = [self.c.cargoios objectAtIndex:indexPath.row];
    
    cell.portText.text = cargo.port.getPortFullName;
    cell.qtyText.text = [NSString stringWithFormat:@"%@",cargo.units];
    cell.segType.selectedSegmentIndex = [cargo.type_id intValue];
    cell.estText.text = [NSString stringWithFormat:@"%@",cargo.estimated];
    cell.PEXText.text = [NSString stringWithFormat:@"%@",cargo.expense];
    cell.noticeText.text = [NSString stringWithFormat:@"%@",cargo.notice_time];
    cell.ldLabel.text = cargo.purpose_code;
    cell.cargo = cargo;
   
    return cell;
    
    
}







- (IBAction)searchPortPressed:(id)sender {
    
    
    
}

- (IBAction)dismissKB:(id)sender {
    [sender resignFirstResponder];
}





- (void)didPickItem :(NSNumber*)ref :(NSString*)searchitem {

}




- (void)didPickPortItem :(NSString*)refport :(NSString*)searchitem {
    
    if ([searchitem isEqualToString:@"cargoport"]) {
        
        cargoCell *cell = [self.tableView cellForRowAtIndexPath:self.buttonPressedIndexPath];
        
        cargoNSO *cargo;
        if ([cell.ldLabel.text isEqualToString:@"L"]) {
             cargo = [self.c.cargoios firstObject];
        } else {
            cargo = [self.c.cargoios lastObject];
        }
        cargo.port = [self.db getPortByPortCode :refport :cargo.port];
        cell.portText.text = [cargo.port getPortFullName];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
