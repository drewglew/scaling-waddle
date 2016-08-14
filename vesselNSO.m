//
//  vesselNSO.m
//  RoastChicken
//
//  Created by andrew glew on 20/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "vesselNSO.h"

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
        return [NSString stringWithFormat:@"(%@) %@", ref_nr, name];
    } else {
        return @"";
    }
}


/* created 20160813 */
-(void) setVessel :(NSNumber*) v_nr :(NSString*) v_ref_nr :(NSString*) v_name {
    self.nr = v_nr;
    self.ref_nr = v_ref_nr;
    self.name = v_name;
    
    
}

/* created 20160721 */
/* modified 20160813 */

-(bool) insertVesselData {
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO vessels (vessel_nr,vessel_ref_nr,vessel_name) VALUES (%@,'%@','%@')", self.nr, self.ref_nr, self.name];
    
    dbManager *sharedDBManager = [dbManager shareDBManager];
    [sharedDBManager executeQuery:query];
    return true;
}




/* created 20160721 */
/* modified 20160802 */

-(void) setVesselByVesselNr :(NSNumber*) vessel_nr {
    
    dbManager *sharedDBManager = [dbManager shareDBManager];
    NSString *query = [NSString stringWithFormat:@"SELECT vessel_nr,vessel_ref_nr,vessel_name FROM vessels WHERE vessel_nr=%@",vessel_nr];
    NSMutableArray *vessels = [[NSMutableArray alloc] initWithArray: [sharedDBManager loadDataFromDB:query]];

    self.nr = [[vessels objectAtIndex:0] objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"vessel_nr"]];
    self.ref_nr = [[vessels objectAtIndex:0] objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"vessel_ref_nr"]];
    self.name = [[vessels objectAtIndex:0] objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"vessel_name"]];

    [self.atport_cons setConsumptionByVesselAndType :self.nr :[NSNumber numberWithInt:0]];
    [self.ballast_cons setConsumptionByVesselAndType :self.nr :[NSNumber numberWithInt:1]];
    [self.laden_cons setConsumptionByVesselAndType :self.nr :[NSNumber numberWithInt:2]];
}


/* created 20160722 */
/* modified 20160802 */

-(NSMutableArray*) getVessels {
    
    dbManager *sharedDBManager = [dbManager shareDBManager];
    NSString *query = @"SELECT vessel_nr, vessel_ref_nr, vessel_name from vessels ORDER BY vessel_name DESC";
    NSMutableArray *vessels = [[NSMutableArray alloc] initWithArray: [sharedDBManager loadDataFromDB:query]];
    
    NSMutableArray *vessellist = [[NSMutableArray alloc] init];
    
    for (id obj in vessels) {
        vesselNSO *v = [[vesselNSO alloc] init];
        v.nr = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"vessel_nr"]];
        v.ref_nr = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"vessel_ref_nr"]];
        v.name = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"vessel_name"]];
        
        v.searchstring = self.getVesselFullName;
        [vessellist addObject:v];
    }
    
    return vessellist;
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
