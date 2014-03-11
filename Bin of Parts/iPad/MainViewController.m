//
//  MainViewController.m
//  Bin of Parts
//
//  Created by Developer on 3/10/14.
//  Copyright (c) 2014 Bin of Parts, inc. All rights reserved.
//

#import "MainViewController.h"
#import "PDKeychainBindings.h"
#import "constants.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    NSString *email = [bindings objectForKey:@"email"];
    NSString *token = [bindings objectForKey:@"token"];
    NSLog(@"User Email: %@",email);
    NSLog(@"User Token: %@",token);
    if ([email length] != 0 || [token length] != 0) {
        [self performSegueWithIdentifier:@"logout" sender:self];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logoutButton:(id)sender {
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    NSString *token = [bindings objectForKey:@"token"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@sessions/%@", kBaseURL, token];
    NSURL *url=[NSURL URLWithString:urlString];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"Response code: %d", [response statusCode]);
    if ([response statusCode] == 200)
    {
        [bindings removeObjectForKey:@"email"];
        [bindings removeObjectForKey:@"token"];
        [self performSegueWithIdentifier:@"logout" sender:self];
    } else {
        if (error) NSLog(@"Error: %@", error);
    }
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
