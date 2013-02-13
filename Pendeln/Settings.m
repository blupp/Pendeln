//
//  Settings.m
//  Pendeln
//
//  Created by Sebastian Björkelid on 2012-02-03.
//  Copyright (c) 2012 Bilddagboken AB. All rights reserved.
//

#import "Settings.h"
#import "SB-SJ-API.h"

@implementation Settings

@synthesize homeStation = _homeStation;
@synthesize jobStation = _jobStation;
@synthesize firstSelected = _firstSelected;
@synthesize stations = _stations;

@synthesize defaults = _defaults;
@synthesize api = _api;




-(Settings *) init {
    self = [super init];
    
    self.defaults = [[NSUserDefaults alloc] init];
    self.api = [[SB_SJ_API alloc] init];
    
    return self;
}

-(void)setHomeStation:(NSString *)homeStation {
    
    homeStation = [self.api trimStationName: homeStation];
    
    _homeStation = homeStation;
    
    [self.defaults setObject:homeStation forKey:@"homeStation"];
    [self.defaults synchronize];
}

-(NSString *)homeStation {
    if(_homeStation) {
        return _homeStation;
    }
    
    _homeStation = [self.defaults objectForKey:@"homeStation"];
    
    if(!_homeStation) {
        _homeStation = @"Uppsala";
    }
    
    return _homeStation;
}

-(void)setJobStation:(NSString *)jobStation {
    
    jobStation = [self.api trimStationName:jobStation];
    
    _jobStation = jobStation;
    
    [self.defaults setObject:jobStation forKey:@"jobStation"];
    [self.defaults synchronize];
}

-(NSString *)jobStation {
    if(_jobStation) {
        return _jobStation;
    }
    
    _jobStation = [self.defaults objectForKey:@"jobStation"];
    
    if(!_jobStation) {
        _jobStation = @"Stockholm";
    }
    
    return _jobStation;
}

-(void)setStations:(NSArray *)stations {
    NSLog(@"SET STATIONS");
    
    stations = [NSArray arrayWithObject:[stations objectAtIndex:34]];
    
    _stations = stations;
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    [defaults setObject:stations forKey:@"stations"];
    [defaults synchronize];
}

-(void)setFirstSelected:(NSNumber *)firstSelected {
    _firstSelected = firstSelected;
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    [defaults setObject: firstSelected forKey:@"firstSelected"];
    [defaults synchronize];
}

-(NSNumber *)firstSelected {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    
    NSNumber *firstSelected = [defaults objectForKey:@"firstSelected"];
    if(!firstSelected) {
        firstSelected = [NSNumber numberWithInt:1];
    }
    
    return firstSelected;
}

-(NSArray *)stations {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    
    NSArray *stations = [defaults objectForKey:@"stations"];
    
    return stations;
}

+(id)SharedSettings {
    static Settings *sharedSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSettings = [[self alloc] init];
    });
    return sharedSettings;
}

@end
