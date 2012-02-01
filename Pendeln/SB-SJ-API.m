//
//  SB-SJ-API.m
//  Pendeln
//
//  Created by Sebastian Björkelid on 2012-01-31.
//  Copyright (c) 2012 Bilddagboken AB. All rights reserved.
//

#import "SB-SJ-API.h"

@implementation SB_SJ_API

#define API_ENDPOINT    "http://sjmg.sj.se/api/"

-(NSDictionary *)makeApiRequestToURL:(NSString *)urlString {
    urlString = [NSString stringWithFormat:@"%@%@",API_ENDPOINT,urlString];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // get data from API
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    NSError *error;
    NSDictionary *data;
    if(jsonData) {
        // parse JSON response
        error = [[NSError alloc] init];
        data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Anslutingsfel" message:@"Kunde inte ansluta till SJ" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        return false;
    }
    
    if(error.code) {
        // Connection error
        return false;
    }
    
    return data;
}

#pragma SJ API CORE

-(NSDictionary *)getStations {
    NSString *urlString = @"/stations.json";
    
    NSDictionary *stations = [self makeApiRequestToURL:urlString];
    
    return stations;
}

-(Station *)getStation:(int)stationid {
    NSString *urlString = [NSString stringWithFormat:@"/stationTimeTable/%d.json",stationid];
    
    NSDictionary *stationData = [self makeApiRequestToURL:urlString];
    
    Station *station = [station stationFromDictionary:stationData];
    
    return station;
}

-(Train *)getTrain:(int)trainNumber {
    NSString *urlString = [NSString stringWithFormat:@"/trainTimeTable/%d.json",trainNumber];

    NSDictionary *trainData = [self makeApiRequestToURL:urlString];

    Train *train = [train trainFromDictionary:trainData];

    return train;
}

#pragma FUNCTIONS

-(Station *)getStationWithName:(NSString *)stationName {
    NSDictionary *stations = [self getStations];
}

-(NSArray *)getTrainsDepartingFrom:(Station *)departingStation arrivingAt:(Station *)arrivingStation {
    
}

@end
