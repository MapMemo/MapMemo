//
//  MapPointViewController.m
//  photowall
//
//  Created by Spirit on 4/2/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "MapPointViewController.h"

#import "UserManager.h"
#import "MapPointManager.h"

#import "PhotoAnnotation.h"
#import "AnnotationCallOutView.h"

#import "UIView+Utils.h"
#import "MapPointRegion+Utils.h"
#import "MapPointView_EditBarController.h"
#import "MapPointView_ViewBarController.h"

NSString* const PhotoAnnotationViewIdentifier = @"PhotoAnnotationView";

@implementation MapPointViewController {

    //Map List View
    MapPointView_ViewBarController* _viewMapPointBarController;

	//Friend list
	MapPointView_EditBarController* _editMapPointBarController;


    NSInteger _selectedIndex;
    NSArray* _barControllers;
    UIViewController* _currentController;

	NSMutableArray* _annotations;
	NSMutableArray* _nearByPhotos;

	//if pressDeltaTime > 1000ms,set as longPress
    float TriggerDeltaPressTime;

	float pressDownTime;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	_annotations = [NSMutableArray new];
	_nearByPhotos = [NSMutableArray new];

	TriggerDeltaPressTime=1000;


    _viewMapPointBarController=[[MapPointView_ViewBarController alloc] initWithNibName:@"MapPointView_ViewBar" bundle:nil];
    _editMapPointBarController=[[MapPointView_EditBarController alloc] initWithNibName:@"MapPointView_EditBar" bundle:nil];

    _barControllers = @[  _viewMapPointBarController,_editMapPointBarController ];

    //set now page index is 0
    _selectedIndex = 1;
    //set index
    [self setSelectedIndex:_selectedIndex];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.rootViewController setTitle:@"points On Map"];
}

- (void)viewDidAppear:(BOOL)animated
{
	//set to the area
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(25.044013, 121.533954), 500, 500);
	[self.mapView setRegion:region animated:YES];
	[self loadPhotosInRegion:[MapPointRegion fromMKCoordinateRegion:region]];
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView*)mapView regionDidChangeAnimated:(BOOL)animated
{
	MapPointRegion* region = [MapPointRegion fromMKCoordinateRegion:mapView.region];
	[self loadPhotosInRegion:region];
}

- (MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
	PhotoAnnotation* photoAnnotation = (PhotoAnnotation*)annotation;
	MKAnnotationView* view = [mapView dequeueReusableAnnotationViewWithIdentifier:PhotoAnnotationViewIdentifier];
	if (view == nil) {
		view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PhotoAnnotationViewIdentifier];
	}
	AnnotationCallOutView* callOutView = [[[NSBundle mainBundle] loadNibNamed:@"AnnotationCallOutView" owner:nil options:nil] firstObject];
	callOutView.translatesAutoresizingMaskIntoConstraints = NO;
	[callOutView setPhoto:photoAnnotation.photo withNickname:[self.userManager getUser:photoAnnotation.photo.posterId].nickname];
	view.canShowCallout = YES;
	view.frame = CGRectMake(-40, -40, 80, 80);
	[view addSubview:callOutView fit:YES];
	return view;
}

#pragma mark - Private Methods
- (void)loadPhotosInRegion:(MapPointRegion*)region {
	self.mapView.tag = region.hash;
	[self.photoManager loadPhotosNear:region withHandler:[self updateAnnoationsWithTag:region.hash]];
}

#pragma mark - Code Blocks
- (PhotoHandler)updateAnnoationsWithTag:(NSInteger)tag {
	return ^(NSError* error, NSArray* photos) {
		if (self.mapView.tag != tag) {
			return;
		}
		[_nearByPhotos removeAllObjects];
		[self.mapView removeAnnotations:_annotations];
		[_annotations removeAllObjects];
		if (error == nil) {
			[_nearByPhotos addObjectsFromArray:photos];
			for (MapPoint* photo in photos) {
				PhotoAnnotation* annotation = [PhotoAnnotation new];
				annotation.photo = photo;
				annotation.poster = [self.userManager getUser:photo.posterId].nickname;
				[_annotations addObject:annotation];
			}
		}
		[self.mapView addAnnotations:_annotations];
	};
}


- (void)PressButtonDown:(float )PressTime
{
	pressDownTime=PressTime;
}

- (void)PressButtonUp:(float )PressUpTime
{
	float deltaTime=PressUpTime-pressDownTime;

	//see as long press
	if(deltaTime>TriggerDeltaPressTime)
	{
		[self LongPressMapButton];
	}
}

//long press Button,
-(void) LongPressMapButton
{

}

//switch the page
#pragma mark - Private Methods
- (void)setSelectedIndex:(NSInteger)index {
    if (index < 0 || index > [_barControllers count])
    {
        return;
    }
    _selectedIndex = index;
    UIViewController* controller = [_barControllers objectAtIndex:index];
    if (_currentController == controller)
    {
        return;
    }
    [_currentController.view removeFromSuperview];
    [self.barViewContainer addSubview:controller.view fit:YES];
    _currentController = controller;

    //TODO : if is edit barView,set touch as enable;
    if(index==1)
    {
        self.barViewContainer.userInteractionEnabled=true;
    }
    else
    {
        self.barViewContainer.userInteractionEnabled=false;
    }
}

@end
