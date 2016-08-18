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
@synthesize voyagestring;
@synthesize minutes_notice_time;
@synthesize mapImage;


/* modified 20160805 */
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
    self.net_day =  [NSNumber numberWithFloat:0.0f];
    self.voyagestring = @"";
    return self;
}


/* created 20160802 */
/* modified 20160818 */
/* calls atobviac webservice and stores routing in property, while focusing on distance and minutes while vessel is sailing */
/* optimize - perhaps we do not need to send ballastPort etc as single parms */
-(void) setRouteData :(NSString*) voyagequerystring :(calculationNSO*) calculation :(UILabel*) status :(UIActivityIndicatorView*) atobviacActivity :(UIButton*) calculateButton {
    
    NSString *url;
    NSString *apikey;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    apikey = appDelegate.apikey;

    url = [NSString stringWithFormat:@"https://api.atobviaconline.com/v1/%@&api_key=%@", voyagequerystring, apikey];
    
    [self fetchFromUrl:url withDictionary:^(NSDictionary *data) {
        self.routing = data;
        self.miles_sailing_ballasted = [NSNumber numberWithFloat:[[[data valueForKeyPath:@"Legs"][0] valueForKey:@"Distance"] floatValue]];
        self.miles_sailing_laden = [NSNumber numberWithFloat:[[[data valueForKeyPath:@"Legs"][1] valueForKey:@"Distance"] floatValue]];
        NSNumber *isRouteData = [NSNumber numberWithInt:0];
        [self performSelectorOnMainThread:@selector(updateActivity:) withObject:@[atobviacActivity,status,calculateButton,isRouteData] waitUntilDone:YES];
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



/* created 20160816 */
/* modified 20160818 */
/* calls atobviac webservice and stores image in property */
-(void) setMapData :(NSString*) voyagequerystring :(calculationNSO*) calculation :(UILabel*) status :(UIActivityIndicatorView*) atobviacActivity :(UIButton*) calculateButton :(UIImageView*) map :(UIButton*) mapDetailButton {
    
    NSURL *url;
    NSString *apikey;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    apikey = appDelegate.apikey;
    url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.atobviaconline.com/v1/%@&api_key=%@", voyagequerystring, apikey]];
    NSURLSessionDownloadTask *downloadMapTask = [[NSURLSession sharedSession]
                                                   downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                       self.mapImage = [UIImage imageWithData:
                                                                                   [NSData dataWithContentsOfURL:location]];
                                                       
                                                       dispatch_sync(dispatch_get_main_queue(), ^{
                                                           [map setImage:self.mapImage];
                                                           
                                                           [self setRouteData :self.voyagestring :calculation :status :atobviacActivity :calculateButton];
                                                           
                                                       });
                                                       NSNumber *isRouteData = [NSNumber numberWithInt:1];
                                                       [self performSelectorOnMainThread:@selector(updateActivity:) withObject:@[atobviacActivity,status,calculateButton,isRouteData,mapDetailButton] waitUntilDone:YES];
                                                       
                                                       
                                                       
                                                   }];
    [downloadMapTask resume];
}


/* last modified 20160818 */
- (void) updateActivity:(NSArray*)objectArray
{
    
    UIActivityIndicatorView* atobviacActivity = [objectArray objectAtIndex:0];
    UILabel* status = [objectArray objectAtIndex:1];
    UIButton* calcButton = [objectArray objectAtIndex:2];
    NSNumber *isRouteData = [objectArray objectAtIndex:3];
    
    [atobviacActivity stopAnimating];
    atobviacActivity.hidden = true;
    calcButton.enabled = true;
    
    
    if(self.routing==nil && isRouteData==[NSNumber numberWithInt:0]) {
        status.text = @"error no distance";
    } else {
        if (isRouteData==[NSNumber numberWithInt:1]) {
            UIButton* mapDetaiButton = [objectArray objectAtIndex:4];
            mapDetaiButton.hidden = false;
            status.text = @"drawn map";
        } else {
            status.text = @"distance retreived";
        }
    }
    
}

/* created 20160806 */
-(void) setAtPortData :(calculationNSO*) calculation {

    float units;
    
    NSLog(@"minutes at port = %@", [self getMinutesInPortTotal]);
    NSLog(@"bunker at port HFO = %@", calculation.vessel.atport_cons.hfo_amt);
    
    
    units = ([calculation.vessel.atport_cons.hfo_amt floatValue] * [[self getMinutesInPortTotal] floatValue]) / 1440.0f;
    self.hfo_bunker.units = [NSNumber numberWithFloat:[self.hfo_bunker.units floatValue] + units];

    units = ([calculation.vessel.atport_cons.do_amt floatValue] * [[self getMinutesInPortTotal] floatValue]) / 1440.0f;
    self.do_bunker.units = [NSNumber numberWithFloat:[self.do_bunker.units floatValue] + units];
    
    units = ([calculation.vessel.atport_cons.mgo_amt floatValue] * [[self getMinutesInPortTotal] floatValue]) / 1440.0f;
    self.mgo_bunker.units = [NSNumber numberWithFloat:[self.mgo_bunker.units floatValue] + units];
    
    units = ([calculation.vessel.atport_cons.lsfo_amt floatValue] * [[self getMinutesInPortTotal] floatValue]) / 1440.0f;
    self.lsfo_bunker.units = [NSNumber numberWithFloat:[self.lsfo_bunker.units floatValue] + units];
    
    
}





/* created 20160806 */
-(void) setSailingData :(calculationNSO*) calculation {
    
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

    
    
}





/* created 20160805 */
-(NSNumber*) getMinutesInPortTotal {
    float minutesinporttotal;
    minutesinporttotal = [loading_atport_minutes floatValue] + [discharging_atport_minutes floatValue] + [self.minutes_notice_time floatValue];
    NSLog(@"minutesinporttotal=%f",minutesinporttotal);
    return [NSNumber numberWithFloat:minutesinporttotal];
}

/* created 20160805 */
-(NSNumber*) getMinutesTotal {
    float minutes;
    minutes = [[self getMinutesInPortTotal] floatValue] + [minutes_sailing_laden floatValue]  + [minutes_sailing_ballasted floatValue]  + [additonal_minutes_sailing_idle floatValue]  + [additonal_minutes_sailing_laden floatValue]  + [additonal_minutes_sailing_ballasted floatValue] ;
     NSLog(@"minutes=%f",minutes);
    return [NSNumber numberWithFloat:minutes];
}

/* created 20160805 */
-(NSNumber*) getTotalCosts {
    float costs;
    costs = [broker_commission_amt floatValue] + [address_commission_amt floatValue]  + [hfo_bunker.getExpenses floatValue]  +  + [do_bunker.getExpenses floatValue]  + [mgo_bunker.getExpenses floatValue]  + [lsfo_bunker.getExpenses floatValue] + [total_expenses floatValue] + [additonal_expense_amt floatValue];
    NSLog(@"costs=%f",costs);
    return [NSNumber numberWithFloat:costs];
    
    
}


/* created 20160805 */
-(NSNumber*) getNetResult {
    float netresult;
    netresult = [gross_freight floatValue] - [[self getTotalCosts] floatValue];
    NSLog(@"netresult=%f",netresult);
    return [NSNumber numberWithFloat:netresult];
}

/* created 20160805 */
-(NSNumber*) getNetPerDay {
    float netperday;
    netperday = ([[self getNetResult] floatValue] / [[self getMinutesTotal] floatValue]) * 1440;
    NSLog(@"netperday=%f",netperday);
    self.net_day = [NSNumber numberWithFloat:netperday];
    return  self.net_day;
}

/* created 20160805 */
-(NSNumber*) getTcEqv {
    float tceqv;
    tceqv = ([[self getNetPerDay] floatValue]) * 30.416;
    return [self getNetPerDay];
    
}
















/* created 20160803 */
-(bool) setRateData :(NSNumber*)rate :(bool) useLocalFlatrate :(NSNumber*) flatRate :(NSNumber*) rateType {
    
    float unitprice;
    if ([rateType intValue]==0) {
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
/* modified 20160805 */
-(bool) setAtPortMinutes :(cargoNSO*) cargo {
    
    int estimated_minutes=0;

    if (cargo.estimated>0) {
            
        if (cargo.units!= [NSNumber numberWithInt:0]) {
            if (cargo.type_id == [NSNumber numberWithInt:0]) { // Hours
                estimated_minutes = [cargo.estimated intValue] * 60;
            } else if (cargo.type_id == [NSNumber numberWithInt:1]) { // MTS/Hour; Cubicmeters/Hour;Cublic feet/Hour
                estimated_minutes = abs([cargo.units intValue])/[cargo.estimated intValue] * 60;
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
    
    int noticetimemins;
    noticetimemins = [cargo.notice_time intValue] * 60;
    self.minutes_notice_time = [NSNumber numberWithInt:[self.minutes_notice_time intValue] + noticetimemins];
    
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
    [resultCopy setVoyagestring:self.voyagestring];
    [resultCopy setTotal_port_expenses :self.total_port_expenses];
    [resultCopy setMinutes_notice_time:self.minutes_notice_time];
    [resultCopy setMapImage:self.mapImage];
    return resultCopy;
}



@end
