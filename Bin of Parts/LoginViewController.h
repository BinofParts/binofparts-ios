//
//  LoginViewController.h
//  Bin of Parts
//
//  Created by Developer on 2/26/14.
//  Copyright (c) 2014 Bin of Parts, inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)loginClicked:(id)sender;
- (IBAction)backgroundClicked:(id)sender;
//- (IBAction)cancelClicked:(id)sender;


@end
