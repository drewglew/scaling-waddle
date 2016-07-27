//
//  cargoioNSO.m
//  RoastChicken
//
//  Created by andrew glew on 25/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "cargoioNSO.h"

@implementation cargoioNSO
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
    cargoioNSO *cargoioCopy = [[cargoioNSO allocWithZone: zone] init];
    [cargoioCopy setId:self.id];
    [cargoioCopy setUnits:self.units];
    [cargoioCopy setExpense:self.expense];
    [cargoioCopy setEstimated:self.estimated];
    [cargoioCopy setTerms_id:self.terms_id];
    [cargoioCopy setNotice_time:self.notice_time];
    [cargoioCopy setType_id:self.type_id];
    [cargoioCopy setPurpose_code:self.purpose_code];
    [cargoioCopy setPort:[[self port] copyWithZone:zone]];
    [cargoioCopy setCalc_id:self.calc_id];
    return cargoioCopy;
}





@end
