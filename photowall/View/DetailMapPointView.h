//
//  DetailMapPointView.h
//  photowall
//
//  Created by andy840119 on 2017/06/11.
//  Copyright © 2017年 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface DetailMapPointView : UIViewController

@property (nonatomic) NSArray* photos;
@property (nonatomic) NSInteger currentPhotoIndex;
@property (weak, nonatomic) UIViewController* host;
@property (weak, nonatomic) IBOutlet UICollectionView* showcaseView;

@end
