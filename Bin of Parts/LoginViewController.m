//
//  LoginViewController.m
//  Bin of Parts
//
//  Created by Developer on 2/26/14.
//  Copyright (c) 2014 Bin of Parts, inc. All rights reserved.
//

#import "LoginViewController.h"
#import "PDKeychainBindings.h"
#import "constants.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    [_emailField becomeFirstResponder];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"LoggedIn"])
    {
        [segue destinationViewController];
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

- (IBAction)loginClicked:(id)sender {
    @try {
        
        if([[_emailField text] isEqualToString:@""] || [[_passwordField text] isEqualToString:@""] ) {
            [self alertStatus:@"Please enter both Username and Password" :@"Login Failed!"];
        } else {
            NSString *post =[[NSString alloc] initWithFormat:@"email=%@&password=%@",[_emailField text],[_passwordField text]];
            NSLog(@"PostData: %@",post);
            
            NSString *urlString = [NSString stringWithFormat:@"%@sessions", kBaseURL];
            
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
            if ([response statusCode] >=200 && [response statusCode] <300)
            {
                NSError *error2 = nil;
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:&error2];
                
                NSString *token = [NSString stringWithFormat:@"%@", [jsonData objectForKey:@"token"]];
                NSLog(@"Token: %@",token);
                if(![token  isEqual: @"null"])
                {
                    NSLog(@"Login SUCCESS");
                    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
                    [bindings setObject:token forKey:@"token"];
                    [bindings setObject:[NSString stringWithFormat:@"%@",[_emailField text]] forKey:@"email"];
                    [self performSegueWithIdentifier:@"LoggedIn" sender:self];
                } else {
                    NSString *error_msg = (NSString *) [jsonData objectForKey:@"error_message"];
                    [self alertStatus:error_msg :@"Login Failed!"];
                }
                
            }else if ([response statusCode] >= 400){
                [self alertStatus:@"Email or Password is incorrect." :@"Login Failed!"];
            } else {
                if (error) NSLog(@"Error: %@", error);
                [self alertStatus:@"Email or Password is incorrect." :@"Login Failed!"];
            }
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Login Failed." :@"Login Failed!"];
    }
    
}

- (IBAction)backgroundClicked:(id)sender {
    [_emailField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

//- (IBAction)cancelClicked:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

@end
