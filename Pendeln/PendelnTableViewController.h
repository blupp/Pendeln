//
//  PendelnTableViewController.h
//  Pendeln
//
//  Created by Sebastian Björkelid on 2012-01-16.
//  Copyright (c) 2012 Bilddagboken AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"
#import "SB-SJ-API.h"
#import "CoreLocationController.h"
#import "PullToRefreshView.h"

@interface PendelnTableViewController :  UITableViewController <PullToRefreshViewDelegate, CoreLocationControllerDelegate> {
    CoreLocationController *CLController;
}

@property (nonatomic,strong) NSArray *trains;
@property (nonatomic,strong) SB_SJ_API *api;
@property (nonatomic) NSInteger selectedIndex;

@property (nonatomic, strong) CoreLocationController *CLController;


@end
