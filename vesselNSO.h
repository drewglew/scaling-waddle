//
//  vesselNSO.h
//  RoastChicken
//
//  Created by andrew glew on 20/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dbManager.h"
#import "consumptionNSO.h"

@class dbHelper;

@interface vesselNSO : NSObject

@property (nonatomic) NSNumber *nr;
@property (nonatomic) NSString *ref_nr;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *imo;
@property (nonatomic) Boolean selected;
@property (nonatomic) NSString *type_name;
@property (nonatomic) NSNumber *type_id;
@property (nonatomic) NSString *searchstring;
@property (strong, nonatomic) consumptionNSO *ballast_cons;
@property (strong, nonatomic) consumptionNSO *laden_cons;
@property (strong, nonatomic) consumptionNSO *atport_cons;

//-(vesselNSO*) getVesselData :(dbHelper*) db :(NSNumber*) vessel_nr;
-(NSString*) getVesselFullName;
-(id) copyWithZone: (NSZone *) zone;
-(void) setVessel :(NSNumber*) v_nr :(NSString*) v_ref_nr :(NSString*) v_name;
-(void) setVesselByVesselNr :(NSNumber*) vessel_nr;
-(bool) insertVesselData;
-(NSMutableArray*) getVessels;
@end
