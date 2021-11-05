//
//  DrawingAppViewController.m
//  MAW
//
//  Created by Nicholas Krzemienski on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TerrainModelViewController.h"
#define METERS_PER_MILE 1609.344


@interface TerrainModelViewController ()

@end

@implementation TerrainModelViewController
@synthesize controller;
@synthesize scrollable_view;
@synthesize drawing_field_v2;

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
    background.image = [UIImage imageNamed:@"bg_main.png"];
    [self.view addSubview:background];    
       
    //INSERT DRAWING FIELD INTO A SCROLLVIEW TO ENABLE THE ZOOMING AND SCALING FEATURE.
    drawing_field_v2 = [[CanvasViewDirectionalLines alloc] initWithFrame:CGRectMake(0, 0, 1500, 1500)];
    drawing_field_v2.userInteractionEnabled = YES;
    scrollable_view = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(35, 134, 950, 500)];
    scrollable_view.userInteractionEnabled = YES;
    [scrollable_view setBouncesZoom:NO];
    [scrollable_view setContentOffset:CGPointMake(1000, 1000)];
    [scrollable_view setDelegate:self];
    [scrollable_view setContentSize:CGSizeMake(1500, 1500)];
    [scrollable_view setMaximumZoomScale:4.0];    
    [scrollable_view setMinimumZoomScale:1];
    
    map = [[MKMapView alloc] initWithFrame: CGRectMake(0, 0, 1500, 1500)];
	map.delegate = self;
    map.mapType = MKMapTypeSatellite;    
    map.userInteractionEnabled = NO;    
    [drawing_field_v2 addSubview:map];    
    
    DrawingView * test = [[DrawingView alloc] initWithFrame:CGRectMake(0, 0, 1500, 1500)];
    [drawing_field_v2 addSubview:test];
    [drawing_field_v2 bringSubviewToFront:test];
  
    
    
       
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 34.292750;
    zoomLocation.longitude= -116.034042;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);    
    // 3
    [map setRegion:viewRegion animated:NO];     
    
    //SET THE VIEW NOT BOUNCE, REPRESENTS A MAP BETTER.
    [scrollable_view setBounces:NO];
    
    [scrollable_view addSubview:drawing_field_v2]; 
    
    [self.view addSubview:scrollable_view];  
    
    
    //Add a button that triggers the drawing field 
    add_labels = [UIButton buttonWithType:UIButtonTypeCustom];
    add_labels.frame = CGRectMake(131, 655, 60, 60);
    //[add_textfield setImage:[UIImage imageNamed:@"btn_subs_netflix.png"] forState:UIControlStateNormal];  
    add_labels.backgroundColor = [UIColor clearColor];     
    [add_labels addTarget: self action:@selector(toggle_drawing_view) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:add_labels];   
    
    controller = [[DrawingAppLeftSideViewController alloc] initWithFrame:CGRectMake(34, 134, 292/2, 775)];  
    controller.backgroundColor = [UIColor clearColor];
    [self.view addSubview:controller];
    
    undo_redo = [[UndoRedoView alloc] initWithFrame:CGRectMake(34, 605, 120, 71/2)];
    [self.view addSubview:undo_redo];
    
    rotate_view = [[RotateView alloc] initWithFrame:CGRectMake(940, 605, 77/2, 71/2)];
    [self.view addSubview:rotate_view];
        
    email_pdf = [UIButton buttonWithType:UIButtonTypeCustom];
    email_pdf.frame = CGRectMake(95, 120, 60, 60);
    //[add_textfield setImage:[UIImage imageNamed:@"btn_subs_netflix.png"] forState:UIControlStateNormal];  
    email_pdf.backgroundColor = [UIColor blueColor];     
    [email_pdf addTarget: self action:@selector(email_pdf) forControlEvents:UIControlEventTouchUpInside];
    
    foundation_icon = [UIButton buttonWithType:UIButtonTypeCustom];
    foundation_icon.frame = CGRectMake(75, 660, 155/2, 155/2);
    [foundation_icon setImage:[UIImage imageNamed:@"btn_foundation.png"] forState:UIControlStateNormal];
    [foundation_icon setImage:[UIImage imageNamed:@"btn_foundation_pressed.png"] forState:UIControlStateHighlighted];
    foundation_icon.backgroundColor = [UIColor clearColor];     
    [foundation_icon addTarget: self action:@selector(foundation_icon_pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:foundation_icon];
    
    details_icon = [UIButton buttonWithType:UIButtonTypeCustom];
    details_icon.frame = CGRectMake(157, 660, 155/2, 155/2);
    [details_icon setImage:[UIImage imageNamed:@"btn_details.png"] forState:UIControlStateNormal];
    [details_icon setImage:[UIImage imageNamed:@"btn_details_pressed.png"] forState:UIControlStateHighlighted];
    details_icon.backgroundColor = [UIColor clearColor];     
    [details_icon addTarget: self action:@selector(details_icon_pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:details_icon];

    note_icon = [UIButton buttonWithType:UIButtonTypeCustom];
    note_icon.frame = CGRectMake(239, 660, 155/2, 155/2);
    [note_icon setImage:[UIImage imageNamed:@"btn_comments.png"] forState:UIControlStateNormal]; 
    [note_icon setImage:[UIImage imageNamed:@"btn_comments_pressed.png"] forState:UIControlStateHighlighted];
    note_icon.backgroundColor = [UIColor clearColor];     
    [note_icon addTarget: self action:@selector(note_icon_pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:note_icon];
    
    clear = [UIButton buttonWithType:UIButtonTypeCustom];
    clear.frame = CGRectMake(821, 660, 155/2, 155/2);
    [clear setImage:[UIImage imageNamed:@"btn_clear.png"] forState:UIControlStateNormal];
    [clear setImage:[UIImage imageNamed:@"btn_clear_pressed.png"] forState:UIControlStateHighlighted];
    clear.backgroundColor = [UIColor clearColor];     
    [clear addTarget: self action:@selector(clear_pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clear];    
    
    done = [UIButton buttonWithType:UIButtonTypeCustom];
    done.frame = CGRectMake(900, 660, 155/2, 155/2);
    [done setImage:[UIImage imageNamed:@"btn_next.png"] forState:UIControlStateNormal];
    [done setImage:[UIImage imageNamed:@"btn_next_pressed.png"] forState:UIControlStateNormal];
    done.backgroundColor = [UIColor clearColor];     
    [done addTarget: self action:@selector(done_pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:done];
    
    [self details_icon_pressed];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(draw_selected) name:@"draw_selected" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(draw_deselected) name:@"draw_deselected" object:nil];    
    
    
}
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    //[map removeFromSuperview];
    //drawing_field_v2.background.image = [self renderToImage:mapView];
    //drawing_field_v2.background.image = [self renderToImage:mapView];
    //[self createPDFfromUIView:mapView saveToDocumentsWithFileName:@"map.jpeg"];
}
- (UIImage*) renderToImage :(UIView*)mapView
{
    UIGraphicsBeginImageContext(mapView.frame.size);
    [mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(void)draw_selected
{   
    scrollable_view.scrollEnabled = NO;
    [scrollable_view setMaximumZoomScale:1];    
    [scrollable_view setMinimumZoomScale:1];
    scrollable_view.multipleTouchEnabled = NO;
   
    
}
-(void)draw_deselected
{   
    scrollable_view.scrollEnabled = YES;
    [scrollable_view setMaximumZoomScale:4.0];    
    [scrollable_view setMinimumZoomScale:1];
    scrollable_view.multipleTouchEnabled = YES;
    
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)? 
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)? 
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, 
                                 scrollView.contentSize.height * 0.5 + offsetY); 
    
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   //CREATE SINGLETON CLASSES!! 
    
}
-(void)done_pressed
{
      //you are now finished with your drawing move onto the next step. 
    
    
}
-(void)foundation_icon_pressed
{
    //send message to leftside controller to be the drawing line tool version of the controller.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"foundation_icon_pressed" object:nil];
    [foundation_icon setImage:[UIImage imageNamed:@"btn_foundation_pressed.png"] forState:UIControlStateNormal];
    [details_icon setImage:[UIImage imageNamed:@"btn_details.png"] forState:UIControlStateNormal];
    [note_icon setImage:[UIImage imageNamed:@"btn_comments.png"] forState:UIControlStateNormal];
    [clear setImage:[UIImage imageNamed:@"btn_clear.png"] forState:UIControlStateNormal];
   
    
}
-(void)details_icon_pressed
{
   //send message to leftside controller to be the click and drag of icons sections of the controller.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"details_icon_pressed" object:nil];
    [foundation_icon setImage:[UIImage imageNamed:@"btn_foundation.png"] forState:UIControlStateNormal];
    [details_icon setImage:[UIImage imageNamed:@"btn_details_pressed.png"] forState:UIControlStateNormal];
    [note_icon setImage:[UIImage imageNamed:@"btn_comments.png"] forState:UIControlStateNormal];
    [clear setImage:[UIImage imageNamed:@"btn_clear.png"] forState:UIControlStateNormal];
    
    
}
-(void)note_icon_pressed
{
   //send message to leftside controller to where the person touches you create a text field and they can add notes.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"comments_icon_pressed" object:nil];
    [foundation_icon setImage:[UIImage imageNamed:@"btn_foundation.png"] forState:UIControlStateNormal];
    [details_icon setImage:[UIImage imageNamed:@"btn_details.png"] forState:UIControlStateNormal];
    [note_icon setImage:[UIImage imageNamed:@"btn_comments_pressed.png"] forState:UIControlStateNormal];
    [clear setImage:[UIImage imageNamed:@"btn_clear.png"] forState:UIControlStateNormal];
    
    
}
-(void)clear_pressed
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"WARNING" message: @"YOU WILL CLEAR THE ENTIRE DRAWING AND HAVE NOW WAY OF GOING BACK!" delegate: self cancelButtonTitle: @"OK" otherButtonTitles:@"Cancel",nil];
    alert.tag = 4;
    [alert show];
    [alert release];   
   //clear the entire drawing app. First ask the user if they are sure.
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 4) 
    {
        if(buttonIndex == 0) 
        {
            //User pressed ok!
            [[NSNotificationCenter defaultCenter] postNotificationName:@"clear_icon_pressed" object:nil];
            [self foundation_icon_pressed];  
        }
    }
    
    
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    return drawing_field_v2;
    
    
}
-(void)email_pdf
{
    [self send_email_pdf:drawing_field_v2 emailWithFileName:@"InteriorFloorPlan"];
    
}
-(void)send_email_pdf:(UIView*)aView emailWithFileName:(NSString*)aFilename
{
    NSMutableData *pdfData = [NSMutableData data];

     UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
     UIGraphicsBeginPDFPage();
     CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    
     [aView.layer renderInContext:pdfContext];

     UIGraphicsEndPDFContext();

    
    MFMailComposeViewController *vc = [[[MFMailComposeViewController alloc] init] autorelease];
    [vc setSubject:@"Interior Floor Plan PDF"];
    NSString *emailBody = @"Interior floor plan attatched";
    [vc setMessageBody:emailBody isHTML:NO];
    [vc addAttachmentData:pdfData mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"%@.pdf",aFilename]]; 
    vc.mailComposeDelegate = self;
    [self.view presentModalViewController:vc animated:YES];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{      
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}
-(void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    
    
    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
    
    [aView.layer renderInContext:pdfContext];
    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
    
    
}
-(void)add_textfield_pressed
{    
    UITextField * new_label = [[UITextField alloc] initWithFrame:CGRectMake(40, 920, 50, 20)];
    new_label.textAlignment = UITextAlignmentCenter;
    new_label.font = [UIFont fontWithName:@"Arial" size:18];    
    [self.view addSubview:new_label];    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{    
    
    [super touchesBegan:touches withEvent:event];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{     
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);  
       
}
@end
