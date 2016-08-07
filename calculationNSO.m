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
    dischargeport.purpose_code = @"D";
    return self;
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



@end
