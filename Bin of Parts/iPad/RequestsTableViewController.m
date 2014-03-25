//
//  RequestsTableViewController.m
//  Bin of Parts
//
//  Created by Developer on 3/10/14.
//  Copyright (c) 2014 Bin of Parts, inc. All rights reserved.
//

#import "RequestsTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AcceptRequestViewController.h"
#import "PDKeychainBindings.h"
#import "constants.h"

@interface RequestsTableViewController ()

@end

@implementation RequestsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)stopRefresh

{
    
    [self.refreshControl endRefreshing];
    
}

- (void) sendRequest
{
    NSLog(@"Request Called.");
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    NSString *email = [bindings objectForKey:@"email"];
    NSString *token = [bindings objectForKey:@"token"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@events/2014flor/requests?user_email=%@&user_token=%@", kBaseURL, email,token];
    
    NSURL *teamURL = [NSURL URLWithString:urlString];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *error = nil;
        NSData *jsonData = [NSData dataWithContentsOfURL:teamURL options:0 error:&error];
        if (jsonData == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertStatus:@"Sorry No Requests." :@""];
            });
        }
        else{
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error2 = nil;
                int beforeCount =  [self.requests count];
                self.requests = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error2];
                NSLog(@"%@",error2);
                //NSLog(@"%@",temp);
                
                if (self.requests.count - beforeCount != 0){
                    [self.tableView beginUpdates];
                    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView endUpdates];
                }
                
                [self.tableView reloadData];
                [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:1.0];
                
                //[self.requests arrayByAddingObjectsFromArray:temp];
                
                
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

    NSString *urlString = [NSString stringWithFormat:@"%@events/2014flor/requests?user_email=%@&user_token=%@", kBaseURL, email,token];
    
    NSURL *teamURL = [NSURL URLWithString:urlString];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *error = nil;
        NSData *jsonData = [NSData dataWithContentsOfURL:teamURL options:0 error:&error];
        if (jsonData == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertStatus:@"Sorry No Requests." :@""];
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
    
    
    
    //[self sendRequest];
    
    
    
}

//- (void)viewDidDisappear:(BOOL)animated{
//    [self.timer invalidate];
//}
//
//- (void)viewDidAppear:(BOOL)animated{
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(sendRequest:) userInfo:nil repeats:YES];
//}

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
    return self.requests.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *tempDictionary= [self.requests objectAtIndex:indexPath.row];
    NSString *team = [tempDictionary objectForKey:@"team_id"];
    NSString *qty = [tempDictionary objectForKey:@"qty"];
    NSNumber *accepted = [tempDictionary objectForKey:@"accepted"];
    NSString *accepted_by = [tempDictionary objectForKey:@"accepted_by"];
    
    NSString *created_at = [tempDictionary objectForKey:@"created_at"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDate *created_date = [dateFormatter dateFromString:created_at];
    
    dateFormatter.dateFormat=@"hh:mm a EEEE, MMMM dd, yyyy";
    NSString * dateString = [dateFormatter stringFromDate:created_date];
    
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
    
    UILabel *datelbl = (UILabel *)[cell viewWithTag:212];
    [datelbl setText:[NSString stringWithFormat:@"%@", dateString]];
    UILabel *qtylbl = (UILabel *)[cell viewWithTag:206];
    [qtylbl setText:[NSString stringWithFormat:@"Quantity %@", qty]];
    UILabel *teamlbl = (UILabel *)[cell viewWithTag:200];
    [teamlbl setText:[NSString stringWithFormat:@"Team %@", team]];
    UILabel *lblName = (UILabel *)[cell viewWithTag:201];
    [lblName setText:[NSString stringWithFormat:@"%@", name]];
    UILabel *lblDesc = (UILabel *)[cell viewWithTag:202];
    lblDesc.lineBreakMode = NSLineBreakByWordWrapping;
    lblDesc.numberOfLines = 2;
    [lblDesc setText:[NSString stringWithFormat:@"%@", description]];
    
    return cell;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"acceptRequest"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        AcceptRequestViewController *destViewController = segue.destinationViewController;
        destViewController.partitem = [self.requests objectAtIndex:indexPath.row];
        //[self.timer invalidate];
    }
}

@end
