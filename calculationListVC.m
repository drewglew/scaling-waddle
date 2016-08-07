//
//  ViewController.m
//  RoastChicken
//
//  Created by andrew glew on 20/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "calculationListVC.h"


@interface calculationListVC () <calcDetailDelegate>

@end

@implementation calculationListVC
@synthesize db;
@synthesize calculations;

//@synthesize tableView;



/* created 20150909 */
-(void)initDB {
    /* most times the database is already existing */
    self.db = [[dbHelper alloc] init];
    [self.db dbCreate :@"mobilemt.db"];
  //  self.calculations = [self.db getCalculations];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[self.db dbCreate :@""];
    
    [self initDB];
    self.selectedcalcs = [[NSMutableArray alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
   // self.parentViewController.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.2 blue:0.5 alpha:0.7];
    [self setNeedsStatusBarAppearanceUpdate];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //self.calculations = [self.db getCalculations];
    self.listing = [self.db getListing];
    [self.tableView reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listing count];
}



/* last modified 20160204 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"calculationCell";
    
    calculationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[calculationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    listingItemNSO *l = [self.listing objectAtIndex:indexPath.row];
    
    cell.descr.text = l.descr;
    cell.vesselfullname.text = l.full_name_vessel;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MMM-yyyy HH:mm"];
    NSString *dateLastModified=[dateFormat stringFromDate:l.lastmodified];
    cell.lastmodifiedlabel.text = [NSString stringWithFormat:@"%@",dateLastModified];
    cell.ldportslabel.text = l.ld_ports;
    cell.l = l;
    cell.multipleSelectionBackgroundView.backgroundColor = [UIColor clearColor];
    
    return cell;
    
   
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //Here the dataSource array is of dictionary objects
   // match *m = [self.matches objectAtIndex:indexPath.row];
    
   // if (([m.Player1Number intValue]  == self.staticPlayer1Number && [m.Player2Number intValue] == self.staticPlayer2Number)) {
        // nothing to do here
   //     return NO;
    //} else {
        return YES;
    //}
}


- (IBAction)selectCalsPressed:(UIButton*)sender {
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    sender.selected =!sender.selected;
    
    if (sender.selected==true) {
        [self.tableView setEditing:sender.selected animated:true];
        
    } else {
        NSArray *rowsSelected = [self.tableView indexPathsForSelectedRows];
        BOOL selectedRows = rowsSelected.count > 0;
        
        if (selectedRows)
        {
            
            for (NSIndexPath *path in rowsSelected) {
                NSUInteger index = [path indexAtPosition:[path length] - 1];
                [self.selectedcalcs addObject:[self.listing objectAtIndex:index]];
            }
            [self performSegueWithIdentifier:@"calculationwitharray" sender:sender];
            
        }
        [self.tableView setEditing:sender.selected animated:false];
        
    }
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Here the dataSource array is of dictionary objects
    listingItemNSO *l = [self.listing objectAtIndex:indexPath.row];
    
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        [self.listing removeObjectAtIndex:indexPath.row];
        [self.db deleteCalculation: l.id];
        [tableView reloadData]; // tell table to refresh now
    }
}







- (void)addItemViewController:(calculationListVC *)controller keepDisplayState :(int)displayState {
    self.displayState = displayState;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return !self.tableView.isEditing;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    if([segue.identifier isEqualToString:@"calculation"]){
        calculationDetailVC *controller = (calculationDetailVC *)segue.destinationViewController;
        controller.delegate = self;
        [items addObject:[sender l]];
        
        controller.opencalcs = [self.db getCalculations :items];
        controller.c = [controller.opencalcs firstObject];
        controller.db = self.db;
        
    } else if([segue.identifier isEqualToString:@"newcalculation"]){
        calculationDetailVC *controller = (calculationDetailVC *)segue.destinationViewController;
        controller.delegate = self;
        calculationNSO *c = [[calculationNSO alloc] init];
        controller.c = c;
        [self.selectedcalcs addObject:c];
        controller.opencalcs = self.selectedcalcs;
        controller.db = self.db;
        
    } else if([segue.identifier isEqualToString:@"calculationwitharray"]){
        calculationDetailVC *controller = (calculationDetailVC *)segue.destinationViewController;
        controller.delegate = self;
        // controller.cloneid = [NSNumber numberWithInt:-1];
        controller.db = self.db;
        controller.opencalcs = [self.db getCalculations :self.selectedcalcs];
        controller.c = [controller.opencalcs firstObject];
        
    }
    
    
    
    
}


@end
