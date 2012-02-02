//
//  Station.m
//  Pendeln
//
//  Created by Sebastian Björkelid on 2012-01-26.
//  Copyright (c) 2012 Bilddagboken AB. All rights reserved.
//

#import "Station.h"

@implementation Station

@synthesize name,stationid; //,lat,lng;

-(Station *)stationFromDictionary:(NSDictionary *)stationDictionary {
    Station *station = [[Station alloc] init];
    
    station.stationid = [stationDictionary objectForKey:@"id"];
    station.name = [stationDictionary objectForKey:@"stationName"];
    
    return station;
}

@end
