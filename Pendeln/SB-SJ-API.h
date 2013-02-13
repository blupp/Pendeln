//
//  SB-SJ-API.h
//  Pendeln
//
//  Created by Sebastian Björkelid on 2012-01-31.
//  Copyright (c) 2012 Bilddagboken AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SB_SJ_API : NSObject


// SJ API
-(NSDictionary *)makeApiRequestToURL:(NSString *)urlString;

-(NSArray *)getStations;

-(NSDictionary *)getStation:(int)stationid;

-(NSDictionary *)getTrain:(int)trainNumber;

// PENDELN API
-(NSDictionary *)getStationWithName:(NSString *)stationName;

-(NSArray *)getTrainsDepartingFrom:(NSString *)departingStationName arrivingAt:(NSString *)arrivingStationName;

-(NSString *)formatDateFrom:(NSString *)dateString;

-(NSString *)timeLeftFrom:(NSString *)dateString;

-(NSString *)trimStationName:(NSString *)stationName;


@end
