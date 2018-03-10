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
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem.action = @selector(editButtonPressed);
    
}

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
        
        cargoCell *cell = [self.tableView cellForRowAtIndexPath:self.buttonPressedIndexPath];
        controller.existingitem = cell.cargo.port.name;
        
    }
 
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.c.cargoios count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/* created 20170909 */
/* modified 20170911 */
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    // NSLog(NSStringFromClass([self.c.cargoios class]));
    
    cargoNSO *movedCargo = [self.c.cargoios objectAtIndex:sourceIndexPath.row];
    [self.c.cargoios removeObjectAtIndex:sourceIndexPath.row];
    [self.c.cargoios insertObject:movedCargo atIndex:destinationIndexPath.row];
    /* reset id's so if calculation is saved the order is maintained */
    int counter = 1;
    for (cargoNSO *io in self.c.cargoios) {
        io.id = [NSNumber numberWithInt:counter];
        counter ++;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



/* created 20170910 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.c.cargoios removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData]; // tell table to refresh now
    }
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
 

/* modified 20160204 */
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
    cell.idLabel.text = [NSString stringWithFormat:@"%@", cargo.id];
    if ([cargo.purpose_code isEqualToString:@"L"]) {
        cell.ldSegment.selectedSegmentIndex=0;
    } else {
        cell.ldSegment.selectedSegmentIndex=1;
    }
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

/* modified 20170910 */
- (void)didPickPortItem :(NSString*)refport :(NSString*)searchitem {
    
    if ([searchitem isEqualToString:@"cargoport"]) {
        cargoCell *cell = [self.tableView cellForRowAtIndexPath:self.buttonPressedIndexPath];
        cargoNSO *cargo;
        cargo = [self.c.cargoios objectAtIndex:self.buttonPressedIndexPath.row];
        cargo.port = [self.db getPortByPortCode :refport :cargo.port];
        cell.portText.text = [cargo.port getPortFullName];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

/* add new cargo to array. 20170909 */
- (IBAction)newCargoPressed:(id)sender {
    // oddly the new object is not going into calling controller..
    
    NSMutableArray *io = [[NSMutableArray alloc] initWithArray:self.c.cargoios];
    cargoNSO *lastport = [io lastObject];
    
    cargoNSO *newport = [[cargoNSO alloc ] init];
    newport.id = [NSNumber numberWithInteger:self.c.cargoios.count + 1];
    newport.purpose_code = lastport.purpose_code;
    newport.type_id = lastport.type_id;
    newport.calc_id = lastport.calc_id;
    
    float unitlevel = 0.0f;
    
    for (cargoNSO *io in self.c.cargoios) {
        unitlevel += [io.units floatValue];
    }
    
    newport.units = [NSNumber numberWithFloat:unitlevel * -1];
    
    [io addObject:newport];
    self.c.cargoios = io;
    [self.tableView reloadData];
}


-(void)editButtonPressed {
    [self.tableView setEditing:![self.tableView isEditing] animated:YES];
}


@end
