//
//  TeamRequestsTableViewController.m
//  Bin of Parts
//
//  Created by Developer on 3/11/14.
//  Copyright (c) 2014 Bin of Parts, inc. All rights reserved.
//

#import "TeamRequestsTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "RemoveFromInventoryPartViewController.h"
#import "PDKeychainBindings.h"
#import "constants.h"

@interface TeamRequestsTableViewController ()

@end

@implementation TeamRequestsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)stopRefresh

{
    
    [self.refreshControl endRefreshing];
    
}
- (void) sendRequest{
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    NSString *email = [bindings objectForKey:@"email"];
    NSString *token = [bindings objectForKey:@"token"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@events/2014flor/inventories?user_email=%@&user_token=%@", kBaseURL, email,token];
    
    NSURL *teamURL = [NSURL URLWithString:urlString];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *error = nil;
        NSData *jsonData = [NSData dataWithContentsOfURL:teamURL options:0 error:&error];
        if (jsonData == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self alertStatus:@"Sorry No Requests." :@""];
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error2 = nil;
                self.requests = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error2];
                NSLog(@"%@",error2);
                NSLog(@"%@",self.requests);
                
                //[self.requests arrayByAddingObjectsFromArray:temp];
                
                [self.tableView reloadData];
                [self performSelector:@selector(stopRefresh) withObject:nil];
            });
        }
        
    });
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    NSString *email = [bindings objectForKey:@"email"];
    NSString *token = [bindings objectForKey:@"token"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@events/2014flor/inventories?user_email=%@&user_token=%@", kBaseURL, email,token];
    
    NSURL *teamURL = [NSURL URLWithString:urlString];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *error = nil;
        NSData *jsonData = [NSData dataWithContentsOfURL:teamURL options:0 error:&error];
        if (jsonData == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertStatus:@"Sorry Nothing in inventory." :@""];
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error2 = nil;
                self.requests = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error2];
                NSLog(@"%@",error2);
                NSLog(@"%@",self.requests);
                
                //[self.requests arrayByAddingObjectsFromArray:temp];
                
                [self.tableView reloadData];
            });
        }
        
    });
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    
    
    
    [refresh addTarget:self action:@selector(sendRequest)
     
      forControlEvents:UIControlEventValueChanged];
    
    
    
    self.refreshControl = refresh;
    
    self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);

}

//- (void)viewDidDisappear:(BOOL)animated{
//    [self.timer invalidate];
//}
- (void)viewDidAppear:(BOOL)animated{
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(sendRequest:) userInfo:nil repeats:YES];
    [self sendRequest];
}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_searchResults count];
        
    } else {
        return [_requests count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *tempDictionary = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        tempDictionary= [_searchResults objectAtIndex:indexPath.row];
    } else {
        tempDictionary= [_requests objectAtIndex:indexPath.row];
    }
    
    NSString *team = [tempDictionary objectForKey:@"team_id"];
    NSString *qty = [tempDictionary objectForKey:@"qty"];
    NSNumber *accepted = [tempDictionary objectForKey:@"accepted"];
    NSString *accepted_by = [tempDictionary objectForKey:@"accepted_by"];
    
    if ([accepted boolValue] == YES) {
        UILabel *acceptedteamlbl = (UILabel *)[cell viewWithTag:204];
        [acceptedteamlbl setText:[NSString stringWithFormat:@"Team %@", accepted_by]];
    }
    else {
        UILabel *acceptedteamlbl = (UILabel *)[cell viewWithTag:204];
        UILabel *acceptedbylbl = (UILabel *)[cell viewWithTag:205];
        acceptedteamlbl.hidden = true;
        acceptedbylbl.hidden = true;
    }
    
    NSDictionary *part = [tempDictionary objectForKey:@"part"];
    NSString *name = [part objectForKey:@"name"];
    NSString *description = [part objectForKey:@"description"];
    NSString *year = [part objectForKey:@"year"];
    NSString *picture = [part objectForKey:@"picture"];
    
    
    NSString *pictureURL = [NSString stringWithFormat:@"%@assets/kop%@/%@",kNoAPIURL, year, picture];
    
//    UIImageView *requestImageView = (UIImageView *)[cell viewWithTag:203];
//    NSURL *url = [NSURL URLWithString:pictureURL];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    requestImageView.image = [UIImage imageWithData:data];
    
    UIImageView *requestImageView = (UIImageView *)[cell viewWithTag:203];
    
    [requestImageView setImageWithURL:[NSURL URLWithString:pictureURL]
                     placeholderImage:[UIImage imageNamed:@"second"]];
    
    UILabel *qtylbl = (UILabel *)[cell viewWithTag:206];
    [qtylbl setText:[NSString stringWithFormat:@"%@", qty]];
    UILabel *teamlbl = (UILabel *)[cell viewWithTag:200];
    [teamlbl setText:[NSString stringWithFormat:@"Team %@", team]];
    UILabel *lblName = (UILabel *)[cell viewWithTag:201];
    [lblName setText:[NSString stringWithFormat:@"%@", name]];
    UILabel *lblDesc = (UILabel *)[cell viewWithTag:202];
    [lblDesc setText:[NSString stringWithFormat:@"%@", description]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"part.name contains[c] %@", searchText];
    _searchResults = [_requests filteredArrayUsingPredicate:resultPredicate];
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void) alertStatus:(NSString *)msg :(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
        NSString *email = [bindings objectForKey:@"email"];
        NSString *token = [bindings objectForKey:@"token"];
        
        NSDictionary *tempDictionary= [self.requests objectAtIndex:indexPath.row];
        NSNumber *inventory_id = [tempDictionary objectForKey:@"id"];
        NSString *urlString = [NSString stringWithFormat:@"%@events/2014flor/inventories/%@?user_email=%@&user_token=%@&event_id=17", kBaseURL, inventory_id, email, token];
        
        NSURL *url=[NSURL URLWithString:urlString];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"DELETE"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSLog(@"Response code: %d", [response statusCode]);
        
        if ([response statusCode] == 200) {
            [self sendRequest];
        }
        
        
    }
}


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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RemoveFromInventory"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RemoveFromInventoryPartViewController *destViewController = segue.destinationViewController;
        destViewController.partitem = [self.requests objectAtIndex:indexPath.row];
        //[self.timer invalidate];
    }
}

@end
