//
//  DrawingView.h
//  iTerrian
//
//  Created by Nicholas Krzemienski on 10/15/12.
//  Copyright (c) 2012 Nicholas Krzemienski. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Line_Point.h"

@interface DrawingView : UIView
{
    NSMutableArray * points;
    UIColor * current_color;
    NSString * current_line_pattern;
    BOOL draw_selected;

    
}
@property (nonatomic, retain) NSMutableArray *points;

@end
