//
//  MapPointViewEditBottomViewController.m
//  photowall
//
//  Created by andy840119 on 2017/05/30.
//  Copyright © 2017年 Picowork. All rights reserved.
//

#import "MapPointViewEditBottomViewController.h"
#import "MapPointManager.h"
#import "MapPointViewController.h"
#import "UserManager.h"
#import "AccountManager.h"

@interface MapPointViewEditBottomViewController ()

- (void)mapPoint:(MapPoint *)mapPoint;

//upload image
@property (weak, nonatomic)UIImage *uploadImage;

@property MapPoint *uploadTargetMapPoint;

@end

//TODO : flow up the textbox when typing
// https://stackoverflow.com/questions/1126726/how-to-make-a-uitextfield-move-up-when-keyboard-is-present
//
@implementation MapPointViewEditBottomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TODO : if press image button , filter the image viewController for image selection
- (IBAction)SelectImageButtonPressUp:(id)sender
{
	UIImagePickerController* picker = [UIImagePickerController new];
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	picker.delegate = self;
	[self presentViewController:picker animated:YES completion:nil];

}




// if selected upload image ,upload directly
//and notified map to update
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
	//save the image from ImagePicker
	[picker dismissViewControllerAnimated:YES completion:nil];
	self.uploadImage = [info valueForKey:UIImagePickerControllerOriginalImage];

}

//upload image
- (IBAction)ClickUploadImageButton:(id)sender
{
	//TODO : get now DataTime, but not use when upload
	NSDate* timestamp = [NSDate alloc];

	//get the position from the map
	MapPointLocation *location;
	location = self.getPositionFromMapViewCenter;

	NSString *userName=self.getUserName;

	NSString *context=_contextUITextView.text;

	//upload uploadTargetMapPoint
	self.uploadTargetMapPoint= [[MapPoint alloc]
			initWithIdentifier:nil
					  posterId:userName
					 timestamp:timestamp
				   andLocation:location
					andContext:context];	//get context form textBox


	//convert image into data
	@try {
		if(self.uploadImage!=nil)
			self.uploadTargetMapPoint.image = UIImagePNGRepresentation(self.uploadImage);
	}
	@catch (NSException *exception) {
		NSLog(@"%@", exception.reason);
	}


	//uplaod profile
	[self.photoManager uploadMapPoint:self.uploadTargetMapPoint withHandler:^(NSError *error, NSArray *photos) {
		//refresh pages
		//[_mapPointGridViewController refreshPhotos];
	}];
}

//upload exist mapPoint
- (void)setExistMapPoint:(MapPoint *)targetMapPoint
{
	self.uploadTargetMapPoint=targetMapPoint;
}

//get map Location
-(MapPointLocation *) getPositionFromMapViewCenter
{
	//get the controller
	MapPointViewController *controller=self.mapPointViewController;
	//get the uploadTargetMapPoint
	MKMapView* mapView=controller.mapView;
	//get the location
	MapPointLocation * location = [[MapPointLocation alloc]
			initWithLatitude:mapView.centerCoordinate.latitude
				andLongitude:mapView.centerCoordinate.longitude];
	//return the location
	return location;
}

-(NSString *)getUserName
{
	return self.mapPointViewController.accountManager.me.identifier;
}

@end
