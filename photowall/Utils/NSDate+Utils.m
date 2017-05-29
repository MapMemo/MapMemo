//
//  NSDate+Utils.m
//  photowall
//
//  Created by Spirit on 4/29/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

//get now second time
- (NSString*)timestampInMilliseconds {
	long milliseconds = ceil(self.timeIntervalSince1970 * 1000);
	return [NSString stringWithFormat:@"%ld", milliseconds];
}

//get noe time format
- (NSString*)dayString {
	NSDateFormatter* formatter = [NSDateFormatter new];
	formatter.dateFormat = @"YYYY/MM/dd";
	return [formatter stringFromDate:self];
}

@end
