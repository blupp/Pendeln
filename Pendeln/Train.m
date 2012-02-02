//
//  Train.m
//  Pendeln
//
//  Created by Sebastian Björkelid on 2012-01-23.
//  Copyright (c) 2012 Bilddagboken AB. All rights reserved.
//

#import "Train.h"

@implementation Train

@synthesize fromStationName,toStationName,track,trainNumber,departureTime,arrivalTime,newdepartureTime,direct;

-(Train *)trainFromDictionary:(NSDictionary *)trainDictionary {
    Train *train = [[Train alloc] init];
    
    train.trainNumber = [trainDictionary objectForKey:@"trainNumber"];
    train.fromStationName = [trainDictionary objectForKey:@"fromStationName"];
    train.toStationName = [trainDictionary objectForKey:@"toStationName"];
    //train.stops = [trainDictionary objectForKey:@"toStationName"];
    
    return train;
}


// GAMMALT ==================================================
// GAMMALT ==================================================
// GAMMALT ==================================================
// GAMMALT ==================================================

+(NSString *)filterDepartureString:(NSString *)departure {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@" ([0-9]+:[0-9]+)" options:0 error:NULL];
    NSTextCheckingResult *match = [regex firstMatchInString:departure options:0 range:NSMakeRange(0, [departure length])];
    departure = [departure substringWithRange:[match rangeAtIndex:1]];
    
    return departure;
}

+(NSNumber *)getStationId:(NSString *)fromLocation {
    if([fromLocation isEqualToString:@"Uppsala"]) {
        return [NSNumber numberWithInt:290];
    } else if([fromLocation isEqualToString:@"Stockholm"]) {
//TODO: check real station id for Stockholm
        return [NSNumber numberWithInt:280];
    } else {
        // default: Uppsala
        return [NSNumber numberWithInt:290];
    }
}

+(NSDictionary *)fetchTrainDataForLocation:(NSString *)location {
    
    // Fetch data based on location
    NSString *urlString = [NSString stringWithFormat:@"http://tagtider:codemocracy@api.tagtider.net/v1/stations/%d/transfers/departures.json",[[self getStationId:location] intValue]];
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
    
    //NSLog(@"-----------------------------------");
    //NSLog(@"%@",trains);
    //NSLog(@"-----------------------------------");
    
    return trainData;
}

+(NSArray *)getTrainsFromLocation:(NSString *)location toDestination:(NSString *)destination withLimit:(NSInteger)limit {
    
    NSDictionary *trainData = [Train fetchTrainDataForLocation:location];
    
    NSDictionary *station = [trainData objectForKey:@"station"];
    NSArray *trains = [[station objectForKey:@"transfers"] objectForKey:@"transfer"];
    NSMutableArray *filteredTrains = [[NSMutableArray alloc] init];
    
    // filter list based on destination
    int i = 0;
    for (NSDictionary *train in trains) {        
        NSString *destination = [train objectForKey:@"destination"];
        
        if ([destination rangeOfString:@"Stockholm"].location != NSNotFound) {
            // target match destination
            
            // make train-data more readable
            NSString *departure = [self filterDepartureString:[train objectForKey:@"departure"]];
            
            Train *realTrain = [[Train alloc] init];
            realTrain.toStationName = destination;
            realTrain.departureTime = departure;
            
            if(i < limit) {
                [filteredTrains addObject:realTrain];
                i++;
            }
        }
    } 
    
    return [NSArray arrayWithArray:filteredTrains];
}

@end
