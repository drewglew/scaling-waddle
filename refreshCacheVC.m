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
    
    
    // Do any additional setup after loading the view.
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
- (IBAction)refreshPortsPressed:(id)sender {
    NSURL *aUrl = [NSURL URLWithString:@"https://testapi.maersktankers.com/api/v1/Ports/GetPortList"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"CEEC5067A7BDD7D0DC5F75725DE93908814441A812B74DFCF751FFEC5150F594" forHTTPHeaderField:@"tankers-api-key"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        //NSLog(@"requestReply: %@", response);
        
        NSError *jsonError;
        NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&jsonError];
        /* here we try and load it into the db */
        // for each element (each Dictionary) in array, output the dictionary
        for (NSDictionary *dict in json) {
            
            portNSO *p = [[portNSO alloc] init];
            p.code = [dict objectForKey:@"Code"];
            p.abc_code = [dict objectForKey:@"AbcCode"];
            p.name = [dict objectForKey:@"Name"];
            // to do bridge these together!!
            [self.db insertPortData :p];
        }
    }] resume];
}


- (IBAction)refreshVesselsPressed:(id)sender {
    NSURL *aUrl = [NSURL URLWithString:@"https://testapi.maersktankers.com/api/v1/fleet/getVessels?active=yes&fields=name,ref_nr,nr,imo_number,active"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"CEEC5067A7BDD7D0DC5F75725DE93908814441A812B74DFCF751FFEC5150F594" forHTTPHeaderField:@"tankers-api-key"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        NSError *jsonError;
        NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&jsonError];
        /* here we try and load it into the db */
        // for each element (each Dictionary) in array, output the dictionary
        for (NSDictionary *dict in json) {
            
            bool active = [[dict objectForKey:@"Active"] boolValue];
            
            if (active) {
            vesselNSO *v = [[vesselNSO alloc] init];
            v.nr = [dict objectForKey:@"Nr"];
            v.ref_nr = [dict objectForKey:@"Ref_Nr"];
            v.name = [dict objectForKey:@"Name"];
            [self.db insertVesselData:v];
            
            /* need to get the consumptions loaded correctly if possible
             this can most likely be an average too in the long run
             */
            v.laden_cons.speed = [NSNumber numberWithFloat:10.0];
            v.laden_cons.hfo_amt = [NSNumber numberWithFloat:15.1];
            v.laden_cons.do_amt = [NSNumber numberWithFloat:0.0];
            v.laden_cons.mgo_amt = [NSNumber numberWithFloat:0.0];
            v.laden_cons.lsfo_amt = [NSNumber numberWithFloat:0.0];
            
            v.ballast_cons.speed = [NSNumber numberWithFloat:9.5];
            v.ballast_cons.hfo_amt = [NSNumber numberWithFloat:14.9];
            v.ballast_cons.do_amt = [NSNumber numberWithFloat:0.0];
            v.ballast_cons.mgo_amt = [NSNumber numberWithFloat:0.0];
            v.ballast_cons.lsfo_amt = [NSNumber numberWithFloat:0.0];
            
            v.atport_cons.speed = [NSNumber numberWithFloat:0.0];
            v.atport_cons.hfo_amt = [NSNumber numberWithFloat:5.0];
            v.atport_cons.do_amt = [NSNumber numberWithFloat:0.0];
            v.atport_cons.mgo_amt = [NSNumber numberWithFloat:0.0];
            v.atport_cons.lsfo_amt = [NSNumber numberWithFloat:0.0];
            
            [self.db insertConsumptionData:v.atport_cons :v.nr :[NSNumber numberWithInt:0]];   //atport consumptions
            [self.db insertConsumptionData:v.ballast_cons :v.nr :[NSNumber numberWithInt:1]];  //ballast consumptions
            [self.db insertConsumptionData:v.laden_cons :v.nr :[NSNumber numberWithInt:2]];   //laden consumptions    
            } else {
                NSLog(@"skipping inactive vessel");
            }
        }
    }] resume];
    
}
- (IBAction)refreshFlatRatesPressed:(id)sender {
}


@end
