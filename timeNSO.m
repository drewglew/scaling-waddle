//
//  timeNSO.m
//  RoastChicken
//
//  Created by andrew glew on 02/08/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "timeNSO.h"

@implementation timeNSO
@synthesize days;

-(NSNumber*) getMinutes  {
    int minutes = [self.days intValue] * 24 * 60;
    return [NSNumber numberWithInt:minutes];
}

@end
