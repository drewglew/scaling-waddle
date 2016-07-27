//
//  calculationListingItemNSO.h
//  RoastChicken
//
//  Created by andrew glew on 26/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface listingItemNSO : NSObject

@property (nonatomic) NSNumber *id;
@property (nonatomic) NSString *descr;
@property (nonatomic) NSString *full_name_vessel;
@property (nonatomic) NSNumber *vessel_nr;
@property (nonatomic) NSString *ld_ports;
@property (nonatomic) NSDate  *lastmodified;

@end
