//
//  PhotoGridViewController.h
//  photowall
//
//  Created by Spirit on 4/2/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoManager;

@interface PhotoGridViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UIViewController* rootViewController;
@property (nonatomic, weak) IBOutlet UICollectionView* photosView;

@property (nonatomic, weak) PhotoManager* photoManager;

- (void)refreshPhotos;

@end
