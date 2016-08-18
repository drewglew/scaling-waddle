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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    if (self.mapImage==nil) {
        [self.mapImageView setImage:[UIImage imageNamed:@""]];
    } else {
        [self.mapImageView setImage:self.mapImage];
    }
    self.mapScrollView.minimumZoomScale=0.1f;
    self.mapScrollView.maximumZoomScale=10.0f;
    self.mapScrollView.contentSize=CGSizeMake(4096, 3072);
    self.mapScrollView.delegate=self;
    self.listing = [[NSMutableArray alloc] init];

    [self.routing enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stopRouting) {
        
        if ([key isEqualToString:@"Legs"]) {
            NSArray *LegArray = [[NSArray alloc] initWithObjects:value,nil];
            for (id Legs in LegArray) {
                for (NSDictionary *leg in Legs) {
                    for(id key in leg) {
                        if ([key isEqual:@"Waypoints"]) {
                            NSArray *WayPoints = [[NSArray alloc] initWithArray:[leg valueForKey:key]];
                            for (NSDictionary *waypoint in WayPoints) {
                                routeNSO *r = [[routeNSO alloc] init];
                                for(id keyWP in waypoint) {
                                    if ([keyWP isEqual:@"Name"]) {
                                       // NSLog(@"Name=%@",[waypoint valueForKey:keyWP]);
                                        r.nameofport = [waypoint valueForKey:keyWP];
                                    } else if ([keyWP isEqual:@"DistanceFromStart"]) {
                                        NSLog(@"DistanceFromStart=%@",[waypoint valueForKey:keyWP]);
                                        r.distanceFromStart = [waypoint valueForKey:keyWP];
                                    }
                                }
                                [self.listing addObject:r];
                                // add to array
                            }
                        }
                    }
                }
            }
        }
    }];
    
   // NSLog(@"%@",wayPoints );
    [self.routingTableView reloadData];
}





-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mapScrollView.zoomScale=0.2f;
    
   
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.mapImageView;
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
    
    
    cell.DistanceLabel.text = [NSString stringWithFormat:@"%@",r.distanceFromStart];
    cell.portnameLabel.text = r.nameofport;
    
    return cell;
    
    
    
}





@end
