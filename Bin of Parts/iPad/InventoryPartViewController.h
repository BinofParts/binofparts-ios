//
//  InventoryPartViewController.h
//  Bin of Parts
//
//  Created by Developer on 3/13/14.
//  Copyright (c) 2014 Bin of Parts, inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InventoryPartViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *qtyField;
@property (nonatomic, strong) NSDictionary *partitem;
- (IBAction)SaveButton:(id)sender;

@end
