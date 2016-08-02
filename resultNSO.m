//
//  resultNSO.m
//  RoastChicken
//
//  Created by andrew glew on 02/08/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "resultNSO.h"
#import "calculationNSO.h"

@implementation resultNSO

@synthesize address_commission_percent;
@synthesize  broker_commission_percent;
@synthesize  additonal_expense_amt;
@synthesize hfo_bunker;
@synthesize do_bunker;
@synthesize mgo_bunker;
@synthesize lsfo_bunker;
@synthesize additonal_minutes_sailing_ballasted;
@synthesize additonal_minutes_sailing_laden;
@synthesize additonal_minutes_sailing_idle;
@synthesize minutes_sailing_laden;
@synthesize minutes_sailing_ballasted;
@synthesize minutes_total;
@synthesize loading_atport_minutes;
@synthesize discharging_atport_minutes;
@synthesize minutes_in_port;
@synthesize miles_sailing_laden;
@synthesize miles_sailing_ballasted;
@synthesize gross_freight;
@synthesize gross_day;
@synthesize total_costs;
@synthesize total_expenses;
@synthesize net_result;
@synthesize net_day;
@synthesize tc_eqv;
@synthesize total_port_expenses;



- (id)init
{
    self = [super init];
    if (nil == self) return nil;
    // just initialize readonly tests:
    self.hfo_bunker = [[bunkerNSO alloc] init];
    self.do_bunker = [[bunkerNSO alloc] init];
    self.mgo_bunker = [[bunkerNSO alloc] init];
    self.lsfo_bunker = [[bunkerNSO alloc] init];
    return self;
}


/* created 20160802 */
/* calls atobviac webservice and stores routing in property, while focusing on distance and minutes while vessel is sailing */
-(void) getRoute :(portNSO*) ballastPort :(portNSO*) fromPort :(portNSO*) toPort :(calculationNSO*) calculation {
    
    NSString *url;
    if (ballastPort!=nil) {
        url = [NSString stringWithFormat:@"https://api.atobviaconline.com/v1/Voyage?port=%@&port=%@&port=%@&api_key=demo", ballastPort.abc_code, fromPort.abc_code, toPort.abc_code];
    } else {
         url = [NSString stringWithFormat:@"https://api.atobviaconline.com/v1/Voyage?port=%@&port=%@&port=%@&api_key=demo", fromPort.abc_code, fromPort.abc_code, toPort.abc_code];
    }
    
    [self fetchFromUrl:url withDictionary:^(NSDictionary *data) {
        self.routing = data;

        self.miles_sailing_ballasted = [NSNumber numberWithFloat:[[[data valueForKeyPath:@"Legs"][0] valueForKey:@"Distance"] floatValue]];
        self.miles_sailing_laden = [NSNumber numberWithFloat:[[[data valueForKeyPath:@"Legs"][1] valueForKey:@"Distance"] floatValue]];
      
        self.minutes_sailing_ballasted = [NSNumber numberWithFloat:[self.miles_sailing_ballasted floatValue] / [calculation.vessel.ballast_cons.speed floatValue] * 60.0f];
        
        self.minutes_sailing_laden = [NSNumber numberWithFloat:[self.miles_sailing_laden floatValue] / [calculation.vessel.laden_cons.speed floatValue] * 60.0f];
        
        float units;
        
        units = ([calculation.vessel.ballast_cons.hfo_amt floatValue] * [self.minutes_sailing_ballasted floatValue]) / 1440.0f;
        units += ([calculation.vessel.laden_cons.hfo_amt floatValue] * [self.minutes_sailing_laden floatValue]) / 1440.0f;
        self.hfo_bunker.units = [NSNumber numberWithFloat:units];
        
        units = ([calculation.vessel.ballast_cons.do_amt floatValue] * [self.minutes_sailing_ballasted floatValue]) / 1440.0f;
        units += ([calculation.vessel.laden_cons.do_amt floatValue] * [self.minutes_sailing_laden floatValue]) / 1440.0f;
        self.do_bunker.units = [NSNumber numberWithFloat:units];
        
        units = ([calculation.vessel.ballast_cons.mgo_amt floatValue] * [self.minutes_sailing_ballasted floatValue]) / 1440.0f;
        units += ([calculation.vessel.laden_cons.mgo_amt floatValue] * [self.minutes_sailing_laden floatValue]) / 1440.0f;
        self.mgo_bunker.units = [NSNumber numberWithFloat:units];
       
        units = ([calculation.vessel.ballast_cons.lsfo_amt floatValue] * [self.minutes_sailing_ballasted floatValue]) / 1440.0f;
        units += ([calculation.vessel.laden_cons.lsfo_amt floatValue] * [self.minutes_sailing_laden floatValue]) / 1440.0f;
        self.lsfo_bunker.units = [NSNumber numberWithFloat:units];
        
    }];
}



/* created 20160802 */
/* purpose is to call the remote webservice and load the reponse into a dictionary object */
-(void)fetchFromUrl:(NSString *)url withDictionary:(void (^)(NSDictionary* data))dictionary{
    NSURLRequest *request = [NSURLRequest  requestWithURL:[NSURL URLWithString:url]];
    NSURLSession *session = [NSURLSession sharedSession];
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




/* created 20160802 */
-(id) copyWithZone: (NSZone *) zone
{
    resultNSO *resultCopy = [[resultNSO allocWithZone: zone] init];
    [resultCopy setAddress_commission_percent :self.address_commission_percent];
    [resultCopy setBroker_commission_percent :self.broker_commission_percent];
    [resultCopy setAdditonal_expense_amt :self.additonal_expense_amt];
    [resultCopy setHfo_bunker :[[self hfo_bunker] copyWithZone:zone]];
    [resultCopy setDo_bunker :[[self do_bunker] copyWithZone:zone]];
    [resultCopy setMgo_bunker :[[self mgo_bunker] copyWithZone:zone]];
    [resultCopy setLsfo_bunker :[[self lsfo_bunker] copyWithZone:zone]];
    [resultCopy setAdditonal_minutes_sailing_ballasted :self.additonal_minutes_sailing_ballasted];
    [resultCopy setAdditonal_minutes_sailing_laden :self.additonal_minutes_sailing_laden];
    [resultCopy setAdditonal_minutes_sailing_idle :self.additonal_minutes_sailing_idle];
    [resultCopy setMinutes_sailing_laden :self.minutes_sailing_laden];
    [resultCopy setMinutes_sailing_ballasted :self.minutes_sailing_ballasted];
    [resultCopy setMinutes_total :self.minutes_total];
    [resultCopy setLoading_atport_minutes :self.loading_atport_minutes];
    [resultCopy setDischarging_atport_minutes :self.discharging_atport_minutes];
    [resultCopy setMinutes_in_port :self.minutes_in_port];
    [resultCopy setMiles_sailing_laden :self.miles_sailing_laden];
    [resultCopy setMiles_sailing_ballasted :self.miles_sailing_ballasted];
    [resultCopy setGross_freight :self.gross_freight];
    [resultCopy setGross_day :self.gross_day];
    [resultCopy setTotal_costs :self.total_costs];
    [resultCopy setTotal_expenses :self.total_expenses];
    [resultCopy setNet_result :self.net_result];
    [resultCopy setNet_day :self.net_day];
    [resultCopy setTc_eqv :self.tc_eqv];
    [resultCopy setTotal_port_expenses :self.total_port_expenses];
    return resultCopy;
}



@end
