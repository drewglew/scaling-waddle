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

/* created 20160806 */
- (id)init
{
    self = [super init];
    if (nil == self) return nil;
    // just initialize readonly tests:
    self.name = @"";
    self.code = @"";
    return self;
}


-(NSString*) getPortFullName {
    if ([self.code isEqualToString:@""]) {
        return @"";
    
    } else {
        return [NSString stringWithFormat:@"(%@) - %@",code,name];
    }
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

/* created 20160813 */
-(void) setPort :(NSString*) p_code :(NSString*) p_abc_code :(NSString*) p_name {
    self.code = p_code;
    self.abc_code = p_abc_code;
    self.name = p_name;
}

-(void) insertPort {
    NSString *query = [NSString stringWithFormat:@"INSERT INTO ports (port_code,port_abc_code,port_name) VALUES ('%@','%@','%@')", self.code, self.abc_code, self.name];
    dbManager *sharedDBManager = [dbManager shareDBManager];
    [sharedDBManager executeQuery:query];
}


/* created 20160722 */
/* modified 20160813 */
-(void) setPortByPortCode :(NSString*) port_code {
    
    dbManager *sharedDBManager = [dbManager shareDBManager];
    NSString *query = [NSString stringWithFormat:@"SELECT port_code,port_abc_code,port_name FROM ports WHERE port_code='%@'",port_code];
    NSMutableArray *ports = [[NSMutableArray alloc] initWithArray: [sharedDBManager loadDataFromDB:query]];
    self.code = [[ports objectAtIndex:0] objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"port_code"]];
    self.abc_code = [[ports objectAtIndex:0] objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"abc_code"]];
    self.name = [[ports objectAtIndex:0] objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"port_name"]];
    self.searchstring = [self getPortFullName];

}

/* created 20160722 */
-(NSMutableArray*) getPorts {
    dbManager *sharedDBManager = [dbManager shareDBManager];
    
    NSString *query = @"SELECT port_code, port_abc_code, port_name from ports ORDER BY port_name DESC";
    NSMutableArray *ports = [[NSMutableArray alloc] initWithArray: [sharedDBManager loadDataFromDB:query]];
    
    NSMutableArray *portlist = [[NSMutableArray alloc] init];
   
    for (id obj in ports) {
        portNSO *p = [[portNSO alloc] init];
        p.code = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"port_code"]];
        p.abc_code = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"port_abc_code"]];
        p.name = [obj objectAtIndex:[sharedDBManager.arrColumnNames indexOfObject:@"port_name"]];
        p.searchstring = p.getPortFullName;
        [portlist addObject:p];
    }
    
    return portlist;
}






@end
