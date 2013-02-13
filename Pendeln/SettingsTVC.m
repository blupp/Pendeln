//
//  SettingsTVC.m
//  Pendeln
//
//  Created by Sebastian Björkelid on 2013-02-04.
//  Copyright (c) 2013 Bilddagboken AB. All rights reserved.
//

#import "SettingsTVC.h"
#import "StationsListTVC.h"
#import "Settings.h"

@interface SettingsTVC ()

@end

@implementation SettingsTVC

@synthesize homeStation = _homeStation;
@synthesize jobStation = _jobStation;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    Settings *settings = [[Settings alloc] init];
    
    UITableViewCell *cell;
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.detailTextLabel.text = [settings homeStation];
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.detailTextLabel.text = [settings jobStation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    /*StationsListTVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"stationsList"];
    [vc setStation:^(NSString *station) {
        NSLog(@"station = %@", station);
    }];*/
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
// TODO Indetifiera vilken cell man klickat på via sender istället för att ha två olika fall
    
    if ([[segue identifier] isEqualToString:@"homeStationsListSegue"]) {
        StationsListTVC *stationsVC = (StationsListTVC *)segue.destinationViewController;
        [stationsVC setStation:^(NSString *station) {
            NSLog(@"station = %@", station);
            self.homeStation = station;
        }];
    }
    
    if ([[segue identifier] isEqualToString:@"jobStationsListSegue"]) {
        StationsListTVC *stationsVC = (StationsListTVC *)segue.destinationViewController;
        [stationsVC setStation:^(NSString *station) {
            NSLog(@"station = %@", station);
            self.jobStation = station;
        }];
    }
}

- (void)setHomeStation:(NSString *)homeStation {
    NSLog(@"setHomeStation");
    // set local var
    _homeStation = homeStation;
    
    // update UI
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.detailTextLabel.text = homeStation;
    
    // save to settings
    Settings *settings = [Settings SharedSettings];
    [settings setHomeStation:homeStation];
}

- (void)setJobStation:(NSString *)jobStation {
    NSLog(@"setJobStation");
    // set local var
    _jobStation = jobStation;
    
    // update UI
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.detailTextLabel.text = jobStation;
    
    // save to settings
    Settings *settings = [Settings SharedSettings];
    [settings setJobStation:jobStation];
}

@end
