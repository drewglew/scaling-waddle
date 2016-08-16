//
//  calculationNSO.m
//  RoastChicken
//
//  Created by andrew glew on 20/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "calculationNSO.h"

@implementation calculationNSO

@synthesize vessel;

@synthesize port_ballast_from;
@synthesize id;
@synthesize descr;
@synthesize statustext;
@synthesize rate;
@synthesize flatrate;
@synthesize tce;
@synthesize created;
@synthesize lastmodified;
@synthesize cargoios;
@synthesize ld_ports;
@synthesize bld_codes;
@synthesize result;
@synthesize voyagestring;


/* modified 20160802 */
- (id)init
{
    self = [super init];
    if (nil == self) return nil;
    self.vessel = [[vesselNSO alloc] init];
    /* we need to direct these to the other table we will have */
    self.cargoios = [[NSMutableArray alloc] init];
    cargoNSO *loadport = [[cargoNSO alloc ] init];
    loadport.id = [NSNumber numberWithInt:1];
    loadport.purpose_code = @"L";
    [self.cargoios addObject:loadport];
    cargoNSO *dischargeport = [[cargoNSO alloc ] init];
    dischargeport.id = [NSNumber numberWithInt:2];
    dischargeport.purpose_code = @"D";
    [self.cargoios addObject:dischargeport];
    self.port_ballast_from = [[portNSO alloc] init];
    self.result = [[resultNSO alloc] init];
    self.flatrate = [NSNumber numberWithFloat:0.0f];
    self.tce = [NSNumber numberWithFloat:0.0f];
    self.rate = [NSNumber numberWithFloat:0.0f];
    self.add_ballasted_days = [NSNumber numberWithInt:0];
    self.add_laden_days = [NSNumber numberWithInt:0];
    self.add_idle_days = [NSNumber numberWithInt:0];
    self.add_expenses = [NSNumber numberWithInt:0];
    self.tce = [NSNumber numberWithInt:0];

    return self;
}


/* created 20160806 */
-(NSString*)getbldportcodes {
    
    cargoNSO *loadPort = [self.cargoios firstObject];
    cargoNSO *dischargePort = [self.cargoios lastObject];
    NSString *returnVal = @"";
    if (![loadPort.port.name isEqualToString:@""]) {
        returnVal = [NSString stringWithFormat:@"%@%@%@", self.port_ballast_from.code, loadPort.port.code,dischargePort.port.code];
    }
    return returnVal;
}

-(NSString*)getldportnames {

    cargoNSO *loadPort = [self.cargoios firstObject];
    cargoNSO *dischargePort = [self.cargoios lastObject];
    NSString *returnVal = @"";
    if (![loadPort.port.name isEqualToString:@""]) {
        returnVal = [NSString stringWithFormat:@"%@ - %@", loadPort.port.name,dischargePort.port.name];
    }
    return returnVal;
}

-(NSString*)getldportcombo {
    cargoNSO *loadPort = [self.cargoios firstObject];
    cargoNSO *dischargePort = [self.cargoios lastObject];
    NSString *returnVal = @"";
    if (![loadPort.port.name isEqualToString:@""]) {
        returnVal = [NSString stringWithFormat:@"%@%@", loadPort.port.code,dischargePort.port.code];
    }
    return returnVal;
}

/* created 20160807 */
-(NSString*)getNiceLastModifiedDate {
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yyyy HH:mm"];
    
    dateString = [formatter stringFromDate:self.lastmodified];
    return dateString;
}





/* created 20160723 */
/* modified 20160813 */
-(bool) deleteCalculation :(NSNumber *) calc_id {

    NSString *query = [NSString stringWithFormat:@"DELETE FROM calculations WHERE calc_id = %@", calc_id];
    dbManager *sharedDBManager = [dbManager shareDBManager];
    [sharedDBManager executeQuery:query];
    return true;
    
}

/* created 20160721 */
/* modified 20160726 */
-(NSMutableArray*) getCalculations :(NSMutableArray*) listing {
    
    dbManager *sharedDBManager = [dbManager shareDBManager];
    NSString *query = [NSString stringWithFormat:@"SELECT calc_id, calc_vessel_nr, calc_description, calc_rate, calc_flatrate, calc_tce, calc_port_ballast_from, calc_created, calc_last_modified, calc_hfo_price, calc_do_price, calc_mgo_price, calc_lsfo_price, calc_address_commission, calc_broker_commission, calc_add_idle_days, calc_add_ballasted_days, calc_add_laden_days, calc_add_expenses, calc_add_hfo, calc_add_do, calc_add_mgo, calc_add_lsfo, calc_voyagestring, calc_miles_ball, calc_miles_laden from calculations where calc_id IN (%@) ORDER BY calc_id DESC", result];
    
    NSMutableArray *calculations = [[NSMutableArray alloc] initWithArray: [sharedDBManager loadDataFromDB:query]];
    
    NSMutableArray *calculationlist = [[NSMutableArray alloc] init];
    
    for (id obj in calculations) {
    
        calculationNSO *c = [[calculationNSO alloc] init];
        
        c.id = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_id"]];
        c.vessel.nr = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_vessel_nr"]];
        c.descr = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_description"]];
        c.rate = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_rate"]];
        c.flatrate = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_flatrate"]];
        c.result.net_day = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_tce"]];
        c.port_ballast_from.code = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_port_ballast_from"]];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        c.created = [dateFormat dateFromString:[obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_created"]]];
        c.lastmodified = [dateFormat dateFromString:[obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_last_modified"]]];
        
        c.result.hfo_bunker.price = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_hfo_price"]];
        c.result.do_bunker.price = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_do_price"]];
        c.result.mgo_bunker.price = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_mgo_price"]];
        c.result.lsfo_bunker.price = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_lsfo_price"]];
        
        c.result.address_commission_percent = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_address_commission"]];
        
        c.result.broker_commission_percent = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_broker_commission"]];
        c.add_idle_days = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_add_idle_days"]];
        c.add_ballasted_days = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_add_ballasted_days"]];
        c.add_laden_days = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_add_laden_days"]];
        c.add_expenses = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_add_expenses"]];
        c.result.hfo_bunker.additionals =  [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_add_hfo"]];
        c.result.do_bunker.additionals =  [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_add_do"]];
        c.result.mgo_bunker.additionals =  [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_add_mgo"]];
        c.result.lsfo_bunker.additionals =  [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_add_lsfo"]];
        c.result.voyagestring = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_voyagestring"]];
        c.result.miles_sailing_ballasted = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_miles_ball"]];
        c.result.miles_sailing_laden = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_miles_laden"]];
        
        
        [c.vessel setVesselByVesselNr :c.vessel.nr];
        [c.port_ballast_from setPortByPortCode:c.port_ballast_from.code];
       
       // c.cargoios = [self getCargoes :c.id];
                
        [calculationlist addObject:c];
    }

    
    return calculationlist;
}

/* created 20160726 */
-(NSMutableArray*) getListing {
    NSMutableArray *listing = [[NSMutableArray alloc] init];
    
    dbManager *sharedDBManager = [dbManager shareDBManager];
    NSString *query = @"SELECT calculations.calc_id, calculations.calc_vessel_nr, '(' || vessels.vessel_ref_nr || ')' || vessels.vessel_name as fullname, calculations.calc_description, calculations.calc_last_modified, calculations.calc_ld_ports from calculations, vessels WHERE vessels.vessel_nr = calculations.calc_vessel_nr ORDER BY calc_id DESC";
    
    NSMutableArray *calculations = [[NSMutableArray alloc] initWithArray: [sharedDBManager loadDataFromDB:query]];
    
    for (id obj in calculations) {
    
        listingItemNSO *l = [[listingItemNSO alloc] init];
        
        l.id = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_id"]];
        l.vessel_nr =  [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_vessel_nr"]];
        l.full_name_vessel = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"fullname"]];
        l.descr = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_description"]];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        l.lastmodified = [dateFormat dateFromString:[obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_last_modified"]]];
        l.ld_ports = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"calc_ld_ports"]];
                
        [listing addObject:l];
    }
    return listing;
}


/* created 20160721 */
/* modified 20160813 */

-(void) insertCalculationData {
 
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateCreated=[dateFormat stringFromDate:self.created];
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO calculations (calc_id, calc_description, calc_rate, calc_flatrate, calc_tce, calc_vessel_nr, calc_port_ballast_from, calc_created, calc_last_modified, calc_ld_ports, calc_hfo_price, calc_do_price, calc_mgo_price, calc_lsfo_price, calc_address_commission, calc_broker_commission, calc_add_idle_days, calc_add_ballasted_days, calc_add_laden_days, calc_add_expenses, calc_add_hfo, calc_add_do, calc_add_mgo, calc_add_lsfo, calc_voyagestring, calc_miles_ball, calc_miles_laden) VALUES ((SELECT MAX(calc_id) + 1 FROM calculations),'%@', %@, %@, %@, %@,'%@','%s', '%s', '%@', %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@,'%@',%@,%@)", self.descr, self.rate,self.flatrate, self.result.net_day,self.vessel.nr,self.port_ballast_from.code, dateCreated.UTF8String, dateCreated.UTF8String,self.ld_ports, self.result.hfo_bunker.price, self.result.do_bunker.price, self.result.mgo_bunker.price, self.result.lsfo_bunker.price, self.result.address_commission_percent, self.result.broker_commission_percent, self.add_idle_days, self.add_ballasted_days, self.add_laden_days, self.add_expenses, self.result.hfo_bunker.additionals, self.result.do_bunker.additionals, self.result.mgo_bunker.additionals, self.result.lsfo_bunker.additionals, self.result.voyagestring, self.result.miles_sailing_ballasted, self.result.miles_sailing_laden];
    
    dbManager *sharedDBManager = [dbManager shareDBManager];
    [sharedDBManager executeQuery:query];
    
    cargoNSO *l_port = [self.cargoios firstObject];
    query = [NSString stringWithFormat:@"INSERT INTO cargoio (cargoio_id,cargoio_units,cargoio_expense,cargoio_estimated,cargoio_notice_time,cargoio_type_id,cargoio_purpose_code,cargoio_port_code,cargoio_calc_id) VALUES (%@,%@,%@,%@,%@,%@,'%@','%@',%@)", l_port.id, l_port.units, l_port.expense, l_port.estimated, l_port.notice_time, l_port.type_id, l_port.purpose_code, l_port.port.code, l_port.calc_id];
    [sharedDBManager executeQuery:query];
    
    cargoNSO *d_port = [self.cargoios lastObject];
    query = [NSString stringWithFormat:@"INSERT INTO cargoio (cargoio_id,cargoio_units,cargoio_expense,cargoio_estimated,cargoio_notice_time,cargoio_type_id,cargoio_purpose_code,cargoio_port_code,cargoio_calc_id) VALUES (%@,%@,%@,%@,%@,%@,'%@','%@',%@)", d_port.id, d_port.units, d_port.expense, d_port.estimated, d_port.notice_time, d_port.type_id, d_port.purpose_code, d_port.port.code, d_port.calc_id];
    [sharedDBManager executeQuery:query];

}



/* created 20160721 */
/* modified 20160813 */
-(void) updateCalculationData {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *last_mod = [NSDate date];
    NSString *dateLastModified = [dateFormat stringFromDate:last_mod];
    
    NSString *query =  [NSString stringWithFormat:@"UPDATE calculations set calc_description = '%@', calc_rate = %@, calc_flatrate = %@, calc_tce = %@, calc_vessel_nr=%@, calc_port_ballast_from='%@', calc_last_modified = '%s', calc_ld_ports = '%@', calc_hfo_price = %@, calc_do_price = %@, calc_mgo_price = %@, calc_lsfo_price = %@, calc_address_commission = %@, calc_broker_commission = %@, calc_add_idle_days = %@, calc_add_ballasted_days = %@, calc_add_laden_days = %@, calc_add_expenses = %@, calc_add_hfo = %@, calc_add_do = %@, calc_add_mgo = %@, calc_add_lsfo = %@, calc_voyagestring = '%@', calc_miles_ball = %@, calc_miles_laden = %@  where calc_id=%@", self.descr, self.rate, self.flatrate, self.result.net_day, self.vessel.nr,self.port_ballast_from.code, dateLastModified.UTF8String, self.ld_ports, self.result.hfo_bunker.price, self.result.do_bunker.price, self.result.mgo_bunker.price, self.result.lsfo_bunker.price, self.result.address_commission_percent, self.result.broker_commission_percent, self.add_idle_days, self.add_ballasted_days, self.add_laden_days, self.add_expenses, self.result.hfo_bunker.additionals, self.result.do_bunker.additionals, self.result.mgo_bunker.additionals, self.result.lsfo_bunker.additionals,  self.result.voyagestring, self.result.miles_sailing_ballasted, self.result.miles_sailing_laden, self.id];
    
    dbManager *sharedDBManager = [dbManager shareDBManager];
    [sharedDBManager executeQuery:query];

    self.lastmodified = last_mod;

    cargoNSO *l_port = [self.cargoios firstObject];
    query = [NSString stringWithFormat:@"UPDATE cargoio set cargoio_units=%@, cargoio_expense=%@, cargoio_estimated=%@, cargoio_notice_time=%@, cargoio_type_id=%@,cargoio_purpose_code='L', cargoio_port_code='%@' where cargoio_calc_id=%@ and cargoio_id=1", l_port.units, l_port.expense, l_port.estimated, l_port.notice_time, l_port.type_id, l_port.port.code, self.id];
    [sharedDBManager executeQuery:query];
    
    cargoNSO *d_port = [self.cargoios lastObject];
    query = [NSString stringWithFormat:@"UPDATE cargoio set cargoio_units=%@, cargoio_expense=%@, cargoio_estimated=%@, cargoio_notice_time=%@, cargoio_type_id=%@,cargoio_purpose_code='D', cargoio_port_code='%@' where cargoio_calc_id=%@ and cargoio_id=2", d_port.units, d_port.expense, d_port.estimated, d_port.notice_time, d_port.type_id, d_port.port.code, self.id];
    [sharedDBManager executeQuery:query];
    
}


/* created 20160722 */
-(id) copyWithZone: (NSZone *) zone
{
    calculationNSO *calcCopy = [[calculationNSO allocWithZone: zone] init];
    [calcCopy setId:self.id];
    [calcCopy setDescr:self.descr];
    [calcCopy setRate:self.rate];
    [calcCopy setFlatrate:self.flatrate];
    [calcCopy setTce:self.tce];
    [calcCopy setVessel:[[self vessel] copyWithZone:zone]];
    [calcCopy setPort_ballast_from:[[self port_ballast_from] copyWithZone:zone]];
    [calcCopy setCargoios:[[self cargoios] copyWithZone:zone]];
    [calcCopy setLd_ports:self.ld_ports];
    
    [calcCopy setAdd_idle_days:self.add_idle_days];
    [calcCopy setAdd_ballasted_days:self.add_ballasted_days];
    [calcCopy setAdd_laden_days:self.add_laden_days];
    [calcCopy setAdd_expenses:self.add_expenses];
    
    [calcCopy setResult:[[self result] copyWithZone:zone]];
    return calcCopy;
}



@end
