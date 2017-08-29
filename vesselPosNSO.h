//
//  vesselPosNSO.h
//  RoastChicken
//
//  Created by andrew glew on 28/08/2017.
//  Copyright © 2017 andrew glew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "vesselNSO.h"
#import "portNSO.h"

@interface vesselPosNSO : NSObject
@property (strong, nonatomic) vesselNSO *vessel;
@property (strong, nonatomic) portNSO *port;
@property (nonatomic) NSNumber *distance;
@property (nonatomic) NSString *lastKnownVoyageNr;
@end
