//
//  PendelnTableViewController.m
//  Pendeln
//
//  Created by Sebastian Björkelid on 2012-01-16.
//  Copyright (c) 2012 Bilddagboken AB. All rights reserved.
//

#import "PendelnTableViewController.h"
#import "Train.h"


@implementation PendelnTableViewController

@synthesize trains;

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

    trains = [Train getTrainsForLocation:@"Uppsala" withLimit:10];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Toggle destination-section
    if(indexPath.section == 0) {
        
        static NSString *CellIdentifier2 = @"toggleDestinationCell";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        cell.textLabel.text = @"TOGGLE";
        
        NSArray *controlTitles = [NSArray arrayWithObjects:@"Uppsala", @"Stockholm", nil];
        
        UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:controlTitles];
        
        [segControl setWidth:150 forSegmentAtIndex:0];
        [segControl setWidth:150 forSegmentAtIndex:1];
        
        [segControl setSelectedSegmentIndex:0];
        
        //[segControl segmentedControlStyle:UISegmentedControlStyleBezeled];

        [cell.contentView addSubview:segControl];
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"trainCell";
    
    //NSArray *trains = [Train getTrainsForLocation:@"Uppsala" withLimit:10];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *train = [trains objectAtIndex:indexPath.row];
    cell.textLabel.text = [train objectForKey:@"destination"];
    cell.detailTextLabel.text = [train objectForKey:@"departure"];
    
    
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
