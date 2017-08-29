//
//  routedetailVC.m
//  RoastChicken
//
//  Created by andrew glew on 17/08/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "routedetailVC.h"

@interface routedetailVC ()

@end

@implementation routedetailVC
@synthesize routing;
@synthesize mapImage;
@synthesize listing;

/* last modified 20160818 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self restrictRotation:NO];
    if (self.mapImage==nil) {
        [self.mapImageView setImage:[UIImage imageNamed:@""]];
    } else {
        [self.mapImageView setImage:self.mapImage];
    }
    self.mapScrollView.minimumZoomScale=0.1f;
    self.mapScrollView.maximumZoomScale=10.0f;
    self.mapScrollView.contentSize=CGSizeMake(4096, 3072);
    self.mapScrollView.delegate=self;
    
    [self buildRouteListing];

    [self.routingTableView reloadData];
}

-(void) restrictRotation:(BOOL) restriction
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mapScrollView.zoomScale=0.2f;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self restrictRotation:YES];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.mapImageView;
}


/* created 20160818 */
/* a complex method to read the JSON generated dictionary and locate the names and distances of ports.  Also we must manually find the names of the ports that were passed as codes. */
-(void)buildRouteListing {
    
    self.listing = [[NSMutableArray alloc] init];
    
    [self.routing enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stopRouting) {
        
        routeNSO *fromPort = [[routeNSO alloc] init];
        routeNSO *toPort = [[routeNSO alloc] init];
        
        NSString *lastPortName;
        
        if ([key isEqualToString:@"TotalDistance"]) {
            self.total_distance = value;
        } else if ([key isEqualToString:@"Legs"]) {
            NSArray *LegArray = [[NSArray alloc] initWithObjects:value,nil];
            int legIndex = 0;
            NSNumber *distanceToLoadPort = [NSNumber numberWithFloat:0.0f];
            for (id Legs in LegArray) {
                
                for (NSDictionary *leg in Legs) {
                    for(id key in leg) {
                        
                        if ([key isEqual:@"FromPort"]) {
                            NSDictionary *fromP = [leg objectForKey:key];
                            if (legIndex==0) {
                                fromPort.purposeofport = @"B";
                            }
                            fromPort.nameofport = [fromP valueForKey:@"Name"];
                            fromPort.codeofport = [fromP valueForKey:@"Code"];
                        } else if ([key isEqual:@"ToPort"]) {
                            NSDictionary *toP = [leg objectForKey:key];
                            if (legIndex==1) {
                                toPort.purposeofport = @"D";
                            }
                            toPort.nameofport = [toP valueForKey:@"Name"];
                            toPort.codeofport = [toP valueForKey:@"Code"];
                        } else if ([key isEqual:@"Waypoints"]) {
                            bool firstWayPoint = true;
                            NSArray *WayPoints = [[NSArray alloc] initWithArray:[leg valueForKey:key]];
                            for (NSDictionary *waypoint in WayPoints) {
                                routeNSO *r = [[routeNSO alloc] init];
                                for(id keyWP in waypoint) {
                                    if ([keyWP isEqual:@"Name"]) {
                                        r.nameofport = [waypoint valueForKey:keyWP];
                                        if (firstWayPoint==YES) {
                                            r.nameofport = fromPort.nameofport;
                                            if (legIndex==0) {
                                                r.purposeofport = fromPort.purposeofport;
                                            }
                                            firstWayPoint = NO;
                                        } else if ([r.nameofport isEqualToString:fromPort.codeofport]  || [r.nameofport isEqualToString:fromPort.nameofport]) {
                                        } else if ([r.nameofport isEqualToString:toPort.codeofport] || [r.nameofport isEqualToString:toPort.nameofport]) {
                                            r.nameofport = toPort.nameofport;
                                            
                                            if (legIndex==1) {
                                                r.purposeofport = toPort.purposeofport;
                                            }
                                            
                                        }
                                    } else if ([keyWP isEqual:@"DistanceFromStart"]) {
                                        
                                        r.distanceFromStart = [waypoint valueForKey:keyWP];
                                        if ([distanceToLoadPort floatValue]!=0.0f) {
                                            r.distanceFromStart = [NSNumber numberWithFloat:[r.distanceFromStart floatValue] + [distanceToLoadPort floatValue]];
                                        }
                                    }
                                }
                                
                                if (![r.nameofport isEqualToString:lastPortName] ) {
                                    [self.listing addObject:r];
                                } else {
                                    routeNSO *prevPort = [[routeNSO alloc] init];
                                    prevPort = [self.listing lastObject];
                                    distanceToLoadPort = prevPort.distanceFromStart;
                                    r.distanceFromStart = distanceToLoadPort;
                                    r.purposeofport = @"L";
                                    [self.listing removeObjectAtIndex:self.listing.count-1];
                                    [self.listing addObject:r];
                                }
                                lastPortName = r.nameofport;
                            }
                        }
                    }
                    legIndex++;
                }
            }
        }
    }];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listing.count;
}



/* last modified 20160204 */

- (routeCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"routeCell";
    
    routeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[routeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    routeNSO *r;
    r = [self.listing objectAtIndex:indexPath.row];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    f.maximumFractionDigits = 2;
    f.roundingMode = NSNumberFormatterRoundHalfUp;
    
    cell.DistanceLabel.text = [NSString stringWithFormat:@"%@",[f stringFromNumber:r.distanceFromStart]];
    cell.portnameLabel.text = r.nameofport;
    cell.indicatorLabel.text = r.purposeofport;
    
    if (r.purposeofport == nil) {
        [cell.indicatorLabel setHidden:YES];
    } else {
        [cell.indicatorLabel setHidden:NO];
    }
    return cell;
}





@end
