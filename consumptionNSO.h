//
//  consumptionNSO.h
//  RoastChicken
//
//  Created by andrew glew on 02/08/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dbManager.h"

@interface consumptionNSO : NSObject
@property (nonatomic) NSNumber *zone_id;
@property (nonatomic) NSNumber *id;
@property (nonatomic) NSNumber *speed;
@property (nonatomic) NSNumber *hfo_amt;
@property (nonatomic) NSNumber *do_amt;
@property (nonatomic) NSNumber *mgo_amt;
@property (nonatomic) NSNumber *lsfo_amt;

-(bool) insertConsumptionData :(NSNumber*) vessel_nr :(NSNumber*) cons_type;
-(void) setConsumptionByVesselAndType :(NSNumber*) vessel_nr :(NSNumber*) cons_type;
-(id) copyWithZone: (NSZone *) zone;
@end
