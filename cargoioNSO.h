//
//  cargoioNSO.h
//  RoastChicken
//
//  Created by andrew glew on 25/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "portNSO.h"

@interface cargoioNSO : NSObject

//sql_statement = "CREATE TABLE cargoio(cargoio_id INTEGER PRIMARY KEY, cargoio_units INTEGER, cargoio_expense DECIMAL(8,2), cargoio_estimated DECIMAL(10,4), cargoio_terms_id INTEGER, cargoio_notice_time INTEGER, cargoio_type_id INTEGER, cargoio_purpose_code TEXT, cargoio_port_code TEXT, cargoio_calc_id INTEGER, FOREIGN KEY(cargoio_port_code) REFERENCES ports(port_code), FOREIGN KEY(cargoio_calc_id) REFERENCES calculations(calc_id))";

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
