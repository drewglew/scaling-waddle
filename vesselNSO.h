//
//  vesselNSO.h
//  RoastChicken
//
//  Created by andrew glew on 20/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <Foundation/Foundation.h>


@class dbHelper;

@interface vesselNSO : NSObject

@property (nonatomic) NSNumber *nr;
@property (nonatomic) NSString *ref_nr;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *searchstring;

-(vesselNSO*) getVesselData :(dbHelper*) db :(NSNumber*) vessel_nr;
-(NSString*) getVesselFullName;
-(id) copyWithZone: (NSZone *) zone;
@end
