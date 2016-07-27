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
    // Do any additional setup after loading the view.

    
    
    
    
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

- (CargoInOutTVCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cargoport";
    
    CargoInOutTVCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CargoInOutTVCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cargoioNSO *cio = [self.c.cargoios objectAtIndex:indexPath.row];
    
    cell.portText.text = cio.port.getPortFullName;
    cell.qtyText.text = [NSString stringWithFormat:@"%@",cio.units];
    cell.typeText.text = [NSString stringWithFormat:@"%@",cio.type_id];
    cell.estText.text = [NSString stringWithFormat:@"%@",cio.estimated];
    cell.PEXText.text = [NSString stringWithFormat:@"%@",cio.expense];
    cell.termsText.text = [NSString stringWithFormat:@"%@",cio.terms_id];
    cell.noticeText.text = [NSString stringWithFormat:@"%@",cio.notice_time];
    cell.ldLabel.text = cio.purpose_code;
    cell.cio = cio;
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
        
        CargoInOutTVCell *cell = [self.tableView cellForRowAtIndexPath:self.buttonPressedIndexPath];
        
        cargoioNSO *cio;
        if ([cell.ldLabel.text isEqualToString:@"L"]) {
             cio = [self.c.cargoios firstObject];
        } else {
            cio = [self.c.cargoios lastObject];
        }
        cio.port = [self.db getPortByPortCode :refport :cio.port];
        cell.portText.text = [cio.port getPortFullName];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
