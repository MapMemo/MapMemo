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

    float barFrame_Y;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	_annotations = [NSMutableArray new];
	_nearByPhotos = [NSMutableArray new];

	TriggerDeltaPressTime=1000;

	//set the position_Y
	barFrame_Y=400.0f;

    _viewMapPointBarController=[[MapPointView_ViewBarController alloc] initWithNibName:@"MapPointView_ViewBar" bundle:nil];
    _editMapPointBarController=[[MapPointView_EditBarController alloc] initWithNibName:@"MapPointView_EditBar" bundle:nil];

    //get keyboard appear and disappear event
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

    _barControllers = @[  _viewMapPointBarController,_editMapPointBarController ];

    //set now page index is 0
    _selectedIndex = 1;
    //set index
    [self setSelectedIndex:_selectedIndex];

	//add map event
	UIPanGestureRecognizer* panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragMap:)];
	[panRec setDelegate:self];
	[self.mapView addGestureRecognizer:panRec];
}

- (void)didDragMap:(UIGestureRecognizer*)gestureRecognizer
{
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
	{
		//
		NSLog(@"drag ended");
	}
	else
	{
		//TODO detect if area contains any mapPoints

		//TODO : if contains ,catch the nearest center map Points
		NSLog(@"draging...");
	}
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}

//if switch to this page
-(void) OnSwitchPage
{
	//TODO : switch to the right bottom controller
}

//keyboard show and start typing
- (void)keyboardWillShow:(NSNotification*)aNotification {
    self.setBottonViewShowWithKeyboardHeight;
}

//hide the keyboard
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
	self.setBottomViewShow;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
		self.setBottonViewHide;
        return;
    }
    _selectedIndex = index;
	//get now controller
    UIViewController* controller = [_barControllers objectAtIndex:index];
    if (_currentController == controller)
    {
        return;
    }
	//hide the view
	self.setBottonViewHide;
	//switch the view
    [_currentController.view removeFromSuperview];
    [self.bottomViewContainer addSubview:controller.view fit:YES];
    _currentController = controller;
	//show the view
	self.setBottomViewShow;
    //TODO : if is edit barView,set touch as enable;
    if(index==1)
    {
        self.bottomViewContainer.userInteractionEnabled=true;
    }
    else
    {
        self.bottomViewContainer.userInteractionEnabled=false;
    }
}

//can see the whole view when has keyboard
-(void) setBottonViewShowWithKeyboardHeight
{
	[UIView animateWithDuration:0.25 animations:^
	{
		CGRect newFrame = [self.bottomViewContainer frame];
		newFrame.origin.y =barFrame_Y - 300; // tweak here to adjust the moving position
		[self.bottomViewContainer setFrame:newFrame];

	}completion:^(BOOL finished)
	{

	}];
}

//show the whole view
-(void) setBottomViewShow
{
	[UIView animateWithDuration:0.25 animations:^
	{
		CGRect newFrame = [self.bottomViewContainer frame];
		newFrame.origin.y =barFrame_Y ;  // tweak here to adjust the moving position
		[self.bottomViewContainer setFrame:newFrame];

	}completion:^(BOOL finished)
	{

	}];

}

//hide the view
-(void) setBottonViewHide
{
	[UIView animateWithDuration:0.25 animations:^
	{
		CGRect newFrame = [self.bottomViewContainer frame];
		newFrame.origin.y =barFrame_Y + 300 ;  // tweak here to adjust the moving position
		[self.bottomViewContainer setFrame:newFrame];

	}completion:^(BOOL finished)
	{

	}];

}


@end
