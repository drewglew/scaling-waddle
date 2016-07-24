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

@interface dbHelper : NSObject

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *DB;


-(bool)dbCreate :(NSString*) databaseName;
-(NSMutableArray*) getCalculations;

-(vesselNSO *) getVesselByVesselNr :(NSNumber *) vessel_nr :(vesselNSO *) v;
-(NSMutableArray*) getVessels;
-(NSMutableArray*) getPorts;
-(portNSO*) getPortByPortCode :(NSString*) port_code :(portNSO*) p;
-(calculationNSO *) insertCalculationData :(calculationNSO *) c;
-(bool) deleteCalculation :(NSNumber *) calc_id;
-(calculationNSO *) updateCalculationData :(calculationNSO *) c;
@end