//
//  RootViewController.m
//  photowall
//
//  Created by Spirit on 4/1/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "RootViewController.h"

#import "ProfileViewController.h"
#import "FriendsViewController.h"
#import "MapPointViewController.h"
#import "MapPointGridViewController.h"
#import "MapPointHisteryController.h"

#import "UIView+Utils.h"
#import "UIColor+Defaults.h"

#import "MapPointManager.h"
#import "ChangableMapButton.h"

@implementation RootViewController
{

	//Friend list
	FriendsViewController* _friendsViewController;
	//Map List View
	MapPointGridViewController* _mapPointGridViewController;
	//Histery
	MapPointHisteryController *_mapPointHisteryController;
	//Profile
	ProfileViewController* _profileViewController;
	//MapView
	MapPointViewController* _mapPointViewController;

	NSArray* _titles;
	NSArray* _tabButtons;
	NSArray* _viewControllers;

	NSInteger _selectedIndex;
	UIViewController* _currentController;
}

//those five view are loaded preparing for switching
- (void)viewDidLoad {
	[super viewDidLoad];
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
		self.edgesForExtendedLayout = UIRectEdgeNone;
	}

	//combint four button into one,so that it cen change it by switching index
	_tabButtons = @[ _mapPointViewTabButton,_friendsTabButton, _mapListViewTabButton, _mapPointHisteryTabButton, _profileTabButton ];

	//all page
	_mapPointHisteryController=[[MapPointHisteryController alloc] initWithNibName:@"MapPointHistery" bundle:nil];
	_profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileView" bundle:nil];
	_mapPointViewController = [[MapPointViewController alloc] initWithNibName:@"MapPointView" bundle:nil];
	_mapPointGridViewController = [[MapPointGridViewController alloc] initWithNibName:@"MapPointGridView" bundle:nil];
	_friendsViewController = [[FriendsViewController alloc] initWithNibName:@"FriendsListView" bundle:nil];

	//set to array for selection by index
	_viewControllers = @[_mapPointViewController , _friendsViewController, _mapPointGridViewController,_mapPointHisteryController , _profileViewController];

	//setting
	_profileViewController.rootViewController = self;
	_profileViewController.accountManager = self.accountManager;
	//photo
	_mapPointGridViewController.rootViewController = self;
	_mapPointGridViewController.userManager = self.userManager;
	_mapPointGridViewController.photoManager = self.photoManager;
	//map
	_mapPointViewController.rootViewController = self;
	_mapPointViewController.userManager = self.userManager;
	_mapPointViewController.photoManager = self.photoManager;
	_mapPointViewController.accountManager = self.accountManager;
	//histery
	_mapPointHisteryController.rootViewController = self;
	_mapPointHisteryController.userManager = self.userManager;
	_mapPointHisteryController.photoManager = self.photoManager;
	//friend
	_friendsViewController.rootViewController = self;
	_friendsViewController.userManager = self.userManager;

    //set now page index is 0
    _selectedIndex = 0;
    //set index
	[self setSelectedIndex:_selectedIndex];

	//[self setTitle:@"Friends"];
}

//set the user ID into MapPointGridViewController
- (void)showPhotosOfUser:(NSString*)userId {
	MapPointGridViewController* controller = [[MapPointGridViewController alloc] initWithNibName:@"MapPointGridView" bundle:nil];
	controller.posterId = userId;
	controller.userManager = self.userManager;
	controller.photoManager = self.photoManager;
	[self.navigationController pushViewController:controller animated:YES];
}

//if press four of the buttonthe button
#pragma mark - IBActions
- (IBAction)tabButtonPressed:(id)sender {
	if ([sender isKindOfClass:[UIButton class]]) {
		UIButton* button = (UIButton*)sender;
		[self setSelectedIndex:(button.tag)];
	}
}

//center circle button down
- (IBAction)takePictureButtonDown:(id)sender
{
    //send the notification to View
	_mapPointViewController.PressButtonDown;
}

//center circle button up
- (IBAction)takePictureButtonPressed:(id)sender
{
    [self setSelectedIndex:(0)];
    //send the notification to View
	[_mapPointViewController PressButtonUp];
}

//switch the page
#pragma mark - Private Methods
- (void)setSelectedIndex:(NSInteger)index
{
	if (index < 0 || index > [_viewControllers count]) {
		return;
	}
	_selectedIndex = index;
	for (NSUInteger i = 0; i < _tabButtons.count; i++) {
		[[_tabButtons objectAtIndex:i] setSelected:(i == index)];
	}
	UIViewController* controller = [_viewControllers objectAtIndex:index];
	if (_currentController == controller) {
		return;
	}
	[_currentController.view removeFromSuperview];
	[self.viewContainer addSubview:controller.view fit:YES];
	_currentController = controller;
}



@end
