//
//  bunkerNSO.m
//  RoastChicken
//
//  Created by andrew glew on 02/08/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "bunkerNSO.h"

@implementation bunkerNSO
@synthesize units;
@synthesize price;
@synthesize additionals;

/* created 20160806 */
- (id)init
{
    self = [super init];
    if (nil == self) return nil;
    self.price = [NSNumber numberWithFloat:0.0f];
    self.units = [NSNumber numberWithFloat:0.0f];
    self.additionals = [NSNumber numberWithInt:0];
    return self;
}

/* created 20160802 */
-(NSNumber*) getExpenses {
    float expenses;
    expenses = [units floatValue] * [price floatValue];

    return [NSNumber numberWithInt:expenses];
}

/* created 20160802 */
/* modified 20160803 */
-(id) copyWithZone: (NSZone *) zone
{
    bunkerNSO *bunkerCopy = [[bunkerNSO allocWithZone: zone] init];
    [bunkerCopy setUnits:self.units];
    [bunkerCopy setPrice:self.price];
    [bunkerCopy setAdditionals:self.additionals];
    return bunkerCopy;
}

@end
