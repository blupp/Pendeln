//
//  Settings.h
//  Pendeln
//
//  Created by Sebastian Björkelid on 2012-02-03.
//  Copyright (c) 2012 Bilddagboken AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property (nonatomic, strong) NSString *firstStationName;
@property (nonatomic, strong) NSString *secondStationName;
@property (nonatomic, strong) NSNumber *firstSelected;

-(Settings *) initWithSavedSettings;

@end
