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
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@" ([0-9]+:[0-9]+)" options:0 error:NULL];
            NSString *str = [train objectForKey:@"departure"];
            NSTextCheckingResult *match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
            str = [str substringWithRange:[match rangeAtIndex:1]];
            
            //[train removeObjectForKey:@"departure"];
            //[train setObject:str forKey:@"departure"];
            
            [filteredTrains addObject:[NSDictionary dictionaryWithDictionary:train]];
        }
    }    
    
    //NSLog(@"-----------------------------------");
    //NSLog(@"%@",trains);
    //NSLog(@"-----------------------------------");
    
    return [NSArray arrayWithArray:filteredTrains];
}

+(NSArray *)getTrainsForLocation:(NSString *)location withLimit:(NSInteger)limit {
    
    NSArray *trains = [Train fetchTrainDataForLocation:location];
    
    Train *t1 = [[Train alloc] init];
    t1.destination = @"abc";
    t1.track = [NSNumber numberWithInt:3];
    t1.trainNumber = [NSNumber numberWithInt:543];
    t1.departure = @"11:01";
    
    //NSArray *trains = [NSArray arrayWithObject:t1];
    
    return trains;
}

@end
