//
//  VesselPreviewTVC.m
//  RoastChicken
//
//  Created by andrew glew on 28/08/2017.
//  Copyright © 2017 andrew glew. All rights reserved.
//

#import "VesselPreviewTVC.h"

@interface VesselPreviewTVC ()

@end

@implementation VesselPreviewTVC
@synthesize vessel;
@synthesize loadport;
@synthesize posData;
@synthesize posSortedData;



- (void)viewDidLoad {
    [super viewDidLoad];
    self.posData = [[NSMutableArray alloc] init];
    
    //NSString *tempVessel = self.c.vessel.ref_nr;
    //api/v1/DataFeed/GetPosListByTypeWithVesselRef?ref_nr={ref_nr}&max_days_old={max_days_old}
    NSString *url = [NSString stringWithFormat:@"https://testapi.maersktankers.com/api/v1/DataFeed/GetPosListByTypeWithVesselRef?ref_nr=%@&max_days_old=30", self.vessel.ref_nr];
    
    [self fetchFromTankers:url withDictionary:^(NSDictionary *data) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
         for (NSDictionary *positem in data) {
            vesselPosNSO *pos = [[vesselPosNSO alloc] init];
            pos.vessel.ref_nr = [positem objectForKey:@"Ref_Nr"];
            pos.vessel.name = [positem objectForKey:@"Vessel_Name"];
             
            pos.port.code = [positem objectForKey:@"Port_Code_From"];
            pos.port.name = [positem objectForKey:@"Port_Name_From"];
            pos.port.abc_code = [positem objectForKey:@"Abc_Port_Code_From"];
             
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.atobviaconline.com/v1/Distance?port=%@&port=%@&api_key=%@", pos.port.abc_code, self.loadport.abc_code, appDelegate.apikey]]];
             
            [request setHTTPMethod:@"GET"];
             
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            [[session dataTaskWithRequest:request completionHandler:^(NSData *dataabc, NSURLResponse *response, NSError *error) {
                NSString *requestDistance = [[NSString alloc] initWithData:dataabc encoding:NSASCIIStringEncoding];
                NSLog(@"Request reply: %@", requestDistance);
                pos.distance = [NSNumber numberWithInt: [requestDistance floatValue]];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    [self.posData addObject:pos];
                    
                    if (self.posData.count==[data count]) {
                        self.posSortedData = [[NSArray arrayWithArray:self.posData] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                            NSNumber *first = [(vesselPosNSO*)a distance];
                            NSNumber *second = [(vesselPosNSO*)b distance];
                            
                            NSComparisonResult result =  [first compare:second];
                            return  result;
                        }];
                     [self.tableView reloadData];
                    }
                    
                });
            }] resume];
             
         }
        
    }];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[[self navigationController] setNavigationBarHidden:NO animated:YES];
    //UINavigationBar *bar = [self.navigationController navigationBar];
   // [bar setTintColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]];
    //[bar setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
   // self.posSortedData = [NSArray arrayWithArray:self.posData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* purpose is to call the remote webservice and load the reponse into a dictionary object */
-(void)fetchFromTankers:(NSString *)url withDictionary:(void (^)(NSDictionary* data))dictionary{
    
    NSMutableURLRequest *request = [NSMutableURLRequest  requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:@"CEEC5067A7BDD7D0DC5F75725DE93908814441A812B74DFCF751FFEC5150F594" forHTTPHeaderField:@"tankers-api-key"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data
                                                                                              options:0
                                                                                                error:NULL];
                                      dictionary(dicData);
                                  }];
    [task resume];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.posSortedData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    vesselCell *cell = [tableView dequeueReusableCellWithIdentifier:@"vesselCell" forIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"vesselCell";
    
    if (cell == nil) {
        cell = [[vesselCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    vesselPosNSO *pos;
    
    pos = [self.posSortedData objectAtIndex:indexPath.row];
    
    cell.vesselNameLabel.text = [NSString stringWithFormat:@"%@ - %@",pos.vessel.ref_nr, pos.vessel.name];
    cell.DistanceLabel.text = [NSString stringWithFormat:@"%@",pos.distance];
    cell.PortNameLabel.text = [NSString stringWithFormat:@"%@",pos.port.name];
    [cell layoutSubviews];
    
    return cell;
}





// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
