//
//  Settings.h
//  Pendeln
//
//  Created by Sebastian Björkelid on 2012-02-03.
//  Copyright (c) 2012 Bilddagboken AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SB-SJ-API.h"

@interface Settings : NSObject

@property (nonatomic, strong) NSString *homeStation;
@property (nonatomic, strong) NSString *jobStation;
@property (nonatomic, strong) NSNumber *firstSelected;
@property (nonatomic, strong) NSArray *stations;

@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) SB_SJ_API *api;


+(id)SharedSettings;

-(Settings *) initWithSavedSettings;

@end
