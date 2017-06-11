//
//  DetailMapPointView.m
//  photowall
//
//  Created by andy840119 on 2017/06/11.
//  Copyright © 2017年 Picowork. All rights reserved.
//

#import "DetailMapPointView.h"
#import "RootViewController.h"
#import "MapPoint.h"
#import "PhotoShowcaseViewController.h"

@interface DetailMapPointView ()

@end

@implementation DetailMapPointView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"start";


}

-(void)viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"Back from ViewController.XIB")
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backAction:)];

    //self.navigationItem.leftBarButtonItem = backButton;
    [self.host setTitle:@"Detail"];
    [self.host navigationItem].leftBarButtonItem=backButton;
}

- (void)backAction:(id)sender
{
    [self.host navigationItem].leftBarButtonItem=nil;
    [self.host.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}


//if need to show the detail photos
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    PhotoShowcaseViewController* controller = [[PhotoShowcaseViewController alloc] initWithNibName:@"PhotoShowcaseView" bundle:nil];
    NSMutableArray* photos = [NSMutableArray new];
    controller.host = self.host;
    controller.photos = photos;
    controller.currentPhotoIndex = 0;
    [self.host presentViewController:controller animated:YES completion:nil];
}


@end
