//
//  consumptionNSO.m
//  RoastChicken
//
//  Created by andrew glew on 02/08/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "consumptionNSO.h"

@implementation consumptionNSO
@synthesize id;
@synthesize zone_id;
@synthesize speed;
@synthesize hfo_amt;
@synthesize do_amt;
@synthesize mgo_amt;
@synthesize lsfo_amt;



/* created 20160802 */
-(bool) insertConsumptionData :(NSNumber*) vessel_nr :(NSNumber*) cons_type {
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO consumptions (cons_type_id, cons_zone_id, cons_vessel_nr, cons_speed, cons_hfo, cons_do, cons_mgo, cons_lsfo) VALUES (%@,%d,%@,%@,%@,%@,%@,%@)", cons_type, 1, vessel_nr, self.speed, self.hfo_amt, self.do_amt, self.mgo_amt, self.lsfo_amt];

    dbManager *sharedDBManager = [dbManager shareDBManager];
    [sharedDBManager executeQuery:query];
    return true;
}


/* created 20160802 */
/* modified 20160813 */
-(void) setConsumptionByVesselAndType :(NSNumber*) vessel_nr :(NSNumber*) cons_type {
    
    dbManager *sharedDBManager = [dbManager shareDBManager];
    
    NSString *query = [NSString stringWithFormat:@"SELECT cons_speed, cons_hfo, cons_do, cons_mgo, cons_lsfo from consumptions WHERE cons_vessel_nr=%@ AND cons_type_id=%@",vessel_nr, cons_type];
    
    NSMutableArray *consumptions = [[NSMutableArray alloc] initWithArray: [sharedDBManager loadDataFromDB:query]];
    self.speed = [[consumptions objectAtIndex:0] objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"cons_speed"]];
    self.hfo_amt = [[consumptions objectAtIndex:0] objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"cons_hfo"]];
    self.do_amt = [[consumptions objectAtIndex:0] objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"cons_do"]];
    self.mgo_amt = [[consumptions objectAtIndex:0] objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"cons_mgo"]];
    self.lsfo_amt = [[consumptions objectAtIndex:0] objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"cons_lsfo"]];

}


/* created 20160802 */
-(id) copyWithZone: (NSZone *) zone
{
    consumptionNSO *consCopy = [[consumptionNSO allocWithZone: zone] init];
    [consCopy setId:self.id];
    [consCopy setZone_id:self.zone_id];
    [consCopy setSpeed:self.speed];
    [consCopy setHfo_amt:self.hfo_amt];
    [consCopy setDo_amt:self.do_amt];
    [consCopy setMgo_amt:self.mgo_amt];
    [consCopy setLsfo_amt:self.lsfo_amt];
    return consCopy;
}


@end
