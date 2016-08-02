//
//  vesselNSO.h
//  RoastChicken
//
//  Created by andrew glew on 20/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "consumptionNSO.h"

@class dbHelper;

@interface vesselNSO : NSObject

@property (nonatomic) NSNumber *nr;
@property (nonatomic) NSString *ref_nr;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *searchstring;
@property (strong, nonatomic) consumptionNSO *ballast_cons;
@property (strong, nonatomic) consumptionNSO *laden_cons;

-(vesselNSO*) getVesselData :(dbHelper*) db :(NSNumber*) vessel_nr;
-(NSString*) getVesselFullName;
-(id) copyWithZone: (NSZone *) zone;

@end
