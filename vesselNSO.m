//
//  vesselNSO.m
//  RoastChicken
//
//  Created by andrew glew on 20/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "vesselNSO.h"
#import "dbHelper.h"

@implementation vesselNSO

@synthesize ref_nr;
@synthesize nr;
@synthesize name;
@synthesize searchstring;
@synthesize laden_cons;
@synthesize ballast_cons;
@synthesize atport_cons;

- (id)init
{
    self = [super init];
    if (nil == self) return nil;
    // just initialize readonly tests:
    self.ballast_cons = [[consumptionNSO alloc] init];
    self.laden_cons = [[consumptionNSO alloc] init];
    self.atport_cons = [[consumptionNSO alloc] init];
    return self;
}


-(NSString*) getVesselFullName {
    if (nr!=nil) {
        return [NSString stringWithFormat:@"(%@) %@",ref_nr,name];
    } else {
        return @"";
    }
}


-(vesselNSO*) getVesselData :(dbHelper*) db :(NSNumber*) vessel_nr {
 
    [db getVesselByVesselNr:vessel_nr :self];
    return self;
}

/* created 20160722 */
-(id) copyWithZone: (NSZone *) zone
{
    vesselNSO *vesselCopy = [[vesselNSO allocWithZone: zone] init];
    [vesselCopy setNr:self.nr];
    [vesselCopy setName:self.name];
    [vesselCopy setRef_nr:self.ref_nr];
    [vesselCopy setLaden_cons:[[self laden_cons] copyWithZone:zone]];
    [vesselCopy setBallast_cons:[[self ballast_cons] copyWithZone:zone]];
    [vesselCopy setAtport_cons:[[self atport_cons] copyWithZone:zone]];
    return vesselCopy;
}




@end
