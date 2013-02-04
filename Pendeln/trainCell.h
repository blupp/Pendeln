//
//  trainCell.h
//  Pendeln
//
//  Created by Sebastian Björkelid on 2013-01-31.
//  Copyright (c) 2013 Bilddagboken AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface trainCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *time;
@property (nonatomic,strong) IBOutlet UILabel *leavesIn;
@property (nonatomic,strong) IBOutlet UILabel *info;
@property (nonatomic,strong) IBOutlet UILabel *changedTime;
@property (nonatomic,strong) IBOutlet UILabel *strikethrough;


@end
