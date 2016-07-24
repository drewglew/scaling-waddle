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


@interface calculationNSO : NSObject

@property (nonatomic) NSNumber *id;
@property (nonatomic) NSString *descr;
@property (nonatomic) NSString *statustext;
@property (nonatomic) NSNumber *rate;
@property (nonatomic) NSNumber *tce;
@property (strong, nonatomic) vesselNSO *vessel;
@property (strong, nonatomic) portNSO *port_from;
@property (strong, nonatomic) portNSO *port_to;
@property (strong, nonatomic) portNSO *port_ballast_from;
@property (nonatomic) NSDate *created;
@property (nonatomic) NSDate *lastmodified;
-(id) copyWithZone: (NSZone *) zone;

@end