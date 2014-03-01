//
//  EventsTableViewController.m
//  Bin of Parts
//
//  Created by Developer on 2/27/14.
//  Copyright (c) 2014 Bin of Parts, inc. All rights reserved.
//

#import "EventsTableViewController.h"
#import "EventDetailViewController.h"
#import "constants.h"

@interface EventsTableViewController ()

@end

@implementation EventsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *urlString = [NSString stringWithFormat:@"%@events", kBaseURL];
    NSURL *teamURL = [NSURL URLWithString:urlString];
    NSError *error = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:teamURL options:0 error:&error];
    NSError *error2 = nil;
    self.events = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *tempDictionary= [self.events objectAtIndex:indexPath.row];
    NSDictionary *dict = [tempDictionary objectForKey:@"name"];
    NSString *name = [NSString stringWithFormat:@"%@", dict];
    
    cell.textLabel.text =  name;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"eventSelected"])
    {
        EventDetailViewController *detailViewController =
        [segue destinationViewController];
        
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        
        NSDictionary *tempDictionary= [self.events objectAtIndex:myIndexPath.row];
        
        detailViewController.title = [NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"key"]];
        detailViewController.navigationItem.prompt = [NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"name"]];
    }
}

@end
