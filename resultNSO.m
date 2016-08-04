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
@synthesize address_commission_amt;
@synthesize broker_commission_amt;
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
@synthesize total_units;
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
    self.broker_commission_percent = [NSNumber numberWithFloat:0.0f];
    self.address_commission_percent = [NSNumber numberWithFloat:0.0f];
    self.broker_commission_amt = [NSNumber numberWithFloat:0.0f];
    self.address_commission_amt = [NSNumber numberWithFloat:0.0f];
    
    return self;
}


/* created 20160802 */
/* calls atobviac webservice and stores routing in property, while focusing on distance and minutes while vessel is sailing */
/* optimize - perhaps we do not need to send ballastPort etc as single parms */
-(void) setRouteData :(portNSO*) ballastPort :(portNSO*) fromPort :(portNSO*) toPort :(calculationNSO*) calculation {
    
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


/* created 20160803 */
-(bool) setRateData :(NSNumber*)rate :(bool) useLocalFlatrate :(NSNumber*) flatRate :(NSNumber*) rateType {
    
    float unitprice;
    if (rateType==[NSNumber numberWithInt:0]) {
        // Per MT
        unitprice = [rate floatValue];
    } else {
        // Worldscale
        //if (useLocalFlatrate) {
        unitprice = ([rate floatValue]/100) * [flatRate floatValue];
        //} else {
            // TODO - what to do if this is something else
        //}
    }
    if (unitprice>0.0f) {
        self.gross_freight = [NSNumber numberWithFloat:[self.total_units floatValue] * unitprice];
    }
    return true;
    
}

/* created 20160803 */
-(bool) setCommissionAmts {
    
    float temp;
    
    temp = [self.address_commission_percent floatValue] * [self.gross_freight floatValue] / 100;
    self.address_commission_amt = [NSNumber numberWithFloat:temp];
    
    temp = [self.broker_commission_percent floatValue] * [self.gross_freight floatValue] / 100;
    self.broker_commission_amt = [NSNumber numberWithFloat:temp];
    
    return true;
}

/* created 20160804 */
-(bool) setAtPortMinutes :(cargoNSO*) cargo {
    
    int estimated_minutes=0;

    if (cargo.estimated>0) {
            
        if (cargo.units!= [NSNumber numberWithInt:0]) {
            if (cargo.type_id == [NSNumber numberWithInt:0]) { // Hours
                estimated_minutes = [cargo.estimated intValue] * 60;
            } else if (cargo.type_id == [NSNumber numberWithInt:1]) { // MTS/Hour; Cubicmeters/Hour;Cublic feet/Hour
                estimated_minutes = [cargo.units intValue]/[cargo.estimated intValue] * 60;
            } else if (cargo.type_id == [NSNumber numberWithInt:3]) { //Days
                estimated_minutes = [cargo.estimated intValue] * 1440;
            } else { // MTS/Day; Cubicmeters/Day; Cublic feet/Day
                estimated_minutes = ([cargo.units intValue]*1440) / [cargo.estimated intValue];
            }
        }
    }
    if ([cargo.purpose_code isEqualToString:@"L"]) {
        self.loading_atport_minutes = [NSNumber numberWithInt:estimated_minutes];
    } else {
        self.discharging_atport_minutes = [NSNumber numberWithInt:estimated_minutes];
    }
    
    return true;
}




/* created 20160802 */
-(id) copyWithZone: (NSZone *) zone
{
    resultNSO *resultCopy = [[resultNSO allocWithZone: zone] init];
    [resultCopy setAddress_commission_percent :self.address_commission_percent];
    [resultCopy setBroker_commission_percent :self.broker_commission_percent];
    [resultCopy setAddress_commission_amt:self.address_commission_amt];
    [resultCopy setBroker_commission_amt:self.broker_commission_amt];
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
    [resultCopy setTotal_units :self.total_units];
    [resultCopy setNet_result :self.net_result];
    [resultCopy setNet_day :self.net_day];
    [resultCopy setTc_eqv :self.tc_eqv];
    [resultCopy setTotal_port_expenses :self.total_port_expenses];
    return resultCopy;
}



@end
