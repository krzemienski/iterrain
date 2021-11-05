//
//  DrawingAppViewController.h
//  MAW
//
//  Created by Nicholas Krzemienski on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <MapKit/MapKit.h>
#import "CanvasViewDirectionalLines.h"
#import "TerrainModelLeftSideViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UndoRedoView.h"
#import "RotateView.h"
#import "DrawingView.h"

@class CanvasViewDirectionalLines;
@interface TerrainModelViewController : UIViewController <MFMailComposeViewControllerDelegate,UIScrollViewDelegate, UIAlertViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate>
{
    
    CanvasViewDirectionalLines * drawing_field_v2;
    DrawingAppLeftSideViewController * controller;
    UndoRedoView * undo_redo;
    RotateView * rotate_view;
    
    UIImageView * background;
    UIButton * add_labels;
    UIButton * new_object;
    UIButton * email_pdf;
    
    UIButton * foundation_icon;
    UIButton * details_icon;
    UIButton * note_icon;
    UIButton * clear;
    UIButton * done;
    
    NSMutableArray * drawing_labels;
    NSString * dataFilePath;
    TPKeyboardAvoidingScrollView * scrollable_view;
    
    MKMapView *map;
}
@property (strong, nonatomic) DrawingAppLeftSideViewController * controller;   
@property (strong, nonatomic) TPKeyboardAvoidingScrollView * scrollable_view;
@property (strong, nonatomic) CanvasViewDirectionalLines * drawing_field_v2;
@end
