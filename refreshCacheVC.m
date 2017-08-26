//
//  refreshCacheVC.m
//  RoastChicken
//
//  Created by andrew glew on 23/08/2017.
//  Copyright © 2017 andrew glew. All rights reserved.
//

#import "refreshCacheVC.h"
#import "dbHelper.h"

@interface refreshCacheVC () <refreshCacheDelegate>

@end

@implementation refreshCacheVC
@synthesize db;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    self.stepperYear.value = [components year];
    self.labelYear.text = [NSString stringWithFormat:@"%ld",(long)[components year]];
    
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

/* created 20170826 */
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


/*
 created on: 20170823
 last updated: 20170826
 */
- (IBAction)refreshPortsPressed:(id)sender {
    
    NSString *url = @"https://testapi.maersktankers.com/api/v1/Ports/GetPortList";
    
    [self fetchFromTankers:url withDictionary:^(NSDictionary *data) {
        for (NSDictionary *dict in data) {
            
            portNSO *p = [[portNSO alloc] init];
            p.code = [dict objectForKey:@"Code"];
            p.abc_code = [dict objectForKey:@"AbcCode"];
            p.name = [dict objectForKey:@"Name"];
            // to do bridge these together!!
            [self.db insertPortData :p];
        }
    }];
}

/*
 created on: 20170823
 last updated: 20170826
 
 */
- (IBAction)refreshVesselsPressed:(id)sender {
    NSString *url = @"https://testapi.maersktankers.com/api/v1/fleet/getVessels?active=yes&fields=name,ref_nr,nr,imo_number,active";
    
    [self fetchFromTankers:url withDictionary:^(NSDictionary *data) {
        for (NSDictionary *dict in data) {
            bool active = [[dict objectForKey:@"Active"] boolValue];
            if (active) {
                vesselNSO *v = [[vesselNSO alloc] init];
                v.nr = [dict objectForKey:@"Nr"];
                v.ref_nr = [dict objectForKey:@"Ref_Nr"];
                v.name = [dict objectForKey:@"Name"];
                [self.db insertVesselData:v];
                
            } else {
                NSLog(@"skipping inactive vessel");
            }
        }
    }];
}

/*
 created on: 20170825
 last updated: 20170826
 */
- (IBAction)refreshWSRatesPressed:(id)sender {
    
    [self.db deleteWorldScaleRate];
    
    NSString *url = [NSString stringWithFormat:@"https://testapi.maersktankers.com/api/v1/DataFeed/GetWsRates?year=%ld&maxPorts=2",(long)self.stepperYear.value];
    
    [self fetchFromTankers:url withDictionary:^(NSDictionary *data) {
        for (NSDictionary *dict in data) {
            NSString *portlist = [NSString stringWithFormat:@"%@",[dict objectForKey:@"WsPortList"]];
            NSNumber *rate = [dict objectForKey:@"Wsca_Rate"];
            [self.db insertWorldScaleRate:portlist :rate];
        }
    }];
}


/*
 created on: 20170823
 last updated: 20170824
 
 */
- (IBAction)refreshConsumptionsPressed:(id)sender {
    
    self.vessels = self.db.getVessels;
    
    [self.db deleteConsumptions];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; // or since you're not doing anything special here, use `sharedSession`
    
    // since we're going to block a thread in the process of controlling the degree of
    // concurrency, let's do this on a background queue; we're still blocking
    // a GCD worker thread as these run (which isn't ideal), but we're only using
    // one worker thread.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(4); // only do four requests at a time
        dispatch_group_t group = dispatch_group_create();
        
        for (vesselNSO *v in self.vessels) {
            dispatch_group_enter(group);                               // tell the group that we're starting another request
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // wait for one of the four slots to open up
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://testapi.maersktankers.com/api/v1/Fleet/GetVesselAvgConsumption?refno=%@",v.ref_nr]]
                                                          cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                      timeoutInterval:10];
            
            [request setHTTPMethod:@"GET"];
            [request setValue:@"CEEC5067A7BDD7D0DC5F75725DE93908814441A812B74DFCF751FFEC5150F594" forHTTPHeaderField:@"tankers-api-key"];
            
            
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error) {
                    // ...
                } else {
                    NSError *parsingError = nil;
                    NSDictionary *consumptions = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers  error:&error];
                    if (parsingError) {
                        
                    } else {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            
                            for (NSDictionary *cons in consumptions) {
                                // better to have the same index of zone in the web service as the segment index.
                                if (([[cons objectForKey:@"Zone"] isEqualToString:@"HSFO"] && self.segmentZones.selectedSegmentIndex == 0) || ([[cons objectForKey:@"Zone"] isEqualToString:@"LSGO"] && self.segmentZones.selectedSegmentIndex == 1) || ([[cons objectForKey:@"Zone"] isEqualToString:@"ULSFO"] && self.segmentZones.selectedSegmentIndex == 2) ) {
                                    
                                    if ([[cons objectForKey:@"Type"] isEqualToString:@"At Port - General"]) {
                                        
                                        v.atport_cons.speed = [cons objectForKey:@"Speed"];
                                        
                                        v.atport_cons.hfo_amt = [cons objectForKey:@"HSFO"];
                                        v.atport_cons.do_amt = [cons objectForKey:@"LSGO"];
                                        v.atport_cons.mgo_amt = [cons objectForKey:@"HSGO"];
                                        v.atport_cons.lsfo_amt = [cons objectForKey:@"LSFO"];
                                        
                                    } else if ([[cons objectForKey:@"Type"] isEqualToString:@"Sailing - Ballast"]) {
                                        v.ballast_cons.speed = [cons objectForKey:@"Speed"];
                                            
                                        v.ballast_cons.hfo_amt = [cons objectForKey:@"HSFO"];
                                        v.ballast_cons.do_amt = [cons objectForKey:@"LSGO"];
                                        v.ballast_cons.mgo_amt = [cons objectForKey:@"HSGO"];
                                        v.ballast_cons.lsfo_amt = [cons objectForKey:@"LSFO"];
                                        
                                    } else if ([[cons objectForKey:@"Type"] isEqualToString:@"Sailing - Laden"]) {
                                        
                                        v.laden_cons.speed = [cons objectForKey:@"Speed"];
                                        
                                        v.laden_cons.hfo_amt = [cons objectForKey:@"HSFO"];
                                        v.laden_cons.do_amt = [cons objectForKey:@"LSGO"];
                                        v.laden_cons.mgo_amt = [cons objectForKey:@"HSGO"];
                                        v.laden_cons.lsfo_amt = [cons objectForKey:@"LSFO"];
                                    }
                                }
                            }
                        });
                    }
                }
                
                dispatch_semaphore_signal(semaphore);                  // when done, flag task as complete so one of the waiting ones can start
                dispatch_group_leave(group);                           // tell the group that we're done
            }];
            [task resume];
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            // trigger whatever you want when they're all done
            
            // and if you want them in order, iterate through the paths and pull out the appropriate result in order
            for (vesselNSO *v in self.vessels) {
                [self.db insertConsumptionData:v.atport_cons :v.nr :[NSNumber numberWithInt:0]];  //atport consumption
                [self.db insertConsumptionData:v.ballast_cons :v.nr :[NSNumber numberWithInt:1]];  //ballast consumption
                [self.db insertConsumptionData:v.laden_cons :v.nr :[NSNumber numberWithInt:2]];  //laden consumption
            }
        });
    });
    
    
}

- (IBAction)stepperYearUpdated:(id)sender {
    
    self.labelYear.text = [NSString stringWithFormat:@"%ld",(long)self.stepperYear.value];
}


@end
