//
//  bunkerNSO.h
//  RoastChicken
//
//  Created by andrew glew on 02/08/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bunkerNSO : NSObject
@property (nonatomic) NSNumber *units;
@property (nonatomic) NSNumber *price;
@property (nonatomic) NSNumber *additionals;

-(id) copyWithZone: (NSZone *) zone;
-(NSNumber*) getExpenses;

@end
