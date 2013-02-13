//
//  SB-SJ-API.m
//  Pendeln
//
//  Created by Sebastian Björkelid on 2012-01-31.
//  Copyright (c) 2012 Bilddagboken AB. All rights reserved.
//

#import "SB-SJ-API.h"
#import "Settings.h"
#import "PendelnTableViewController.h"

@implementation SB_SJ_API {
    NSCache *stationsCache;
}

#define API_ENDPOINT    "http://sjmg.sj.se/api"


-(NSDictionary *)makeApiRequestToURL:(NSString *)apiResource {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    apiResource = [NSString stringWithFormat:@"http://tagtider:codemocracy@api.tagtider.net/v1%@", apiResource];
    NSLog(apiResource);
    
    NSURL *url = [NSURL URLWithString:apiResource];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSError *error = [[NSError alloc] init];
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    //NSLog([jsonData debugDescription]);
    return jsonData;
}

#pragma SJ API CORE

-(NSArray *)getStations {
    
    /*if(!stationsCache) {
        stationsCache = [[NSCache alloc] init];
    }*/
    
    NSArray *stations;
    NSError *error = [[NSError alloc] init];
    
    NSData *jsonData = [NSData dataWithContentsOfFile:@"/tmp/stations"];
    if(jsonData) {
        stations = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    }
    
    //NSArray *stations;
    //stations = [stationsCache objectForKey:@"stations"];
    
    if(!stations) {
        NSString *urlString = @"/stations.json";
        NSDictionary *stationsData = [self makeApiRequestToURL:urlString];
        stations = [[stationsData objectForKey:@"stations"] objectForKey:@"station"];
        
        //[stationsCache setObject:stations forKey:@"stations"];
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:stations options:0 error:&error];
        [data writeToFile:@"/tmp/stations" atomically:YES];
    } else {
        NSLog(@"Using cached stations.json");
    }
    
    
    return stations;
}

-(NSDictionary *)getStation:(int)stationid {
    NSString *urlString = [NSString stringWithFormat:@"/stations/%d/transfers/departures.json",stationid];
    
    NSDictionary *station = [self makeApiRequestToURL:urlString];
    
    //NSLog(station.description);
        
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
    //NSLog(stations.description);
    
    for(NSDictionary *station in stations) {
        
        if ([[station objectForKey:@"name"] rangeOfString:stationName].location != NSNotFound) {
            int stationid = [[station objectForKey:@"id"] intValue];
            return [self getStation:stationid];
        }
    }
    
    return false;
}

-(NSArray *)getTrainsDepartingFrom:(NSString *)departingStationName arrivingAt:(NSString *)arrivingStationName {
    NSMutableArray *trains = [[NSMutableArray alloc] init];
    
    NSDictionary *departingStation = [self getStationWithName:departingStationName];
    
    //NSLog(departingStation.description);
    
    NSArray *arrivals = [[[departingStation objectForKey:@"station"] objectForKey:@"transfers"] objectForKey:@"transfer"];
    
    //NSLog([[departingStation objectForKey:@"station"] description]);
        
    // loop through the trains departing from departingStationName
    for(NSMutableDictionary *arrival in arrivals) {
        //NSLog(arrival.description);
        /*if([[arrival objectForKey:@"type"] rangeOfString:@"SJ Regional"].location == NSNotFound
           && [[arrival objectForKey:@"type"] rangeOfString:@"SJ InterCity"].location == NSNotFound) {
            //NSLog([arrival objectForKey:@"type"]);
            continue;
        }*/
        
        // look for trains that stops at arrivingStationName
        if ([[arrival objectForKey:@"destination"] rangeOfString:arrivingStationName].location != NSNotFound) {
            [trains addObject:arrival];
        }
        
        /*NSArray *stationNames = [arrival objectForKey:@"stationNames"];
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
        }*/
    }
    
    return [NSArray arrayWithArray:trains];
}

-(NSString *)formatDateFrom:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:dateString];
    
    [formatter setDateFormat:@"HH:mm"];
    
    //NSLog([formatter stringFromDate:date]);
        
    return [formatter stringFromDate:date];
}

-(NSString *)timeLeftFrom:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:dateString];
    
    NSTimeInterval interval = [date timeIntervalSinceNow];
    
    int minutesLeft = (int)interval/60;
    
    if(minutesLeft < 0) {
        minutesLeft = 0;
    }
    
    return [NSString stringWithFormat:@"%i min", minutesLeft];
}

-(NSString *)trimStationName:(NSString *)stationName {
    NSString *trimmedString=[stationName substringFromIndex:[stationName length]-2];
    if([trimmedString isEqualToString:@" C"]) {
        stationName = [stationName substringToIndex:[stationName length]-2];
    }
    
    return stationName;
}

@end












