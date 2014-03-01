//
//  TeamsTableViewController.m
//  Bin of Parts
//
//  Created by Developer on 2/27/14.
//  Copyright (c) 2014 Bin of Parts, inc. All rights reserved.
//

#import "TeamsTableViewController.h"
#import "TeamDetailViewController.h"
#import "constants.h"

@interface TeamsTableViewController ()

@end

@implementation TeamsTableViewController

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
    
    NSString *urlString = [NSString stringWithFormat:@"%@teams", kBaseURL];
    
    NSURL *teamURL = [NSURL URLWithString:urlString];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSError *error = nil;
        NSData *jsonData = [NSData dataWithContentsOfURL:teamURL options:0 error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error2 = nil;
            self.teams = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error2];
            [self.tableView reloadData];
        });
        
    });
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
    return [self.teams count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *tempDictionary= [self.teams objectAtIndex:indexPath.row];
    NSDictionary *dict = [tempDictionary objectForKey:@"nickname"];
    NSString *nickname = [NSString stringWithFormat:@"%@", dict];
    NSString *team = [tempDictionary objectForKey:@"team_number"];
    
    if ([dict isKindOfClass:[NSNull class]] || [nickname isEqualToString:@""]) {
        cell.textLabel.text = [NSString stringWithFormat:@"Team %@", team];
        cell.detailTextLabel.text =  @"";
    }
    else{
        cell.textLabel.text =  nickname;
        cell.detailTextLabel.text =  [NSString stringWithFormat:@"Team %@", team];
    }
    
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



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"teamSelected"])
    {
        TeamDetailViewController *detailViewController =
        [segue destinationViewController];
        
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        
        NSDictionary *tempDictionary= [self.teams objectAtIndex:myIndexPath.row];
        NSDictionary *dict = [tempDictionary objectForKey:@"nickname"];
        NSString *nickname = [NSString stringWithFormat:@"%@", dict];
        NSString *team = [tempDictionary objectForKey:@"team_number"];
        
        if (![dict isKindOfClass:[NSNull class]] || ![nickname isEqualToString:@""]) {
             detailViewController.navigationItem.prompt = [NSString stringWithFormat:@"%@", nickname];
        }
        detailViewController.title = [NSString stringWithFormat:@"Team %@", team];

    }
}

@end
