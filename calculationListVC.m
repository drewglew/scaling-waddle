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
    
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.calculations = [self.db getCalculations];
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.calculations count];
}



/* last modified 20160204 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"calculationCell";
    
    CalcTVC *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CalcTVC alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    calculationNSO *c = [self.calculations objectAtIndex:indexPath.row];
    
    cell.descr.text = c.descr;
    cell.vesselfullname.text = [c.vessel getVesselFullName];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MMM-yyyy HH:mm"];
    NSString *dateLastModified=[dateFormat stringFromDate:c.lastmodified];
    cell.lastmodifiedlabel.text = [NSString stringWithFormat:@"%@",dateLastModified];
    cell.c = c;
    
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
                [self.selectedcalcs addObject:[self.calculations objectAtIndex:index]];
            }
            [self performSegueWithIdentifier:@"calculationwitharray" sender:sender];
            
        }
        [self.tableView setEditing:sender.selected animated:false];
        
    }
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Here the dataSource array is of dictionary objects
    calculationNSO *c = [self.calculations objectAtIndex:indexPath.row];
    
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       // [self.db deleteWholeMatchData:m.matchid];
        [self.calculations removeObjectAtIndex:indexPath.row];
        [self.db deleteCalculation: c.id];
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
    
    if([segue.identifier isEqualToString:@"calculation"]){
        calculationDetailVC *controller = (calculationDetailVC *)segue.destinationViewController;
        controller.delegate = self;
        controller.c = [sender c];
        //if ([self.selectedcalcs count]==0) [self.selectedcalcs addObject:[sender c]];
        [self.selectedcalcs addObject:[sender c]];
        controller.opencalcs = self.selectedcalcs;
        controller.db = self.db;
        
        
        //controller.cloneid = [NSNumber numberWithInt:0];
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
        
        
        controller.opencalcs = self.selectedcalcs;
        calculationNSO *c = [[calculationNSO alloc] init];
        controller.c = c;
        
    }
    
    
    
    
}


@end
