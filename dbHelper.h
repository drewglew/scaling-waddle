//
//  dbHelper.h
//  RoastChicken
//
//  Created by andrew glew on 20/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "vesselNSO.h"
#import "portNSO.h"
#import "calculationNSO.h"
#import "cargoNSO.h"
#import "listingItemNSO.h"

@interface dbHelper : NSObject

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *DB;


-(bool)dbCreate :(NSString*) databaseName;
-(NSMutableArray*) getCalculations :(NSMutableArray*) listing;
-(vesselNSO *) getVesselByVesselNr :(NSNumber *) vessel_nr :(vesselNSO *) v;
-(NSMutableArray*) getVessels;
-(NSMutableArray*) getPorts;
-(portNSO*) getPortByPortCode :(NSString*) port_code :(portNSO*) p;
-(calculationNSO *) insertCalculationData :(calculationNSO *) c;
-(bool) deleteCalculation :(NSNumber *) calc_id;
-(calculationNSO *) updateCalculationData :(calculationNSO *) c;
-(bool) insertCargoPort :(cargoNSO *) cargo;
-(NSMutableArray*) getListing;
-(bool) prepareld :(calculationNSO *) c;
@end
