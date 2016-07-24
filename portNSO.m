//
//  portNSO.m
//  RoastChicken
//
//  Created by andrew glew on 20/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "portNSO.h"
#import "dbHelper.h"

@implementation portNSO

@synthesize name;
@synthesize code;
@synthesize abc_code;
@synthesize searchstring;


-(NSString*) getPortFullName {
    return [NSString stringWithFormat:@"(%@) - %@",code,name];
}

-(portNSO*) getPortData :(dbHelper*) db :(NSString*) port_code {
    
    [db getPortByPortCode:port_code :self];
    return self;
}


/* created 20160722 */
-(id) copyWithZone: (NSZone *) zone
{
    portNSO *portCopy = [[portNSO allocWithZone: zone] init];
    [portCopy setName:self.name];
    [portCopy setCode:self.code];
    [portCopy setAbc_code:self.abc_code];
    return portCopy;
}



@end
