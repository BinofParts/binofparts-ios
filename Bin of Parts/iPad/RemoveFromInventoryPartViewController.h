//
//  RemoveFromInventoryPartViewController.h
//  Bin of Parts
//
//  Created by Developer on 3/13/14.
//  Copyright (c) 2014 Bin of Parts, inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemoveFromInventoryPartViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *qtyField;
@property (weak, nonatomic) IBOutlet UITextField *teamField;
@property (nonatomic, strong) NSDictionary *partitem;
- (IBAction)SaveButton:(id)sender;
- (IBAction)CancelButton:(id)sender;

- (IBAction)backgroundClicked:(id)sender;

@end
