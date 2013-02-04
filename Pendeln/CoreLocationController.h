//
//  CoreLocationController.h
//  Pendeln
//
//  Created by Sebastian Björkelid on 2013-01-24.
//  Copyright (c) 2013 Bilddagboken AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol CoreLocationControllerDelegate
@required
- (void)locationUpdate:(CLLocation *)location; // Our location updates are sent here
- (void)locationError:(NSError *)error; // Any errors are sent here
@end

@interface CoreLocationController : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locMgr;
	id delegate;
}

@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic, strong) id delegate;

@end