//
//  RemoveFromInventoryPartViewController.m
//  Bin of Parts
//
//  Created by Developer on 3/13/14.
//  Copyright (c) 2014 Bin of Parts, inc. All rights reserved.
//

#import "RemoveFromInventoryPartViewController.h"
#import "PDKeychainBindings.h"
#import "constants.h"

@interface RemoveFromInventoryPartViewController ()

@end

@implementation RemoveFromInventoryPartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",_partitem);
    NSDictionary *part = [_partitem objectForKey:@"part"];
    NSString *year = [part objectForKey:@"year"];
    NSString *picture = [part objectForKey:@"picture"];
    NSString *name = [part objectForKey:@"name"];
    NSString *description = [part objectForKey:@"description"];
    NSString *pictureURL = [NSString stringWithFormat:@"%@assets/kop%@/%@",kNoAPIURL, year, picture];
    
    UIImageView *recipeImageView = (UIImageView *)[self.view viewWithTag:105];
    NSURL *url = [NSURL URLWithString:pictureURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    recipeImageView.image = [UIImage imageWithData:data];
    
    CGRect Label1Frame = CGRectMake(0, 395, 540, 75);
    
    UILabel *lblTemp;
    
    lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
    [lblTemp setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
    lblTemp.tag = 1;
    lblTemp.textAlignment = NSTextAlignmentCenter;
    lblTemp.backgroundColor=[UIColor clearColor];
    lblTemp.numberOfLines=2;
    [self.view addSubview:lblTemp];
    
    UILabel *lblTemp1 = (UILabel *)[self.view viewWithTag:1];
    lblTemp1.text = name;
    
    CGRect Label2Frame = CGRectMake(0, 470, 540, 60);
    
    UILabel *lbl2Temp;
    
    lbl2Temp = [[UILabel alloc] initWithFrame:Label2Frame];
    [lbl2Temp setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
    lbl2Temp.tag = 2;
    lbl2Temp.textAlignment = NSTextAlignmentCenter;
    lbl2Temp.backgroundColor=[UIColor clearColor];
    lbl2Temp.numberOfLines=2;
    [self.view addSubview:lbl2Temp];
    
    UILabel *lblTemp2 = (UILabel *)[self.view viewWithTag:2];
    lblTemp2.text = description;
}
- (IBAction)CancelButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)SaveButton:(id)sender{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    NSNumber *qty = [formatter numberFromString:[_qtyField text] ];
    NSNumber *team = [formatter numberFromString:[_teamField text] ];
    NSDictionary *part = [_partitem objectForKey:@"part"];
    NSNumber *part_id = [part objectForKey:@"id"];
    
    NSNumber *inv_qty = [_partitem objectForKey:@"qty"];
    
    if (!qty || !team) {
        [self alertStatus:@"Please provide qty & team number." :@"Error!"];
    }
    else if ([qty intValue] > [inv_qty intValue]){
        [self alertStatus:@"Quantity to high, we dont have that many. Try Again?" :@"Game Over!"];
    }
    else if ([inv_qty intValue] == 0){
        [self alertStatus:@"None to Give out." :@"Game Over!"];
    }
    else{
        PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
        NSString *email = [bindings objectForKey:@"email"];
        NSString *token = [bindings objectForKey:@"token"];
        NSNumber *inventory_id = [_partitem objectForKey:@"id"];
        
        
        
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@events/2015flor/inventories/new?user_email=%@&user_token=%@&team_id=%@&part_id=%@&qty=%@&event_id=17&inventory_id=%@", kBaseURL, email, token, team, part_id, qty, inventory_id];
        
        NSURL *url=[NSURL URLWithString:urlString];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSLog(@"Response code: %d", [response statusCode]);
        
        
        //Add a check to see the status
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backgroundClicked:(id)sender {
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
