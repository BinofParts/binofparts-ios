//
//  PartViewController.m
//  Bin of Parts
//
//  Created by Developer on 3/11/14.
//  Copyright (c) 2014 Bin of Parts, inc. All rights reserved.
//

#import "PartViewController.h"
#import "PDKeychainBindings.h"
#import "constants.h"

@interface PartViewController ()

@end

@implementation PartViewController

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
    NSDictionary *picture = [_partitem objectForKey:@"picture"];
    NSDictionary *year = [_partitem objectForKey:@"year"];
    NSString *name = [_partitem objectForKey:@"name"];
    NSString *description = [_partitem objectForKey:@"description"];
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

- (IBAction)SaveButton:(id)sender{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    NSNumber *qty = [formatter numberFromString:[_qtyField text] ];
    NSNumber *team = [formatter numberFromString:[_teamField text] ];
    if (!qty || !team) {
        [self alertStatus:@"Please provide qty & team number." :@"Error!"];
    }
    else{
        PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
        NSString *email = [bindings objectForKey:@"email"];
        NSString *token = [bindings objectForKey:@"token"];
        NSNumber *part = [_partitem objectForKey:@"id"];
        
        NSString *post =[[NSString alloc] initWithFormat:@"team_id=%@&part_id=%@&qty=%@&event_id=24", team, part, qty];
        
        NSString *urlString = [NSString stringWithFormat:@"%@events/2015flor/requests?user_email=%@&user_token=%@", kBaseURL, email, token];
        NSLog(@"PostData: %@",post);
            
        NSURL *url=[NSURL URLWithString:urlString];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
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
