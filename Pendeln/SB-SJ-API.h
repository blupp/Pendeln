//
//  SB-SJ-API.h
//  Pendeln
//
//  Created by Sebastian Björkelid on 2012-01-31.
//  Copyright (c) 2012 Bilddagboken AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Station.h"
#import "Train.h"

@interface SB_SJ_API : NSObject


// SJ API
-(id)makeApiRequestToURL:(NSString *)urlString;

-(NSArray *)getStations;

-(Station *)getStation:(int)stationid;

-(Train *)getTrain:(int)trainNumber;

// PENDELN API
-(Station *)getStationWithName:(NSString *)stationName;

-(NSArray *)getTrainsDepartingFrom:(Station *)departingStation arrivingAt:(Station *)arrivingStation;

@end
