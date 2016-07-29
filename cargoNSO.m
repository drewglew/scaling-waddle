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
@synthesize terms_id;
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
    return self;
}


/* created 20160722 */
-(id) copyWithZone: (NSZone *) zone
{
    cargoNSO *cargoCopy = [[cargoNSO allocWithZone: zone] init];
    [cargoCopy setId:self.id];
    [cargoCopy setUnits:self.units];
    [cargoCopy setExpense:self.expense];
    [cargoCopy setEstimated:self.estimated];
    [cargoCopy setTerms_id:self.terms_id];
    [cargoCopy setNotice_time:self.notice_time];
    [cargoCopy setType_id:self.type_id];
    [cargoCopy setPurpose_code:self.purpose_code];
    [cargoCopy setPort:[[self port] copyWithZone:zone]];
    [cargoCopy setCalc_id:self.calc_id];
    return cargoCopy;
}




@end
