//
//  cargoNSO.m
//  RoastChicken
//
//  Created by andrew glew on 28/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "cargoNSO.h"

@implementation cargoNSO

@synthesize id;
@synthesize units;
@synthesize expense;
@synthesize estimated;
@synthesize notice_time;
@synthesize type_id;
@synthesize purpose_code;
@synthesize port;
@synthesize calc_id;


- (id)init
{
    self = [super init];
    if (nil == self) return nil;
    // just initialize readonly tests:
    self.port = [[portNSO alloc] init];
    
    self.units = [NSNumber numberWithFloat:0.0f];
    self.expense = [NSNumber numberWithFloat:0.0f];
    self.estimated = [NSNumber numberWithFloat:0.0f];
    self.notice_time = [NSNumber numberWithFloat:0.0f];
    self.notice_time = [NSNumber numberWithInt:0];
    
    return self;
}


/* created 20160725 */
/* modified 20160814 */
-(NSMutableArray*) getCargoes :(NSNumber*) calcid {
   
    dbManager *sharedDBManager = [dbManager shareDBManager];
    NSString *query = [NSString stringWithFormat:@"SELECT cargoio_id ,cargoio_units,cargoio_expense, cargoio_estimated, cargoio_notice_time, cargoio_type_id, cargoio_purpose_code, cargoio_port_code, cargoio_calc_id FROM cargoio WHERE cargoio_calc_id=%@ order by cargoio_id",calcid];
    
    NSMutableArray *cargoes = [[NSMutableArray alloc] initWithArray: [sharedDBManager loadDataFromDB:query]];
    
    NSMutableArray *cargolist = [[NSMutableArray alloc] init];
    
    for (id obj in cargoes) {
        cargoNSO *c = [[cargoNSO alloc] init];
        
        c.id = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"cargoio_id"]];
        c.units = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"cargoio_units"]];
        c.expense = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"cargoio_expense"]];
        c.estimated = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"cargoio_estimated"]];
        c.notice_time = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"cargoio_notice_time"]];
        c.type_id = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"cargoio_type_id"]];
        c.purpose_code = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"cargoio_purpose_code"]]; ;
        c.port.code = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"cargoio_port_code"]]; ;
        c.calc_id = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"cargoio_calc_id"]];
        
        [c.port setPortByPortCode :c.port.code];
        
        [cargolist addObject:c];
    }
    
    return cargolist;
    
}

/* created 20160725 */
/* modified 20160814 */
-(bool) insertCargoPort {
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO cargoio (cargoio_id,cargoio_units,cargoio_expense,cargoio_estimated,cargoio_notice_time,cargoio_type_id,cargoio_purpose_code,cargoio_port_code,cargoio_calc_id) VALUES (%@,%@,%@,%@,%@,%@,'%@','%@',%@)", self.id, self.units, self.expense, self.estimated, self.notice_time, self.type_id, self.purpose_code, self.port.code, self.calc_id];
    
    dbManager *sharedDBManager = [dbManager shareDBManager];
    [sharedDBManager executeQuery:query];
    return true;
}


/* created 20160722 */
-(id) copyWithZone: (NSZone *) zone
{
    cargoNSO *cargoCopy = [[cargoNSO allocWithZone: zone] init];
    [cargoCopy setId:self.id];
    [cargoCopy setUnits:self.units];
    [cargoCopy setExpense:self.expense];
    [cargoCopy setEstimated:self.estimated];
    [cargoCopy setNotice_time:self.notice_time];
    [cargoCopy setType_id:self.type_id];
    [cargoCopy setPurpose_code:self.purpose_code];
    [cargoCopy setPort:[[self port] copyWithZone:zone]];
    [cargoCopy setCalc_id:self.calc_id];
    return cargoCopy;
}




@end
