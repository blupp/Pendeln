//
//  Train.h
//  Pendeln
//
//  Created by Sebastian Björkelid on 2012-01-23.
//  Copyright (c) 2012 Bilddagboken AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Train : NSObject

@property (nonatomic,strong) NSString *fromStationName;
@property (nonatomic,strong) NSString *toStationName;
@property (nonatomic,strong) NSNumber *track;
@property (nonatomic,strong) NSNumber *trainNumber;
@property (nonatomic,strong) NSString *departureTime;
@property (nonatomic,strong) NSString *arrivalTime;
@property (nonatomic,strong) NSString *newdepartureTime;
@property (nonatomic) BOOL *direct;

/* 
 "trainNumber": "538",
 "trainType": "",
 "fromStationName": "Malmö C",
 "toStationName": "Stockholm C",
 "trainPosition":
 {
 "latitude": 58.417037,
 "longitude": 15.624342,
 "timestamp": "2011-09-28T17:52"
 },
 "stops":
*/

-(Train *)trainFromDictionary:(NSDictionary *)trainDictionary;

+(NSArray *)getTrainsFromLocation:(NSString *)location toDestination:(NSString *)destination withLimit:(NSInteger)limit;

@end
