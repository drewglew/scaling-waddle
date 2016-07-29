//
//  cargoNSO.h
//  RoastChicken
//
//  Created by andrew glew on 28/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "portNSO.h"

@interface cargoNSO : NSObject

@property (nonatomic) NSNumber *id;
@property (nonatomic) NSNumber *units;
@property (nonatomic) NSNumber *expense;
@property (nonatomic) NSNumber *estimated;
@property (nonatomic) NSNumber *terms_id;
@property (nonatomic) NSNumber *notice_time;
@property (nonatomic) NSNumber *type_id;
@property (nonatomic) NSString *purpose_code;
@property (strong, nonatomic) portNSO * port;
@property (nonatomic) NSNumber *calc_id;
-(id) copyWithZone: (NSZone *) zone;

@end
