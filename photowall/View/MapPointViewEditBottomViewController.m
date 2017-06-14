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
#import "RootViewController.h"
#import "UIImageView+WebImage.h"

@interface MapPointViewEditBottomViewController ()

@property MapPoint *uploadTargetMapPoint;

//upload image
@property UIImage *uploadImage;

@end

//TODO : flow up the textbox when typing
// https://stackoverflow.com/questions/1126726/how-to-make-a-uitextfield-move-up-when-keyboard-is-present
//
@implementation MapPointViewEditBottomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
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
	//[self presentViewController:picker animated:YES completion:nil];
	[self.mapPointViewController.rootViewController presentViewController:picker animated:YES completion:nil];
}

- (IBAction)EditViewSwipeDown:(id)sender
{

	//if swipe down, cancel edit
    self.closeEditView;
}


//if switch to viewMode
-(void)viewWillAppear:(BOOL)animated
{
    
}

// if selected upload image ,upload directly
//and notified map to update
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
	//change the view into this
	[self.mapPointViewController.rootViewController presentViewController:self.mapPointViewController animated:YES completion:nil];
	//save the image from ImagePicker
	[picker dismissViewControllerAnimated:YES completion:nil];
	//get selected image
	self.uploadImage = [info valueForKey:UIImagePickerControllerOriginalImage];
	//update view
	self.updateView;
	//update map view view
	[self.mapPointViewController updateView: onEdit];

}

//upload image
- (IBAction)ClickUploadImageButton:(id)sender
{
	[self uploadMapPoint];
}

//upload image
-(void)uploadMapPoint
{
	if(self.uploadTargetMapPoint==nil)
		self.setNewEdit;

	//set context;
	NSString *context=_contextUITextView.text;
	self.uploadTargetMapPoint.context=context;

	@try
	{
		//convert image into data
		if(self.uploadImage==nil)
		self.uploadImage = self.getDefaultImage;

		self.uploadTargetMapPoint.image = UIImagePNGRepresentation(self.uploadImage);

		NSLog(@"create MapPoint and prepare to upload");
		//uplaod profile
		[self.mapPointViewController.photoManager uploadMapPoint:self.uploadTargetMapPoint withHandler:^(NSError *error, NSArray *photos)
		{
			//refresh mapPointView
			//[self.mapPointViewController.rootViewController._mapPointGridViewController refreshPhotos];
			//[self.mapPointViewController ];
			NSLog(@"commit success");
		}];

		self.closeEditView;

	}
	@catch (NSException *exception)
	{
		NSLog(exception.reason);
	}

	//clean the edit date
	self.uploadTargetMapPoint=nil;
	self.uploadImage=nil;
	[self updateView];
}

//upload exist mapPoint
#pragma mark function
- (void)setExistMapPoint:(MapPoint *)targetMapPoint
{
	self.uploadTargetMapPoint=targetMapPoint;
	if(self.uploadImageView!=nil)
	{
		//set image
		[self.uploadImageView setImageWithPath:self.uploadTargetMapPoint.thumbnailPath andPlaceholder:nil];
		self.uploadImage=self.uploadImageView.image;
	}
	//update view
	[self updateView];
}

//new upload MapPoint
-(void)setNewEdit
{
	NSString *userName=self.getUserName;

	//get the position from the map
	MapPointLocation *location;
	location = self.getLocation;

	//get now DataTime, but not use when upload
	NSDate* timestamp = [NSDate alloc];

	//upload uploadTargetMapPoint
	self.uploadTargetMapPoint= [[MapPoint alloc]
			initWithIdentifier:nil
					  posterId:userName
					 timestamp:timestamp
				   andLocation:location
					andContext:@""];	//get context form textBox

	//update view
	[self updateView];
}

//update view
-(void)updateView
{
	self.uploadImageView.image=self.uploadImage;
}

#pragma mark private function
-(MapPointLocation *) getLocation
{
	return self.mapPointViewController.getPositionFromMapViewCenter;
}

#pragma mark private function
-(NSString *)getUserName
{
	return self.mapPointViewController.accountManager.me.identifier;
}

//set default image;
#pragma mark private function
-(UIImage *) getDefaultImage
{
	return [UIImage imageNamed:@"Plus_icon"];
}

-(void)closeEditView
{
	//update map view
	[self.mapPointViewController updateView: emptyAndReadyForEdit];
}

@end
