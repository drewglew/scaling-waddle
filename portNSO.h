//
//  portNSO.h
//  RoastChicken
//
//  Created by andrew glew on 20/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <Foundation/Foundation.h>

@class dbHelper;

@interface portNSO : NSObject

@property (nonatomic) NSString *code;
@property (nonatomic) NSString *abc_code;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *searchstring;


-(NSString*) getPortFullName;
-(id) copyWithZone: (NSZone *) zone;
-(portNSO*) getPortData :(dbHelper*) db :(NSString*) port_code;
@end
