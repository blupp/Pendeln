//
//  PendelnTableViewController.m
//  Pendeln
//
//  Created by Sebastian Björkelid on 2012-01-16.
//  Copyright (c) 2012 Bilddagboken AB. All rights reserved.
//

#import "PendelnTableViewController.h"
#import "SB-SJ-API.h"
#import "Settings.h"
#import "MBProgressHUD.h"
#import "trainCell.h"


@implementation PendelnTableViewController {
    PullToRefreshView *pull;
}

@synthesize trains;
@synthesize api;
@synthesize selectedIndex;

- (void)locationChanged:(UISegmentedControl *)sender {
    
    NSLog([sender titleForSegmentAtIndex:[sender selectedSegmentIndex]]);
    
    selectedIndex = [sender selectedSegmentIndex];
    
    NSString *stationName = [sender titleForSegmentAtIndex:[sender selectedSegmentIndex]];
    NSString *arrivalStation;
    if([sender selectedSegmentIndex] == 1) {
        arrivalStation = [sender titleForSegmentAtIndex:0];
    } else {
        arrivalStation = [sender titleForSegmentAtIndex:1];
    }
    
    // show loading view
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        trains = [api getTrainsDepartingFrom:stationName arrivingAt:arrivalStation];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [[self tableView] reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    
}

- (void)refreshCurrentView {
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        trains = [api getTrainsDepartingFrom:@"Uppsala" arrivingAt:@"Stockholm"];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [[self tableView] reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            [pull finishedLoading];
        });
    });
}

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    [self refreshCurrentView];
}

-(UITableViewCell *)getSegControllTableCell {
    static NSString *CellIdentifier2 = @"toggleDestinationCell";
    Settings *settings = [Settings SharedSettings];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
    
    NSString *homeStation = [settings homeStation];
    NSString *jobStation = [settings jobStation];
    
    NSArray *controlTitles = [NSArray arrayWithObjects:homeStation, jobStation, nil];
    
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:controlTitles];
    
    [segControl setWidth:150 forSegmentAtIndex:0];
    [segControl setWidth:150 forSegmentAtIndex:1];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    /*if(settings.firstSelected) {
        [segControl setSelectedSegmentIndex:0];
    } else {
        [segControl setSelectedSegmentIndex:1];
    }*/
    [segControl setSelectedSegmentIndex:selectedIndex];
    
    [segControl addTarget:self
                   action:@selector(locationChanged:)
         forControlEvents:UIControlEventValueChanged];
    
    //[segControl segmentedControlStyle:UISegmentedControlStyleBezeled];
    
    [cell.contentView addSubview:segControl];
    
    return cell;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TEST
    
    
    
    if ([@"Sala" rangeOfString:@"Sala"].location != NSNotFound) {
        NSLog(@"hit");
    }
    
    if ([@"Sala C" rangeOfString:@"Sala"].location != NSNotFound) {
        NSLog(@"hit2");
    }
    
    // END TEST
    
    
    // Init
    api = [[SB_SJ_API alloc] init];
    Settings *settings = [Settings SharedSettings];
    //[settings setHomeStation:@"Uppsala"];
    NSString *homeStation = [settings homeStation];
    NSString *jobStation = [settings jobStation];
    
    
    // Customize
    self.tableView.backgroundColor = [UIColor clearColor];

    // Do stuff
    trains = [api getTrainsDepartingFrom:homeStation arrivingAt:jobStation];
    
    // CoreLocation
    CLController = [[CoreLocationController alloc] init];
	CLController.delegate = self;
	[CLController.locMgr startUpdatingLocation];
    
    // Pull to refresh
    pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.tableView];
    [pull setDelegate:self];
    [self.tableView addSubview:pull];
}

- (void)locationUpdate:(CLLocation *)location {
    
    CLLocation *uppsalaLoc = [[CLLocation alloc] initWithLatitude:59.8586f longitude:17.6389f];
    
    //NSLog(@"%f",[location distanceFromLocation:uppsalaLoc]);
    
	//NSLog([location description]);
}

- (void)locationError:(NSError *)error {
	NSLog([error description]);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    // Toggle destination-section
    if(section == 0) {
        return 1;
    }
    
    return [trains count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Toggle destination-section
    if(indexPath.section == 0) {
        return [self getSegControllTableCell];
    }
    
    static NSString *CellIdentifier = @"trainCell";
        
    trainCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *train = [trains objectAtIndex:indexPath.row];
    cell.time.text = [api formatDateFrom:[train objectForKey:@"departure"]];
    
    cell.info.text = [NSString stringWithFormat:@"Tåg %@ spår %@ mot %@",[train objectForKey:@"train"],[train objectForKey:@"track"],[train objectForKey:@"destination"]];
    
    cell.leavesIn.text = [api timeLeftFrom:[train objectForKey:@"departure"]];
    
    
    if([[train objectForKey:@"newDeparture"] isKindOfClass:[NSString class]]) {
        cell.changedTime.hidden = NO;
        cell.changedTime.text = [NSString stringWithFormat:@"Ny tid %@",[api formatDateFrom:[train objectForKey:@"newDeparture"]]];
        
        cell.time.font = [UIFont fontWithName:@"Helvetica" size:14];
        cell.strikethrough.hidden = NO;
        
        cell.leavesIn.text = [api timeLeftFrom:[train objectForKey:@"newDeparture"]];
    }
    
    // Layout the cell
    cell.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"tableCellBg.png"];
    //imageView.frame = CGRectOffset(cell.frame, -10, -10);
    cell.backgroundView = imageView;
                
    return cell;
}



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
}

@end
