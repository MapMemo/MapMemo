//
//  MapPointViewDetailBottomViewController.m
//  photowall
//
//  Created by andy840119 on 2017/05/30.
//  Copyright © 2017年 Picowork. All rights reserved.
//

#import "MapPointViewDetailBottomViewController.h"
#import "MapPoint.h"

@interface MapPointViewDetailBottomViewController ()

@property MapPoint *nowViewMapPoint;

@end

@implementation MapPointViewDetailBottomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TODO : update the info
- (void)setExistMapPoint:(MapPoint *)targetMapPoint
{
    if(self.nowViewMapPoint==targetMapPoint)
        return;

    self.nowViewMapPoint=targetMapPoint;

    //cleanUp the view
    self.userLabel.text=@"";
    self.contextLabel.text=@"";
    self.imageView.image=nil;

    if(self.nowViewMapPoint!=nil)
    {
        //TODO : add something to view
        self.userLabel.text=self.nowViewMapPoint.posterId;
        self.contextLabel.text=self.nowViewMapPoint.context;
        self.imageView.image=self.imageView;

    }
}
@end
