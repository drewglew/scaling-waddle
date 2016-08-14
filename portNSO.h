//
//  portNSO.h
//  RoastChicken
//
//  Created by andrew glew on 20/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dbManager.h"

@interface portNSO : NSObject

@property (nonatomic) NSString *code;
@property (nonatomic) NSString *abc_code;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *searchstring;


-(NSString*) getPortFullName;
-(id) copyWithZone: (NSZone *) zone;
-(NSMutableArray*) getPorts;
-(void) setPortByPortCode :(NSString*) port_code;
-(void) insertPort;
-(void) setPort :(NSString*) p_code :(NSString*) p_abc_code :(NSString*) p_name;
@end
