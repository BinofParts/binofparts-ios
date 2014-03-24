//
//  PartListViewController.m
//  Bin of Parts
//
//  Created by Developer on 3/11/14.
//  Copyright (c) 2014 Bin of Parts, inc. All rights reserved.
//

#import "PartListViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PartViewController.h"
#import "constants.h"

@interface PartListViewController ()

@end

@implementation PartListViewController

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
    
    NSString *urlString = [NSString stringWithFormat:@"%@parts/%@", kBaseURL, [_category lowercaseString]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *partURL = [NSURL URLWithString:urlString];
    NSLog(@"%@",partURL);
    NSError *error = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:partURL options:0 error:&error];
    NSError *error2 = nil;
    self.parts = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.parts.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *tempDictionary= [self.parts objectAtIndex:indexPath.row];
    NSDictionary *picture = [tempDictionary objectForKey:@"picture"];
    NSDictionary *year = [tempDictionary objectForKey:@"year"];
    NSString *name = [tempDictionary objectForKey:@"name"];
    NSString *pictureURL = [NSString stringWithFormat:@"%@assets/kop%@/%@",kNoAPIURL, year, picture];
    
//    UIImageView *requestImageView = (UIImageView *)[cell viewWithTag:100];
//    NSURL *url = [NSURL URLWithString:pictureURL];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    requestImageView.image = [UIImage imageWithData:data];
    
    UIImageView *requestImageView = (UIImageView *)[cell viewWithTag:100];
    [requestImageView setImageWithURL:[NSURL URLWithString:pictureURL]
                     placeholderImage:[UIImage imageNamed:@"second"]];
    
    CGRect Label1Frame = CGRectMake(0, 80, 150, 70);
    
    UILabel *lblTemp;
    
    lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
    [lblTemp setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
    lblTemp.tag = 1;
    lblTemp.textAlignment = NSTextAlignmentCenter;
    lblTemp.backgroundColor=[UIColor clearColor];
    lblTemp.numberOfLines=2;
    [cell.contentView addSubview:lblTemp];
    
    UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
    lblTemp1.text = name;
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"setPart"]) {
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        NSIndexPath *index = [indexPaths objectAtIndex:0];
        PartViewController *destViewController = segue.destinationViewController;
        destViewController.partitem = [self.parts objectAtIndex:index.row];
    }
}

@end
