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
#import "UIImageView+WebImage.h"

@interface DetailMapPointView ()

    @property MapPoint *nowMapPoint;

@end

@implementation DetailMapPointView


//close view by gesture
- (IBAction)closeGesture:(id)sender
{
    [self.host dismissViewControllerAnimated:YES completion:nil];
}


- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // top, left, bottom, right
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - IBActions
- (IBAction)closeShowcaseButtonPressed:(id)sender {
    [self.host dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"start";
    //load the info and update view
    if(self.nowMapPoint!=nil)
        [self setMapPoint:self.nowMapPoint];

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
    self.nowMapPoint=mapPoint;
    self.contextLabel.text=self.nowMapPoint.context;
    self.userLabel.text=[self.userManager getUser:self.nowMapPoint.posterId].nickname;
    //self.dateLabel.text=self.nowMapPoint.timestamp;
    [self.photoUIImageView setImageWithPath:self.nowMapPoint.thumbnailPath andPlaceholder:nil];
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
