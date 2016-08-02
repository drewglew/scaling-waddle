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



/* created 20160802 */
-(NSNumber*) getExpenses {
    float expenses;
    expenses = [units floatValue] * [price floatValue];
    return [NSNumber numberWithInt:expenses];
}

/* created 20160802 */
-(id) copyWithZone: (NSZone *) zone
{
    bunkerNSO *bunkerCopy = [[bunkerNSO allocWithZone: zone] init];
    [bunkerCopy setUnits:self.units];
    [bunkerCopy setPrice:self.price];
    return bunkerCopy;
}

@end
