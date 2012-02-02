//
//  Station.h
//  Pendeln
//
//  Created by Sebastian Björkelid on 2012-01-26.
//  Copyright (c) 2012 Bilddagboken AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Station : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSNumber *stationid;
//@property (nonatomic,strong) NSNumber *lat;
//@property (nonatomic,strong) NSNumber *lng;

-(Station *)stationFromDictionary:(NSDictionary *)stationDictionary;

@end
