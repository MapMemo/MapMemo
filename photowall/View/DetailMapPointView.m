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
#import "UserManager.h"

@interface DetailMapPointView ()

    @property MapPoint *mapPoint;

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
}


- (void)tapped:(UITapGestureRecognizer*)tap
{
    NSLog(@"%@", tap.view);
}



//show the mapView
-(void) setMapPoint:(MapPoint *)mapPoint
{

    self.mapPoint=mapPoint;
    self.contextLabel.text=self.mapPoint.context;
    self.userLabel.text=[self.userManager getUser:self.mapPoint.posterId].nickname;
    //self.dateLabel.text=self.mapPoint.timestamp;
    //self.photoUIImage(MapPoint *)mapPoint
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
