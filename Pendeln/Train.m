//
//  Train.m
//  Pendeln
//
//  Created by Sebastian Björkelid on 2012-01-23.
//  Copyright (c) 2012 Bilddagboken AB. All rights reserved.
//

#import "Train.h"

@implementation Train

@synthesize destination,track,trainNumber,departure,arrival,newdeparture,direct;

+(NSString *)filterDepartureString:(NSString *)departure {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@" ([0-9]+:[0-9]+)" options:0 error:NULL];
    NSTextCheckingResult *match = [regex firstMatchInString:departure options:0 range:NSMakeRange(0, [departure length])];
    departure = [departure substringWithRange:[match rangeAtIndex:1]];
    
    return departure;
}

+(NSArray *)fetchTrainDataForLocation:(NSString *)location {
    
    // Fetch data based on location
    NSString *urlString = @"http://tagtider:codemocracy@api.tagtider.net/v1/stations/290/transfers/departures.json";
    NSURL *url = [NSURL URLWithString:urlString];
    
    // get data from API
    NSData *jsonData = [NSData dataWithContentsOfURL:url];

    NSError *error = [[NSError alloc] init];
    NSDictionary *trainData;
    if(jsonData) {
        // parse JSON response
        trainData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Anslutingsfel" message:@"Kunde inte ansluta till tagtider.net" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        return false;
    }
    
    if(error.code) {
        // Connection error
        return false;
    }
    
    NSDictionary *station = [trainData objectForKey:@"station"];
    NSArray *trains = [[station objectForKey:@"transfers"] objectForKey:@"transfer"];
    NSMutableArray *filteredTrains = [[NSMutableArray alloc] init];
    
    // filter list based on location
    for (NSDictionary *train in trains) {        
        NSString *destination = [train objectForKey:@"destination"];
        
        if ([destination rangeOfString:@"Stockholm"].location != NSNotFound) {
            // target match destination
            
            // make train-data more readable
            NSString *departure = [self filterDepartureString:[train objectForKey:@"departure"]];
            
            Train *realTrain = [[Train alloc] init];
            realTrain.destination = destination;
            realTrain.departure = departure;
            
            [filteredTrains addObject:realTrain];
        }
    }    
    
    //NSLog(@"-----------------------------------");
    //NSLog(@"%@",trains);
    //NSLog(@"-----------------------------------");
    
    return [NSArray arrayWithArray:filteredTrains];
}

+(NSArray *)getTrainsForLocation:(NSString *)location withLimit:(NSInteger)limit {
    
    NSArray *trains = [Train fetchTrainDataForLocation:location];
    
    return trains;
}

@end
