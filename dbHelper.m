//
//  dbHelper.m
//  RoastChicken
//
//  Created by andrew glew on 20/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "dbHelper.h"


@class dbhelper;

@implementation dbHelper



/* modified 20160802 */

-(bool)dbCreate :(NSString*) databaseName {
    NSString *docsDir;
    NSArray *dirPaths;

    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    /* clean up old db */
    // [self deleteDB:@"tramosol"];
    
    
    _databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:databaseName]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if([filemgr fileExistsAtPath:_databasePath] ==  NO) {
        const char *dbpath = [_databasePath UTF8String];
        
        if(sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
            char *errorMessage;
            
            /* number 1:  vessels */
            
            const char *sql_statement = "CREATE TABLE vessels(vessel_nr INTEGER PRIMARY KEY, vessel_ref_nr TEXT, vessel_name TEXT)";
            
            if(sqlite3_exec(_DB, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK) {
                NSLog(@"failed to create vessels table");
                sqlite3_close(_DB);
                return false;
            }
            
             /* number 2: ports */
            sql_statement = "CREATE TABLE ports(port_code TEXT PRIMARY KEY, port_abc_code TEXT, port_name TEXT)";
            if(sqlite3_exec(_DB, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK) {
                NSLog(@"failed to create table ports");
                sqlite3_close(_DB);
                return false;
            }
            
            /* number 3: calculations */
            sql_statement = "CREATE TABLE calculations(calc_id INTEGER PRIMARY KEY, calc_vessel_nr INTEGER, calc_description TEXT, calc_rate DECIMAL(10, 5), calc_tce DECIMAL(10, 5), calc_port_ballast_from TEXT, calc_created DATETIME, calc_last_modified DATETIME, calc_ld_ports TEXT, calc_hfo_price DECIMAL(10, 2), calc_do_price DECIMAL(10, 2), calc_mgo_price DECIMAL(10, 2), calc_lsfo_price DECIMAL(10, 2), calc_address_commission DECIMAL(10, 2), calc_broker_commission DECIMAL(10, 2),  FOREIGN KEY(calc_vessel_nr) REFERENCES vessels(vessel_nr), FOREIGN KEY(calc_port_ballast_from) REFERENCES ports(port_code) )";
            if(sqlite3_exec(_DB, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK) {
                NSLog(@"failed to create calculations table");
                sqlite3_close(_DB);
                return false;
            }
            
            /* number 4: cargo in/out  */
            sql_statement = "CREATE TABLE cargoio(cargoio_id INTEGER, cargoio_units INTEGER, cargoio_expense DECIMAL(8,2), cargoio_estimated DECIMAL(10,4), cargoio_terms_id INTEGER, cargoio_notice_time INTEGER, cargoio_type_id INTEGER, cargoio_purpose_code TEXT, cargoio_port_code TEXT, cargoio_calc_id INTEGER, FOREIGN KEY(cargoio_port_code) REFERENCES ports(port_code), FOREIGN KEY(cargoio_calc_id) REFERENCES calculations(calc_id), PRIMARY KEY (cargoio_id, cargoio_calc_id))";
            if(sqlite3_exec(_DB, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK) {
                NSLog(@"failed to create table cargoio");
                sqlite3_close(_DB);
                return false;
            } else {
                NSLog(@"Whoopee successul in creating table cargioio");
            }
            
            
            /* number 5: consumptions  */
            sql_statement = "CREATE TABLE consumptions(cons_id INTEGER PRIMARY KEY, cons_vessel_nr INTEGER, cons_type_id INTEGER, cons_zone_id INTEGER, cons_speed DECIMAL(8, 2), cons_hfo DECIMAL(8, 2), cons_do DECIMAL(8,2), cons_mgo DECIMAL(8,2), cons_lsfo DECIMAL(8,2), FOREIGN KEY(cons_vessel_nr) REFERENCES vessels(vessel_nr))";
            if(sqlite3_exec(_DB, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK) {
                NSLog(@"failed to create table consumptions");
                sqlite3_close(_DB);
                return false;
            } else {
                NSLog(@"Whoopee successul in creating table consumptions");
            }
            
            
            /* now we populate the database with dummy data */
            
            vesselNSO *v = [[vesselNSO alloc] init];
            v.nr = [NSNumber numberWithInt:4];
            v.ref_nr = @"004";
            v.name = @"Hans Scholl";

            v.laden_cons.speed = [NSNumber numberWithFloat:10.0];
            v.laden_cons.hfo_amt = [NSNumber numberWithFloat:15.1];
            v.laden_cons.do_amt = [NSNumber numberWithFloat:0.0];
            v.laden_cons.mgo_amt = [NSNumber numberWithFloat:0.0];
            v.laden_cons.lsfo_amt = [NSNumber numberWithFloat:0.0];
            
            v.ballast_cons.speed = [NSNumber numberWithFloat:9.5];
            v.ballast_cons.hfo_amt = [NSNumber numberWithFloat:14.9];
            v.ballast_cons.do_amt = [NSNumber numberWithFloat:0.0];
            v.ballast_cons.mgo_amt = [NSNumber numberWithFloat:0.0];
            v.ballast_cons.lsfo_amt = [NSNumber numberWithFloat:0.0];
        
            [self insertVesselData:v];
            [self insertConsumptionData:v.ballast_cons :v.nr :[NSNumber numberWithInt:1]];  //ballast consumptions
            [self insertConsumptionData:v.laden_cons :v.nr :[NSNumber numberWithInt:2]];   //laden consumptions
            
            
            v.nr = [NSNumber numberWithInt:5];
            v.ref_nr = @"555";
            v.name = @"Andys Magic";
            [self insertVesselData:v];
            [self insertConsumptionData:v.ballast_cons :v.nr :[NSNumber numberWithInt:1]];  //ballast consumptions
            [self insertConsumptionData:v.laden_cons :v.nr :[NSNumber numberWithInt:2]];   //laden consumptions
            
            v.nr = [NSNumber numberWithInt:6];
            v.ref_nr = @"ABC";
            v.name = @"Alice";
            [self insertVesselData:v];
            [self insertConsumptionData:v.ballast_cons :v.nr :[NSNumber numberWithInt:1]];  //ballast consumptions
            [self insertConsumptionData:v.laden_cons :v.nr :[NSNumber numberWithInt:2]];   //laden consumptions
            
            
            v.nr = [NSNumber numberWithInt:7];
            v.ref_nr = @"DEF";
            v.name = @"Bro Developer";
            [self insertVesselData:v];
            [self insertConsumptionData:v.ballast_cons :v.nr :[NSNumber numberWithInt:1]];  //ballast consumptions
            [self insertConsumptionData:v.laden_cons :v.nr :[NSNumber numberWithInt:2]];   //laden consumptions
            
            
            v.nr = [NSNumber numberWithInt:8];
            v.ref_nr = @"GHI";
            v.name = @"Helle Maersk";
            [self insertVesselData:v];
            [self insertConsumptionData:v.ballast_cons :v.nr :[NSNumber numberWithInt:1]];  //ballast consumptions
            [self insertConsumptionData:v.laden_cons :v.nr :[NSNumber numberWithInt:2]];   //laden consumptions
            
            
            v.nr = [NSNumber numberWithInt:9];
            v.ref_nr = @"JKL";
            v.name = @"Maersk Simon";
            [self insertVesselData:v];
            [self insertConsumptionData:v.ballast_cons :v.nr :[NSNumber numberWithInt:1]];  //ballast consumptions
            [self insertConsumptionData:v.laden_cons :v.nr :[NSNumber numberWithInt:2]];   //laden consumptions
            
            
            v.nr = [NSNumber numberWithInt:10];
            v.ref_nr = @"MNO";
            v.name = @"Maersk Henry";
            [self insertVesselData:v];
            [self insertConsumptionData:v.ballast_cons :v.nr :[NSNumber numberWithInt:1]];  //ballast consumptions
            [self insertConsumptionData:v.laden_cons :v.nr :[NSNumber numberWithInt:2]];   //laden consumptions
            
            
            v.nr = [NSNumber numberWithInt:11];
            v.ref_nr = @"PQR";
            v.name = @"Miguel Maersk";
            [self insertVesselData:v];
            [self insertConsumptionData:v.ballast_cons :v.nr :[NSNumber numberWithInt:1]];  //ballast consumptions
            [self insertConsumptionData:v.laden_cons :v.nr :[NSNumber numberWithInt:2]];   //laden consumptions
            
            v.nr = [NSNumber numberWithInt:12];
            v.ref_nr = @"STU";
            v.name = @"Bro Designer";
            [self insertVesselData:v];
            [self insertConsumptionData:v.ballast_cons :v.nr :[NSNumber numberWithInt:1]];  //ballast consumptions
            [self insertConsumptionData:v.laden_cons :v.nr :[NSNumber numberWithInt:2]];   //laden consumptions

            v.nr = [NSNumber numberWithInt:13];
            v.ref_nr = @"VWX";
            v.name = @"Sophie";
            [self insertVesselData:v];
            [self insertConsumptionData:v.ballast_cons :v.nr :[NSNumber numberWithInt:1]];  //ballast consumptions
            [self insertConsumptionData:v.laden_cons :v.nr :[NSNumber numberWithInt:2]];   //laden consumptions
            

            portNSO *p = [[portNSO alloc] init];
            p.code = @"LON";
            p.abc_code = @"GB0004";
            p.name = @"London";
            [self insertPortData :p];
            
            p.code = @"HAM";
            p.abc_code = @"DE0005";
            p.name = @"Hamburg";
            [self insertPortData :p];
            
            p.code = @"RAS";
            p.abc_code = @"AE0038";
            p.name = @"Port Rashid";
            [self insertPortData :p];
            
            p.code = @"CPH";
            p.abc_code = @"DK0021";
            p.name = @"Copenhagen";
            [self insertPortData :p];
            
            p.code = @"NOV";
            p.abc_code = @"RU0119";
            p.name = @"Novorossiysk";
            [self insertPortData :p];
            
            
            p.code = @"CHI";
            p.abc_code = @"JP0018";
            p.name = @"Chiba";
            [self insertPortData :p];
     
            p.code = @"LOO";
            p.abc_code = @"UM0001";
            p.name = @"LOOP Terminal";
            [self insertPortData :p];
            
            p.code = @"MEB";
            p.abc_code = @"AU0181";
            p.name = @"Melbourne";
            [self insertPortData :p];
            
            calculationNSO *c = [[calculationNSO alloc] init];
            
            c.descr = @"Sample Calculation with dummy data";
            c.rate = [NSNumber numberWithDouble:20.5];
            c.tce = [NSNumber numberWithDouble:100.5];
            c.vessel.nr =  [NSNumber numberWithInt:5];
            c.created =  [NSDate date];
            c.result.hfo_bunker.price = [NSNumber numberWithDouble:100.05];
            c.result.do_bunker.price = [NSNumber numberWithDouble:90.50];
            c.result.mgo_bunker.price = [NSNumber numberWithDouble:120.10];
            c.result.lsfo_bunker.price = [NSNumber numberWithDouble:83.00];
            c.result.broker_commission_percent = [NSNumber numberWithDouble:1.0];
            c.result.address_commission_percent = [NSNumber numberWithDouble:1.125];
            
            // soon to be discarded..
            c.ld_ports = @"Copenhagen-Melbourne";
            
            c.port_ballast_from.code = @"CPH";
            [self insertCalculationData :c];

            //lets add this to calculation and lose the calc_id!
            cargoNSO *cargo = [[cargoNSO alloc] init];
            
            cargo.id = [NSNumber numberWithInt:1];  // this is actually the sort order
            cargo.calc_id = c.id;
            cargo.units = [NSNumber numberWithInt:2000];
            cargo.expense = [NSNumber numberWithDouble:200.00];
            cargo.estimated = [NSNumber numberWithDouble:1000.00];
            cargo.terms_id = [NSNumber numberWithInt:1];
            cargo.notice_time = [NSNumber numberWithInt:5];
            cargo.type_id = [NSNumber numberWithInt:1];
            cargo.purpose_code = @"L";
            cargo.port.code = @"CPH";
            [self insertCargoPort :cargo];
            cargo.id = [NSNumber numberWithInt:2];  // this is actually the sort order
            cargo.calc_id = c.id;
            cargo.units = [NSNumber numberWithInt:2000];
            cargo.expense = [NSNumber numberWithDouble:175.00];
            cargo.estimated = [NSNumber numberWithDouble:500.00];
            cargo.terms_id = [NSNumber numberWithInt:1];
            cargo.notice_time = [NSNumber numberWithInt:2];
            cargo.type_id = [NSNumber numberWithInt:1];
            cargo.purpose_code = @"D";
            cargo.port.code = @"MEB";
            [self insertCargoPort :cargo];

            sqlite3_close(_DB);
        } else {
            NSLog(@"failed to create table");
            return false;
        }
    }
    return true;
}



/* created 20160725 */
/* modified 20160726 */
-(bool) insertCargoPort :(cargoNSO *) cargo {
    
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO cargoio (cargoio_id,cargoio_units,cargoio_expense,cargoio_estimated,cargoio_terms_id,cargoio_notice_time,cargoio_type_id,cargoio_purpose_code,cargoio_port_code,cargoio_calc_id) VALUES (%@,%@,%@,%@,%@,%@,%@,'%@','%@',%@)", cargo.id, cargo.units, cargo.expense, cargo.estimated, cargo.terms_id, cargo.notice_time, cargo.type_id, cargo.purpose_code, cargo.port.code, cargo.calc_id];
    
    sqlite3_stmt *statement;
    const char *insert_statement = [insertSQL UTF8String];
    sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
    if (sqlite3_step(statement) != SQLITE_DONE) {
        NSLog(@"Failed to insert new cargoio record inside vessels table");
        return false;
    } else {
        NSLog(@"inserted new cargoio record inside vessels table!");
    }
    sqlite3_finalize(statement);
    
    return true;
}


/* created 20160725 */
/* modified 20160726 */
-(bool) prepareld :(calculationNSO *) c {

    cargoNSO *loadport = [c.cargoios firstObject];
    loadport.calc_id = c.id;
    [self insertCargoPort:loadport];
    
    cargoNSO *dischargeport = [c.cargoios lastObject];
    dischargeport.calc_id = c.id;
    [self insertCargoPort:dischargeport];
    
    return true;
}



/* created 20160721 */
-(bool) insertVesselData :(vesselNSO *) v {
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO vessels (vessel_nr,vessel_ref_nr,vessel_name) VALUES (%@,'%@','%@')", v.nr, v.ref_nr, v.name];
    
    sqlite3_stmt *statement;
    const char *insert_statement = [insertSQL UTF8String];
    sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
    if (sqlite3_step(statement) != SQLITE_DONE) {
        NSLog(@"Failed to insert new vessel record inside vessels table");
        return false;
    } else {
        NSLog(@"inserted new vessel record inside vessels table!");
    }
    sqlite3_finalize(statement);


    return true;
}



/* created 20160802 */
-(bool) insertConsumptionData :(consumptionNSO*) c :(NSNumber*) vessel_nr :(NSNumber*) cons_type {
    
     NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO consumptions (cons_type_id, cons_zone_id, cons_vessel_nr, cons_speed, cons_hfo, cons_do, cons_mgo, cons_lsfo) VALUES (%@,%d,%@,%@,%@,%@,%@,%@)", cons_type, 1, vessel_nr, c.speed, c.hfo_amt, c.do_amt, c.mgo_amt, c.lsfo_amt];
    
    sqlite3_stmt *statement;
    
    const char *insert_statement = [insertSQL UTF8String];
    sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
    if (sqlite3_step(statement) != SQLITE_DONE) {
        NSLog(@"Failed to insert new consumption record inside vessels table");
        return false;
    } else {
        NSLog(@"inserted new consumption record inside vessels table!");
    }
    sqlite3_finalize(statement);
    
    
    return true;
    
}





/* created 20160721 */
-(bool) insertPortData :(portNSO *) p {
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO ports (port_code,port_abc_code,port_name) VALUES ('%@','%@','%@')", p.code, p.abc_code, p.name];
    
    sqlite3_stmt *statement;
    const char *insert_statement = [insertSQL UTF8String];
    sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
    if (sqlite3_step(statement) != SQLITE_DONE) {
        NSLog(@"Failed to insert new port record inside ports table");
        return false;
    } else {
        NSLog(@"inserted new port two record inside ports table!");
    }
    sqlite3_finalize(statement);
    
    return true;
}




/* created 20160721 */
/* modified 20160802 */
-(calculationNSO *) insertCalculationData :(calculationNSO *) c {
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    NSNumber *newCalcId;
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        NSString *selectSQL = @"SELECT MAX(calc_id) FROM calculations";
        const char *select_statement = [selectSQL UTF8String];
        
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                newCalcId = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)+1];
            }
        }

        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateCreated=[dateFormat stringFromDate:c.created];
        
        
       NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO calculations (calc_id, calc_description, calc_rate, calc_tce, calc_vessel_nr, calc_port_ballast_from, calc_created, calc_last_modified, calc_ld_ports, calc_hfo_price, calc_do_price, calc_mgo_price, calc_lsfo_price, calc_address_commission, calc_broker_commission) VALUES (%@,'%@', %@, %@, %@,'%@','%s', '%s', '%@', %@, %@, %@, %@, %@, %@)", newCalcId, c.descr, c.rate,c.tce,c.vessel.nr,c.port_ballast_from.code, dateCreated.UTF8String, dateCreated.UTF8String,c.ld_ports, c.result.hfo_bunker.price, c.result.do_bunker.price, c.result.mgo_bunker.price, c.result.lsfo_bunker.price, c.result.address_commission_percent, c.result.broker_commission_percent];
        
        const char *insert_statement = [insertSQL UTF8String];
        sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to insert new calculation record inside entries table");
        } else {
            NSLog(@"inserted new calculation record inside players table!");
            c.id = newCalcId;
            c.lastmodified = c.created;
        }
        sqlite3_finalize(statement);
        
    }

    return c;
}

/* created 20160721 */
/* modified 20160802 */
-(calculationNSO *) updateCalculationData :(calculationNSO *) c {
    
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];

    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *lastmodified = [NSDate date];
        NSString *dateLastModified=[dateFormat stringFromDate:lastmodified];
        
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE calculations set calc_description = '%@', calc_rate = %@, calc_tce = %@, calc_vessel_nr=%@, calc_port_ballast_from='%@', calc_last_modified = '%s', calc_ld_ports = '%@', calc_hfo_price = %@, calc_do_price = %@, calc_mgo_price = %@, calc_lsfo_price = %@, calc_address_commission = %@, calc_broker_commission = %@ where calc_id=%@", c.descr, c.rate,c.tce,c.vessel.nr,c.port_ballast_from.code, dateLastModified.UTF8String, c.ld_ports, c.result.hfo_bunker.price, c.result.do_bunker.price, c.result.mgo_bunker.price, c.result.lsfo_bunker.price, c.result.address_commission_percent, c.result.broker_commission_percent, c.id ];
        
        const char *update_statement = [updateSQL UTF8String];
        sqlite3_prepare_v2(_DB, update_statement, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to update record(s) inside calculation table");
        } else {
            NSLog(@"Update to calculation table successful");
            // bring this last modified value back to the form.
            c.lastmodified = lastmodified;
        }
        sqlite3_finalize(statement);
        
        cargoNSO *l_port = [c.cargoios firstObject];
        
        
        updateSQL = [NSString stringWithFormat:@"UPDATE cargoio set cargoio_units=%@, cargoio_expense=%@, cargoio_estimated=%@, cargoio_terms_id=%@, cargoio_notice_time=%@, cargoio_type_id=%@,cargoio_purpose_code='L', cargoio_port_code='%@' where cargoio_calc_id=%@ and cargoio_id=1", l_port.units, l_port.expense, l_port.estimated, l_port.terms_id, l_port.notice_time, l_port.type_id, l_port.port.code, c.id];
        
        
        update_statement = [updateSQL UTF8String];
        sqlite3_prepare_v2(_DB, update_statement, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to update Load port record inside cargo table");
        } else {
            NSLog(@"Update of Load port to cargo table successful");
        }
        sqlite3_finalize(statement);

 
        cargoNSO *d_port = [c.cargoios lastObject];
        
        updateSQL = [NSString stringWithFormat:@"UPDATE cargoio set cargoio_units=%@, cargoio_expense=%@, cargoio_estimated=%@, cargoio_terms_id=%@, cargoio_notice_time=%@, cargoio_type_id=%@,cargoio_purpose_code='D', cargoio_port_code='%@' where cargoio_calc_id=%@ and cargoio_id=2", d_port.units, d_port.expense, d_port.estimated, d_port.terms_id, d_port.notice_time, d_port.type_id, d_port.port.code, c.id];
        
        update_statement = [updateSQL UTF8String];
        sqlite3_prepare_v2(_DB, update_statement, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to update Discharge port record inside cargo table");
        } else {
            NSLog(@"Update of Discharge port to cargo table successful");
        }
        sqlite3_finalize(statement);

        //sqlite3_close(_DB);
    }
    
    return c;
}


/* created 20160726 */
-(NSMutableArray*) getListing {
    NSMutableArray *listing = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        NSString *selectSQL = @"SELECT calculations.calc_id, calculations.calc_vessel_nr, '(' || vessels.vessel_ref_nr || ')' || vessels.vessel_name, calculations.calc_description, calculations.calc_last_modified, calculations.calc_ld_ports from calculations, vessels WHERE vessels.vessel_nr = calculations.calc_vessel_nr ORDER BY calc_id DESC";
        
        
        const char *select_statement = [selectSQL UTF8String];
        
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                listingItemNSO *l = [[listingItemNSO alloc] init];
                
                NSNumber *calcid = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                
                l.id = calcid;
                l.vessel_nr = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
                l.full_name_vessel = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] ;
                l.descr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                l.lastmodified = [dateFormat dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
                l.ld_ports = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] ;
               
                [listing addObject:l];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    } else {
        NSLog(@"Cannot open database");
    }
    
    return listing;
}


/* created 20160721 */
/* modified 20160726 */
-(NSMutableArray*) getCalculations :(NSMutableArray*) listing {
    
    NSMutableArray *calcs = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {

        NSString *result = [[listing valueForKey:@"id"] componentsJoinedByString:@","];
        
        NSString *selectSQL = [NSString stringWithFormat:@"SELECT calc_id, calc_vessel_nr, calc_description, calc_rate, calc_tce, calc_port_ballast_from, calc_created, calc_last_modified, calc_hfo_price, calc_do_price, calc_mgo_price, calc_lsfo_price, calc_address_commission, calc_broker_commission from calculations where calc_id IN (%@) ORDER BY calc_id DESC", result];
        
        
        const char *select_statement = [selectSQL UTF8String];
        
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                calculationNSO *c = [[calculationNSO alloc] init];
                
                NSNumber *calcid = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                
                c.id = calcid;
                c.vessel.nr = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
                c.descr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] ;
                c.rate = [NSNumber numberWithDouble:sqlite3_column_double(statement, 3)];
                c.tce = [NSNumber numberWithDouble:sqlite3_column_double(statement, 4)];
                c.port_ballast_from.code = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] ;
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                c.created = [dateFormat dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]];
                c.lastmodified = [dateFormat dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)]];
                
                c.result.hfo_bunker.price = [NSNumber numberWithDouble:sqlite3_column_double(statement, 8)];
                c.result.do_bunker.price = [NSNumber numberWithDouble:sqlite3_column_double(statement, 9)];
                c.result.mgo_bunker.price = [NSNumber numberWithDouble:sqlite3_column_double(statement, 10)];
                c.result.lsfo_bunker.price = [NSNumber numberWithDouble:sqlite3_column_double(statement, 11)];
                c.result.address_commission_percent = [NSNumber numberWithDouble:sqlite3_column_double(statement, 12)];
                c.result.broker_commission_percent = [NSNumber numberWithDouble:sqlite3_column_double(statement, 13)];
                
                c.vessel = [self getVesselByVesselNr :c.vessel.nr :c.vessel];
                c.port_ballast_from = [self getPortByPortCode :c.port_ballast_from.code :c.port_ballast_from];
                c.cargoios = [self getCargoes :c.id];
                
                [calcs addObject:c];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    } else {
        NSLog(@"Cannot open database");
    }
    
    return calcs;
}


/* created 20160725 */
-(NSMutableArray*) getCargoes :(NSNumber*) calc_id {
    NSMutableArray *cargoes = [[NSMutableArray alloc] init];
    
    //sql_statement = "CREATE TABLE cargoio(cargoio_id INTEGER PRIMARY KEY, cargoio_units INTEGER, cargoio_expense DECIMAL(8,2), cargoio_estimated DECIMAL(10,4), cargoio_terms_id INTEGER, cargoio_notice_time INTEGER, cargoio_type_id INTEGER, cargoio_purpose_code TEXT, cargoio_port_code TEXT, cargoio_calc_id INTEGER, FOREIGN KEY(cargoio_port_code) REFERENCES ports(port_code), FOREIGN KEY(cargoio_calc_id) REFERENCES calculations(calc_id))";
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        NSString *selectSQL = [NSString stringWithFormat:@"SELECT cargoio_id ,cargoio_units,cargoio_expense, cargoio_estimated, cargoio_terms_id, cargoio_notice_time, cargoio_type_id, cargoio_purpose_code, cargoio_port_code, cargoio_calc_id FROM cargoio WHERE cargoio_calc_id=%@ order by cargoio_id",calc_id];
        
        const char *select_statement = [selectSQL UTF8String];
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                cargoNSO *cargo = [[cargoNSO alloc] init];
                
                cargo.id = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                cargo.units = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
                cargo.expense = [NSNumber numberWithDouble:sqlite3_column_double(statement, 2)];
                cargo.estimated = [NSNumber numberWithDouble:sqlite3_column_double(statement, 3)];
                cargo.terms_id = [NSNumber numberWithInt:sqlite3_column_int(statement, 4)];
                cargo.notice_time = [NSNumber numberWithInt:sqlite3_column_int(statement, 5)];
                cargo.type_id = [NSNumber numberWithInt:sqlite3_column_int(statement, 6)];
                cargo.purpose_code = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] ;
                cargo.port.code = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)] ;
                cargo.calc_id = [NSNumber numberWithInt:sqlite3_column_int(statement, 8)];
                cargo.port = [self getPortByPortCode :cargo.port.code :cargo.port];
                
                [cargoes addObject:cargo];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    } else {
        NSLog(@"Cannot open database");
    }
    
    return cargoes;
    
}



/* created 20160721 */
/* modified 20160802 */

-(vesselNSO*) getVesselByVesselNr :(NSNumber*) vessel_nr :(vesselNSO*) v  {

    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        NSString *selectSQL = [NSString stringWithFormat:@"SELECT vessel_nr,vessel_ref_nr,vessel_name FROM vessels WHERE vessel_nr=%@",vessel_nr];
        
        const char *select_statement = [selectSQL UTF8String];
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                v.nr = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                v.ref_nr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] ;
                v.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] ;
            } else {
                 NSLog(@"cannot obtain vessel data");
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    } else {
        NSLog(@"Cannot open database");
    }

    v.ballast_cons = [self getConsumptionByVesselAndType:v.nr :[NSNumber numberWithInt:1]];
    v.laden_cons = [self getConsumptionByVesselAndType:v.nr :[NSNumber numberWithInt:2]];
    
    return v;
    
}


/* created 20160802 */
-(consumptionNSO*) getConsumptionByVesselAndType :(NSNumber*) vessel_nr :(NSNumber*) cons_type {
    
    consumptionNSO *cons = [[consumptionNSO alloc] init];
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        NSString *selectSQL = [NSString stringWithFormat:@"SELECT cons_speed, cons_hfo, cons_do, cons_mgo, cons_lsfo from consumptions WHERE cons_vessel_nr=%@ AND cons_type_id=%@",vessel_nr, cons_type];
        
        const char *select_statement = [selectSQL UTF8String];
    
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    cons.speed = [NSNumber numberWithFloat:sqlite3_column_double(statement, 0)];
                    cons.hfo_amt = [NSNumber numberWithFloat:sqlite3_column_double(statement, 1)];
                    cons.do_amt = [NSNumber numberWithFloat:sqlite3_column_double(statement, 2)];
                    cons.mgo_amt = [NSNumber numberWithFloat:sqlite3_column_double(statement, 3)];
                    cons.lsfo_amt = [NSNumber numberWithFloat:sqlite3_column_double(statement, 4)];
                } else {
                    NSLog(@"cannot obtain vessel data");
                }
            }
        sqlite3_finalize(statement);
    }
    return cons;
}






/* created 20160722 */
-(NSMutableArray*) getVessels {
    
    
    NSMutableArray *vessels = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        NSString *selectSQL = @"SELECT vessel_nr, vessel_ref_nr, vessel_name from vessels ORDER BY vessel_name DESC";
        
        
        const char *select_statement = [selectSQL UTF8String];
        
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                vesselNSO  *v = [[vesselNSO alloc] init];
               
                v.nr = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                v.ref_nr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] ;
                v.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] ;
                v.searchstring = v.getVesselFullName;
                [vessels addObject:v];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    } else {
        NSLog(@"Cannot open database");
    }
    
    return vessels;
}

/* created 20160722 */
-(portNSO*) getPortByPortCode :(NSString*) port_code :(portNSO*) p  {
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        NSString *selectSQL = [NSString stringWithFormat:@"SELECT port_code,port_abc_code,port_name FROM ports WHERE port_code='%@'",port_code];
        
        const char *select_statement = [selectSQL UTF8String];
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                p.code = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] ;
                p.abc_code = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] ;
                p.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] ;
            } else {
                NSLog(@"cannot obtain vessel data");
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    } else {
        NSLog(@"Cannot open database");
    }
    
    return p;
}

/* created 20160722 */
-(NSMutableArray*) getPorts {
    
    NSMutableArray *ports = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        NSString *selectSQL = @"SELECT port_code, port_abc_code, port_name from ports ORDER BY port_name DESC";
        
        const char *select_statement = [selectSQL UTF8String];
        
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                portNSO *p = [[portNSO alloc] init];
                
                p.code = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] ;
                p.abc_code = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] ;
                p.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] ;
                p.searchstring = p.getPortFullName;
                [ports addObject:p];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    } else {
        NSLog(@"Cannot open database");
    }
    
    return ports;
}





/* created 20160723 */
-(bool) deleteCalculation :(NSNumber *) calc_id {
    
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM calculations WHERE calc_id = %@", calc_id];
        
        const char *deleteStatement = [deleteSQL UTF8String];
        sqlite3_prepare_v2(_DB, deleteStatement, -1, &statement, NULL);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to delete record from table calculations");
            sqlite3_close(_DB);
            return false;
        } else {
            NSLog(@"Successfuly deleted record from table calculations");
        }
        
    }
    
    sqlite3_close(_DB);
    
    return true;
}


@end
