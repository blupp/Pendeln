//
//  PendelnTableViewController.h
//  Pendeln
//
//  Created by Sebastian Björkelid on 2012-01-16.
//  Copyright (c) 2012 Bilddagboken AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"

@interface PendelnTableViewController : UITableViewController

@property (nonatomic,strong) NSArray *trains;
@property (nonatomic,strong) Settings *settings;

@end
