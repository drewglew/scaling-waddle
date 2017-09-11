//
//  calculationNSO.h
//  RoastChicken
//
//  Created by andrew glew on 20/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "vesselNSO.h"
#import "portNSO.h"
#import "cargoNSO.h"
#import "resultNSO.h"
#import "listingItemNSO.h"


@interface calculationNSO : NSObject

@property (nonatomic) NSNumber *id;
@property (nonatomic) NSString *descr;
@property (nonatomic) NSString *statustext;
@property (nonatomic) NSString *ld_ports;
@property (nonatomic) NSString *bld_codes;
@property (nonatomic) NSNumber *rate;
@property (nonatomic) NSNumber *flatrate;
@property (nonatomic) NSNumber *tce;
@property (strong, nonatomic) vesselNSO *vessel;
@property (strong, nonatomic) portNSO *port_ballast_from;
@property (strong, nonatomic) resultNSO *result;
@property (nonatomic) NSDate *created;
@property (nonatomic) NSDate *lastmodified;
@property (nonatomic) NSNumber *add_idle_days;
@property (nonatomic) NSNumber *add_ballasted_days;
@property (nonatomic) NSNumber *add_laden_days;
@property (nonatomic) NSNumber *add_expenses;
@property (nonatomic) NSString *voyagestring;

@property (strong, nonatomic) NSMutableArray *cargoios;
-(id) copyWithZone: (NSZone *) zone;
-(NSString*)getldportnames;
-(NSString*)getldportcombo;
-(NSString*)getbldportcodes;
-(NSString*)getNiceLastModifiedDate;
-(bool) deleteCalculation :(NSNumber *) calc_id;
-(NSMutableArray*) getCalculations :(NSMutableArray*) listing;
-(NSMutableArray*) getListing;
-(void) updateCalculationData;
-(void)AddToCargos :(cargoNSO*) c;


@end
