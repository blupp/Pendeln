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


-(NSDictionary *)makeApiRequestToURL:(NSString *)apiResource {
    
    apiResource = [NSString stringWithFormat:@"http://tagtider:codemocracy@api.tagtider.net/v1%@", apiResource];
    NSLog(apiResource);
    
    NSURL *url = [NSURL URLWithString:apiResource];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSError *error = [[NSError alloc] init];
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    //NSLog([jsonData debugDescription]);
    return jsonData;
}

#pragma SJ API CORE

-(NSArray *)getStations {
    NSString *urlString = @"/stations.json";
    
    NSDictionary *stationsData = [self makeApiRequestToURL:urlString];
    //NSLog([stationsData description]);
    NSArray *stations = [[stationsData objectForKey:@"stations"] objectForKey:@"station"];
    
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

@end



/*urlString = [NSString stringWithFormat:@"http://sjmg.sj.se/api%@",urlString];
 //urlString = [NSString stringWithFormat:@"http://localhost%@",urlString];
 //    NSURL *url = [NSURL URLWithString:urlString];
 //
 //    // get data from API
 //    NSData *jsonData = [NSData dataWithContentsOfURL:url];
 
 //SBJsonParser *parser = [[SBJsonParser alloc] init];
 //NSString *jsonRequestString = [parser stringWithObject:dictionaryUser];
 //NSData *requestData = [jsonRequestString dataUsingEncoding:NSUTF8StringEncoding];
 //NSString *requestUrl = @"http://www.shapeupclub.com/PaymentService.svc/upgradeAccountMobile";
 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: urlString]];
 [request setHTTPMethod: @"GET"];
 [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
 //[request setHTTPBody: requestData];
 [request setTimeoutInterval:30];
 
 NSError *requestError = nil;
 NSData *jsonData = [ NSURLConnection sendSynchronousRequest: request
 returningResponse: nil error:&requestError ];
 
 NSError *error;
 NSDictionary *data;
 if(jsonData) {
 // parse JSON response
 error = [[NSError alloc] init];
 data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
 NSLog(urlString);
 NSLog(data.debugDescription);
 } else {
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Anslutingsfel" message:@"Kunde inte ansluta till SJ" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
 [alertView show];
 return false;
 }
 
 if(error.code) {
 // Connection error
 NSLog(@"Error: %@",error.description);
 return false;
 }*/














