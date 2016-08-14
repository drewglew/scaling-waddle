//
//  dbManager.m
//  RoastChicken
//
//  Created by andrew glew on 28/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "dbManager.h"

@implementation dbManager


+(dbManager*)shareDBManager{
    
    static dbManager *sharedInstance=nil;
    static dispatch_once_t  oncePredecate;
    
    dispatch_once(&oncePredecate,^{
        sharedInstance=[[dbManager alloc] init];
        
    });
    return sharedInstance;
}


/* created 20160811 */
-(bool)dbInit :(NSString*) databaseName {
    NSString *docsDir;
    NSArray *dirPaths;
    
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];

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
            
            sql_statement = "CREATE TABLE calculations(calc_id INTEGER PRIMARY KEY, calc_vessel_nr INTEGER, calc_description TEXT, calc_rate DECIMAL(10, 5), calc_flatrate DECIMAL(10, 5), calc_tce DECIMAL(10, 5), calc_port_ballast_from TEXT, calc_created DATETIME, calc_last_modified DATETIME, calc_ld_ports TEXT, calc_hfo_price DECIMAL(10, 2), calc_do_price DECIMAL(10, 2), calc_mgo_price DECIMAL(10, 2), calc_lsfo_price DECIMAL(10, 2), calc_address_commission DECIMAL(10, 2), calc_broker_commission DECIMAL(10, 2), calc_add_idle_days INTEGER, calc_add_ballasted_days INTEGER, calc_add_laden_days INTEGER, calc_add_expenses INTEGER, calc_add_hfo INTEGER, calc_add_do INTEGER, calc_add_mgo INTEGER, calc_add_lsfo INTEGER, calc_voyagestring TEXT, calc_miles_ball DECIMAL(12, 4), calc_miles_laden DECIMAL(12, 4), FOREIGN KEY(calc_vessel_nr) REFERENCES vessels(vessel_nr), FOREIGN KEY(calc_port_ballast_from) REFERENCES ports(port_code) )";
            
            
            
            if(sqlite3_exec(_DB, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK) {
                NSLog(@"failed to create calculations table");
                sqlite3_close(_DB);
                return false;
            }
            
            /* number 4: cargo in/out  */
            sql_statement = "CREATE TABLE cargoio(cargoio_id INTEGER, cargoio_units INTEGER, cargoio_expense DECIMAL(8,2), cargoio_estimated DECIMAL(10,4), cargoio_notice_time INTEGER, cargoio_type_id INTEGER, cargoio_purpose_code TEXT, cargoio_port_code TEXT, cargoio_calc_id INTEGER, FOREIGN KEY(cargoio_port_code) REFERENCES ports(port_code), FOREIGN KEY(cargoio_calc_id) REFERENCES calculations(calc_id), PRIMARY KEY (cargoio_id, cargoio_calc_id))";
            if(sqlite3_exec(_DB, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK) {
                NSLog(@"failed to create table cargoio");
                sqlite3_close(_DB);
                return false;
            } else {
                NSLog(@"Whoopee successful in creating table cargioio");
            }
            
            
            /* number 5: consumptions  */
            sql_statement = "CREATE TABLE consumptions(cons_id INTEGER PRIMARY KEY, cons_vessel_nr INTEGER, cons_type_id INTEGER, cons_zone_id INTEGER, cons_speed DECIMAL(8, 2), cons_hfo DECIMAL(8, 2), cons_do DECIMAL(8,2), cons_mgo DECIMAL(8,2), cons_lsfo DECIMAL(8,2), FOREIGN KEY(cons_vessel_nr) REFERENCES vessels(vessel_nr))";
            if(sqlite3_exec(_DB, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK) {
                NSLog(@"failed to create table consumptions");
                sqlite3_close(_DB);
                return false;
            } else {
                NSLog(@"Whoopee successful in creating table consumptions");
            }
            
            /* number 5: worldscales  */
            sql_statement = "CREATE TABLE worldscales(ws_id INTEGER PRIMARY KEY, ws_portcombo TEXT, ws_rate DECIMAL(8, 2))";
            if(sqlite3_exec(_DB, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK) {
                NSLog(@"failed to create table worldscales");
                sqlite3_close(_DB);
                return false;
            } else {
                NSLog(@"Whoopee successful in creating table worldscales");
            }
            
            /* number 5: worldscales index  */
            sql_statement = "CREATE UNIQUE INDEX idx_portcombo ON worldscales (ws_portcombo);";
            if(sqlite3_exec(_DB, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK) {
                NSLog(@"failed to create index idx_portcomboon worldscales");
                sqlite3_close(_DB);
                return false;
            } else {
                NSLog(@"Whoopee successful in creating index idx_portcombo on worldscales");
            }
            
            sqlite3_close(_DB);
        } else {
            NSLog(@"failed to create table");
            return false;
        }
    }
    return true;
}

-(void) deleteDB :(NSString*) databaseName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath =  [documentsDirectory stringByAppendingPathComponent:databaseName];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}


-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable{
    // Create a sqlite object.
    
    // Set the database file path.
       // Initialize the results array.
    if (self.arrResults != nil) {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    self.arrResults = [[NSMutableArray alloc] init];
    
    // Initialize the column names array.
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    
    // Open the database.
    BOOL openDatabaseResult = sqlite3_open([_databasePath UTF8String], &_DB);
    if(openDatabaseResult == SQLITE_OK) {
        // Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement.
        sqlite3_stmt *compiledStatement;
        
        // Load all data from database to memory.
        BOOL prepareStatementResult = sqlite3_prepare_v2(_DB, query, -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK) {
            // Check if the query is non-executable.
            if (!queryExecutable){
                // In this case data must be loaded from the database.
                
                // Declare an array to keep the data for each fetched row.
                NSMutableArray *arrDataRow;
                
                // Loop through the results and add them to the results array row by row.
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    // Initialize the mutable array that will contain the data of a fetched row.
                    arrDataRow = [[NSMutableArray alloc] init];
                    
                    // Get the total number of columns.
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    // Go through all columns and fetch each column data.
                    for (int i=0; i<totalColumns; i++){
                        // Convert the column data to text (characters).
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        // If there are contents in the currenct column (field) then add them to the current row array.
                        if (dbDataAsChars != NULL) {
                            // Convert the characters to string.
                            [arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        // Keep the current column name.
                        if (self.arrColumnNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    
                    // Store each fetched data row in the results array, but first check if there is actually data.
                    if (arrDataRow.count > 0) {
                        [self.arrResults addObject:arrDataRow];
                    }
                }
            }
            else {
                // This is the case of an executable query (insert, update, ...).
                
                // Execute the query.
                if (sqlite3_step(compiledStatement) == SQLITE_DONE) {
                    // Keep the affected rows.
                    self.affectedRows = sqlite3_changes(_DB);
                    
                    // Keep the last inserted row ID.
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(_DB);
                }
                else {
                    // If could not execute the query show the error message on the debugger.
                    NSLog(@"DB Error: %s", sqlite3_errmsg(_DB));
                }
            }
        }
        else {
            // In the database cannot be opened then show the error message on the debugger.
            NSLog(@"%s", sqlite3_errmsg(_DB));
        }
        
        // Release the compiled statement from memory.
        sqlite3_finalize(compiledStatement);
        
    }
    
    // Close the database.
    sqlite3_close(_DB);
}

-(NSArray *)loadDataFromDB:(NSString *)query{
    // Run the query and indicate that is not executable.
    // The query string is converted to a char* object.
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    // Returned the loaded results.
    return (NSArray *)self.arrResults;
}

-(void)executeQuery:(NSString *)query{
    // Run the query and indicate that is executable.
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}



@end
