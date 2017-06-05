//
//  RootViewController.h
//  photowall
//
//  Created by Spirit on 4/1/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserManager;
@class MapPointManager;
@class AccountManager;
@class ChangableMapButton;

//RowView 頁E��E: FriendList,mapList,histery,setting(personal profile)
//RowView 正中閁E: Map(Add,Edit...)

@interface RootViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView* viewContainer;

//Friend list
@property (weak, nonatomic) IBOutlet UIButton* friendsTabButton;
//map list view
@property (weak, nonatomic) IBOutlet UIButton* mapListViewTabButton;
//Histery
@property (weak, nonatomic) IBOutlet UIButton* mapPointHisteryTabButton;
//setting
@property (weak, nonatomic) IBOutlet UIButton* profileTabButton;

//View map and add,enit new MapPoint in the map
@property (weak, nonatomic) IBOutlet ChangableMapButton* mapPointViewTabButton;

@property UserManager* userManager;
@property MapPointManager* photoManager;
@property AccountManager* accountManager;

- (void)showPhotosOfUser:(NSString*)userId;

@end
