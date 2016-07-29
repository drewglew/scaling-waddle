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
@synthesize port_from;
@synthesize port_to;
@synthesize port_ballast_from;
@synthesize id;
@synthesize descr;
@synthesize statustext;
@synthesize rate;
@synthesize tce;
@synthesize created;
@synthesize lastmodified;
@synthesize cargoios;
@synthesize ld_ports;

- (id)init
{
    self = [super init];
    if (nil == self) return nil;
    // just initialize readonly tests:
    
    self.vessel = [[vesselNSO alloc] init];
    
    /* we need to direct these to the other table we will have */
    self.port_from = [[portNSO alloc] init];
    self.port_to = [[portNSO alloc] init];
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
    return self;
}


/* created 20160722 */
-(id) copyWithZone: (NSZone *) zone
{
    calculationNSO *calcCopy = [[calculationNSO allocWithZone: zone] init];
    [calcCopy setId:self.id];
    [calcCopy setDescr:self.descr];
    [calcCopy setRate:self.rate];
    [calcCopy setTce:self.tce];
    [calcCopy setVessel:[[self vessel] copyWithZone:zone]];
    [calcCopy setPort_to:[[self port_to] copyWithZone:zone]];
    [calcCopy setPort_from:[[self port_from] copyWithZone:zone]];
    [calcCopy setPort_ballast_from:[[self port_ballast_from] copyWithZone:zone]];
    [calcCopy setCargoios:[[self cargoios] copyWithZone:zone]];
    [calcCopy setLd_ports:self.ld_ports];
    return calcCopy;
}



-(NSString*)getldportnames {

    cargoNSO *loadPort = [self.cargoios firstObject];
    cargoNSO *dischargePort = [self.cargoios lastObject];
    NSString *returnVal = @"";
    if (![loadPort.port.name isEqualToString:@"(null)"]) {
        returnVal = [NSString stringWithFormat:@"%@ - %@", loadPort.port.name,dischargePort.port.name];
    }
    return returnVal;
}




@end
