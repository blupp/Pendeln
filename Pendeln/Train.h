//
//  Train.h
//  Pendeln
//
//  Created by Sebastian Björkelid on 2012-01-23.
//  Copyright (c) 2012 Bilddagboken AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Train : NSObject

@property (nonatomic,strong) NSString *destination;
@property (nonatomic,strong) NSNumber *track;
@property (nonatomic,strong) NSNumber *trainNumber;
@property (nonatomic,strong) NSString *departure;
@property (nonatomic,strong) NSString *arrival;
@property (nonatomic,strong) NSString *newdeparture;
@property (nonatomic) BOOL *direct;

+(NSArray *)getTrainsForLocation:(NSString *)location withLimit:(NSInteger)limit;


@end
