//
//  CanvasViewDirectionalLines.h
//  MAW
//
//  Created by Nicholas Krzemienski on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SPUserResizableView.h"
#import "Line_Point.h"
#import "Circle.h"
#import "Rectangle.h"
#import "Freeform_Path.h"
#import "Customer.h"
#import "DrawingView.h"

@class Comments;
@class DrawingAppViewController;
@interface CanvasViewDirectionalLines : UIView <UITextFieldDelegate,UIScrollViewDelegate,SPUserResizableViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>
{
      //Resizable View Objects.
      SPUserResizableView *currentlyEditingView;
      SPUserResizableView *lastEditedView;
    
      //Holds the points for the foundation drawing
      NSMutableArray * striaght_line_points;
      //Holds the points for the straight lines
      NSMutableArray * striaght_line_tool_points;
       
      NSMutableArray * points;
    
      SPUserResizableView * currently_selected_view;
    
      //Holding arrays for when you call undo or redo this is where the items that were removed hold in.
      NSMutableArray * holding_array_points;      
      NSMutableArray * holding_array_labels;
      NSMutableArray * holding_array_icons;
      
      NSMutableArray * temp_icons;
      NSMutableArray * temp_straight_line_tool_points;
      NSMutableArray * temp_textboxes;
      NSMutableArray * temp_points;
      NSMutableArray * temp_comments;
      NSMutableArray * temp_circles;
      NSMutableArray * temp_rects;
      NSMutableArray * holding_array_circles;
      NSMutableArray * holding_array_rects;
      NSMutableArray * holding_array_textboxes;
      NSMutableArray * track_of_activites;
      NSMutableArray * holding_of_activities;
      NSMutableArray * labels;
      NSMutableArray * labels_text;
      NSString * icon_type;
      NSString * comments;
    
    //ARRAYS FOR SAVED DATA
    NSMutableArray * icons_array;
    NSMutableArray * straight_line_tool_points_array;
    NSMutableArray * textboxes_array;
    NSMutableArray * points_array;
    NSMutableArray * comments_array;
    NSMutableArray * rect_array;
    NSMutableArray * circle_array;
    
      bool up_pressed;
      bool down_pressed;
      bool left_pressed;
      bool right_pressed;
    
      bool foundation_mode;
      bool details_mode;
      bool comments_mode;
    
      NSString * dataFilePath;
      UIColor * current_color;
      NSString * current_line_pattern;
      Freeform_Path * current_path_being_drawn;
      UIImageView * background;
      CGPoint lastTapPoint;
    
     // int commentCount;

      Comments * comment_view;
    
    SPUserResizableView * view_tapped;
    
    Customer * item;
    
    DrawingView * freeline_view;
    
    MKMapView * map;
    
     CLLocationManager *locationManager;
    CLLocationCoordinate2D coordinates;
    
   
    
    
}

@property (nonatomic, retain) NSMutableArray *straight_line_points;
@property (nonatomic, retain) NSMutableArray *straight_line_tool_points;
@property (nonatomic, retain) NSMutableArray *points;
@property (nonatomic, retain) NSMutableArray *labels;
@property (nonatomic, retain) NSMutableArray *labels_text;
@property (nonatomic, retain) UIImageView * background;
@property (nonatomic, retain) NSString * comments;
@property (nonatomic, retain) Customer * item;

- (CGFloat) colorComponentFrom: (NSString *) string start:(NSUInteger) start length:(NSUInteger) length;
- (UIColor *) colorWithHexString:(NSString *)hexString;

@end
