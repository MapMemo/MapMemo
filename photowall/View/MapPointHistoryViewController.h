//
//  MapPointHistoryViewController.h
//  photowall
//
//  Created by andy840119 on 2017/06/09.
//  Copyright © 2017年 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageUIViewController.h"

@class UserManager;
@class MapPointManager;

@interface MapPointHistoryViewController : PageUIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView* photosView;

@property (nonatomic) NSString* posterId;
@property (nonatomic, weak) UserManager* userManager;
@property (nonatomic, weak) MapPointManager* photoManager;

- (void)refreshPhotos;

@end
