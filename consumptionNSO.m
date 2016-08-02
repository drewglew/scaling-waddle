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
