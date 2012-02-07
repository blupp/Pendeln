//
//  Settings.m
//  Pendeln
//
//  Created by Sebastian Björkelid on 2012-02-03.
//  Copyright (c) 2012 Bilddagboken AB. All rights reserved.
//

#import "Settings.h"

@implementation Settings

@synthesize firstStationName = _firstStationName;
@synthesize secondStationName = _secondStationName;
@synthesize firstSelected = _firstSelected;

-(Settings *) initWithSavedSettings {
    self = [super init];
    
    self.firstStationName = [self firstStationName];
    self.secondStationName = [self secondStationName];
    self.firstSelected = [self firstSelected];
    
    return self;
}

-(void)setFirstStationName:(NSString *)firstStationName {
    _firstStationName = firstStationName;
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    [defaults setObject:firstStationName forKey:@"firstStationName"];
    [defaults synchronize];
}

-(void)setSecondStationName:(NSString *)secondStationName {
    _secondStationName = secondStationName;
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    [defaults setObject:secondStationName forKey:@"secondStationName"];
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

-(NSString *)firstStationName {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    
    NSString *firstStationName = [defaults objectForKey:@"firstStationName"];
    
    if([firstStationName length] > 0) {
        return firstStationName;
    } else {
        return @"Uppsala";
    }
}

-(NSString *)secondStationName {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    
    NSString *secondStationName = [defaults objectForKey:@"secondStationName"];
    
    if([secondStationName length] > 0) {
        return secondStationName;
    } else {
        return @"Stockholm";
    }
}

@end
