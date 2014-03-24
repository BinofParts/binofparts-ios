//
//  PartListViewController.h
//  Bin of Parts
//
//  Created by Developer on 3/11/14.
//  Copyright (c) 2014 Bin of Parts, inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartListViewController : UICollectionViewController


@property (nonatomic, strong) NSArray *parts;
@property (nonatomic, strong) NSString *category;

@end
