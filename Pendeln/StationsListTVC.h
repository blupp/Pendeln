//
//  stationsListTVC.h
//  Pendeln
//
//  Created by Sebastian Björkelid on 2013-02-04.
//  Copyright (c) 2013 Bilddagboken AB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^stationBlock)(NSString *station);

@interface StationsListTVC : UITableViewController

@property (nonatomic, copy) stationBlock station;
@property (nonatomic,strong) NSArray *stations;

@end
