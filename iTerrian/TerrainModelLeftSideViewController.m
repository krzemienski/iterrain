//
//  DrawingAppLeftSideViewController.m
//  MAW
//
//  Created by Nicholas Krzemienski on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TerrainModelLeftSideViewController.h"

@interface DrawingAppLeftSideViewController ()

@end

@implementation DrawingAppLeftSideViewController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self create];
    }
    return self;
}
- (void)create
{
    
    
   
    details_left = [[DetailsLeftSideView alloc] initWithFrame:CGRectMake(0, 0, 148/2, 713/2)];
   
    
    //Notificaitons to change each view.
  
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(details_icon_pressed) name:@"details_icon_pressed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comments_icon_pressed) name:@"comments_icon_pressed" object:nil];
    
    
    //Listen for the notifications to changes the size of the views in order to reduce on dead space from the controllers.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sub_menu_present_icons) name:@"sub_menu_present_icons" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sub_menu_present_line) name:@"sub_menu_present_line" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sub_menu_not_present) name:@"sub_menu_not_present" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sub_menu_present_colors) name:@"sub_menu_present_colors" object:nil];
	
}
-(void)sub_menu_present_icons
{
    details_left.frame = CGRectMake(0, 0, 74+177, 713/2);
    self.frame = CGRectMake(34, 134, 74+177, 713/2);    
    
}
-(void)sub_menu_present_line
{
    details_left.frame = CGRectMake(0, 0, 74+88, 713/2);
    self.frame = CGRectMake(34, 134, 74+88, 713/2);    
    
}
-(void)sub_menu_not_present
{
    details_left.frame = CGRectMake(0, 0, 74, 713/2);  
    self.frame = CGRectMake(34, 134, 74, 713/2);    
    
}
-(void)sub_menu_present_colors
{
    details_left.frame = CGRectMake(0, 0, 74+150, 713/2);  
    self.frame = CGRectMake(34, 134, 74+150, 713/2);    
    
}
-(void)foundation_icon_pressed
{
    for (UIView * to_be_removed in self.subviews)
    {
        [to_be_removed removeFromSuperview];
    }    
    
    self.frame = CGRectMake(34, 134, 292/2, 545/2);
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"draw_deselected" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"comments_deselected" object:nil];
    
    
}
-(void)details_icon_pressed
{
    for (UIView * to_be_removed in self.subviews)
    {
        [to_be_removed removeFromSuperview];       
        
    }    
    
    self.frame = CGRectMake(34, 134, 74, 713/2);
    [self addSubview:details_left];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"comments_deselected" object:nil];
    
 
  
    
}
-(void)comments_icon_pressed
{
    for (UIView * to_be_removed in self.subviews)
    {
        [to_be_removed removeFromSuperview];       
        
    }   

    self.frame = CGRectMake(34, 134, 0, 0);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"comments_selected" object:nil];    
 
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
