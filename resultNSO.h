//
//  resultNSO.h
//  RoastChicken
//
//  Created by andrew glew on 02/08/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bunkerNSO.h"
#import "timeNSO.h"
#import "portNSO.h"
#import "cargoNSO.h"
#import "AppDelegate.h"

@class calculationNSO;

@interface resultNSO : NSObject

@property (nonatomic) NSNumber *address_commission_percent;
@property (nonatomic) NSNumber *broker_commission_percent;
@property (nonatomic) NSNumber *address_commission_amt;
@property (nonatomic) NSNumber *broker_commission_amt;
@property (nonatomic) NSNumber *additonal_expense_amt;
@property (strong, nonatomic) bunkerNSO *hfo_bunker;
@property (strong, nonatomic) bunkerNSO *do_bunker;
@property (strong, nonatomic) bunkerNSO *mgo_bunker;
@property (strong, nonatomic) bunkerNSO *lsfo_bunker;
@property (nonatomic) NSNumber *additonal_minutes_sailing_ballasted;
@property (nonatomic) NSNumber *additonal_minutes_sailing_laden;
@property (nonatomic) NSNumber *additonal_minutes_sailing_idle;
@property (nonatomic) NSNumber *minutes_sailing_laden;
@property (nonatomic) NSNumber *minutes_sailing_ballasted;
@property (nonatomic) NSNumber *minutes_total;
@property (nonatomic) NSNumber *loading_atport_minutes;
@property (nonatomic) NSNumber *discharging_atport_minutes;
@property (nonatomic) NSNumber *minutes_in_port;
@property (nonatomic) NSNumber *miles_sailing_laden;
@property (nonatomic) NSNumber *miles_sailing_ballasted;
@property (nonatomic) NSNumber *gross_freight;
@property (nonatomic) NSNumber *gross_day;
@property (nonatomic) NSNumber *minutes_notice_time;
@property (nonatomic) NSNumber *total_costs;
@property (nonatomic) NSNumber *total_expenses;
@property (nonatomic) NSNumber *net_result;
@property (nonatomic) NSNumber *net_day;
@property (nonatomic) NSNumber *tc_eqv;
@property (nonatomic) NSNumber *total_units;
@property (nonatomic) NSNumber *total_port_expenses;
@property (nonatomic) NSDictionary *routing;
@property (nonatomic) NSString *voyagestring;
@property (nonatomic) UIImage *mapImage;


-(id) copyWithZone: (NSZone *) zone;
-(void) setRouteData :(NSString*) voyagequerystring :(calculationNSO*) calculation :(UILabel*) status :(UIActivityIndicatorView*) atobviacActivity :(UIButton*) calculateButton;
-(void) setMapData :(NSString*) voyagequerystring :(calculationNSO*) calculation :(UILabel*) status :(UIActivityIndicatorView*) atobviacActivity :(UIButton*) calculateButton :(UIImageView*) map  :(UIButton*) mapDetailButton;
-(bool) setRateData :(NSNumber*)rate :(bool) useLocalFlatrate :(NSNumber*) flatRate :(NSNumber*) rateType;
-(bool) setCommissionAmts;
-(bool) setAtPortMinutes :(cargoNSO*) cargo;
-(NSNumber*) getMinutesInPortTotal;
-(NSNumber*) getTcEqv;
-(void) setSailingData :(calculationNSO*) calculation;
-(void) setAtPortData :(calculationNSO*) calculation;


@end
