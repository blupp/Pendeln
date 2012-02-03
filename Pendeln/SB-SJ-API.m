//
//  SB-SJ-API.m
//  Pendeln
//
//  Created by Sebastian Björkelid on 2012-01-31.
//  Copyright (c) 2012 Bilddagboken AB. All rights reserved.
//

#import "SB-SJ-API.h"

@implementation SB_SJ_API

#define API_ENDPOINT    "http://sjmg.sj.se/api"

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

-(NSArray *)getStations {
    NSString *urlString = @"/stations.json";
    
    NSDictionary *stationsData = [self makeApiRequestToURL:urlString];
    NSArray *stations = [stationsData objectForKey:@"stations"];
    
    return stations;
}

-(NSDictionary *)getStation:(int)stationid {
    NSString *urlString = [NSString stringWithFormat:@"/stationTimeTable/%d.json",stationid];
    
    NSDictionary *station = [self makeApiRequestToURL:urlString];
        
    return station;
}

-(NSDictionary *)getTrain:(int)trainNumber {
    NSString *urlString = [NSString stringWithFormat:@"/trainTimeTable/%d.json",trainNumber];

    NSDictionary *train = [self makeApiRequestToURL:urlString];

    return train;
}

#pragma FUNCTIONS

-(NSDictionary *)getStationWithName:(NSString *)stationName {
    NSArray *stations = [self getStations];
    
    for(NSDictionary *station in stations) {
        
        if ([[station objectForKey:@"stationName"] rangeOfString:stationName].location != NSNotFound) {
            return station;
        }
    }
    
    return false;
}

-(NSArray *)getTrainsDepartingFrom:(NSString *)departingStationName arrivingAt:(NSString *)arrivingStationName {
    NSMutableArray *trains = [[NSMutableArray alloc] init];
    
    NSDictionary *departingStation = [self getStationWithName:departingStationName];

    NSArray *arrivals = [departingStation objectForKey:@"arrivals"];
    
    // loop through the trains departing from departingStationName
    for(NSMutableDictionary *arrival in arrivals) {
        
        // look for trains that stops at arrivingStationName
        NSArray *stationNames = [arrival objectForKey:@"stationNames"];
        for(NSString *stationName in stationNames) {
            if ([stationName rangeOfString:arrivingStationName].location != NSNotFound) {
                // found train!
                
                // check if it is a direct train
                if([stationNames count] == 1) {
                    [arrival setObject:[NSNumber numberWithInt:1] forKey:@"directTrain"];
                }
                
                // add train to return array
                [trains addObject:arrival];
            }
        }
    }
    
    return [NSArray arrayWithArray:trains];
}

@end


















