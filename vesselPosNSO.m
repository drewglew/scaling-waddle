//
//  vesselPosNSO.m
//  RoastChicken
//
//  Created by andrew glew on 28/08/2017.
//  Copyright © 2017 andrew glew. All rights reserved.
//

#import "vesselPosNSO.h"

@implementation vesselPosNSO
@synthesize vessel;
@synthesize port;
@synthesize distance;
@synthesize lastKnownVoyageNr;
@synthesize estVoyageEnd_DT;


/* modified 20160805 */
- (id)init
{
    self = [super init];
    if (nil == self) return nil;
    // just initialize readonly tests:
    self.vessel = [[vesselNSO alloc] init];
    self.port = [[portNSO alloc] init];
    self.distance = [NSNumber numberWithFloat:0.0f];
    self.lastKnownVoyageNr =@"";
    return self;
}

@end
