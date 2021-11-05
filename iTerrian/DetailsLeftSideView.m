//
//  DetailsLeftSideViewController.m
//  MAW
//
//  Created by Nicholas Krzemienski on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailsLeftSideView.h"

@interface DetailsLeftSideView ()

@end

@implementation DetailsLeftSideView

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self create];
    }
    return self;
    
}
-(void)create
{
    exterior = NO;
    interior = NO;
    
    color = NO;
    line = NO;
    draw = NO;
    text = NO;
    straight_line = NO;
    
    background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 148/2, 713/2)];
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    [self addSubview:background];
    
    current_background_line_style = [[UIImage alloc] init];
    current_background_line_style = [UIImage imageNamed:@"line_type.png"];
    current_background_color = [[UIImage alloc] init];
    current_background_color = [UIImage imageNamed:@"colors_unselected.png"];
    current_background_exterior = [[UIImage alloc] init];
    current_background_exterior = [UIImage imageNamed:@"icons_ext_B.PNG"];
    current_background_interior = [[UIImage alloc] init];
    current_background_interior = [UIImage imageNamed:@"icons_int_B.png"];
    
    sub_menu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 353/2, 773/2)];
    sub_menu_background = [[UIImageView alloc] initWithFrame:sub_menu.frame];
    
    icon_overlay_interior = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 50)];
    icon_overlay_interior.image = [UIImage imageNamed:@"icons_overlay.png"];
    
    icon_overlay_exterior = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 50)];
    icon_overlay_exterior.image = [UIImage imageNamed:@"icons_overlay.png"];
    
    interior_tool = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 148/2, 47)];
    interior_tool.backgroundColor = [UIColor clearColor];
    [interior_tool addTarget:self action:@selector(interior_tool_selected) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:interior_tool];
    
    exterior_tool = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, 148/2, 47)];
    exterior_tool.backgroundColor = [UIColor clearColor];
    [exterior_tool addTarget:self action:@selector(exterior_tool_selected) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:exterior_tool];

    draw_tool = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 148/2, 47)];
    draw_tool.backgroundColor = [UIColor clearColor];
    [draw_tool addTarget:self action:@selector(draw_tool_selected) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:draw_tool];
    
    straight_line_tool = [[UIButton alloc] initWithFrame:CGRectMake(0, 150, 148/2, 47)];
    straight_line_tool.backgroundColor = [UIColor clearColor];
    [straight_line_tool addTarget:self action:@selector(straight_line_tool_selected) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:straight_line_tool];
    
    text_tool = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, 148/2, 47)];
    text_tool.backgroundColor = [UIColor clearColor];
    [text_tool addTarget:self action:@selector(text_tool_selected) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:text_tool];
    
    line_tool = [[UIButton alloc] initWithFrame:CGRectMake(0, 250, 148/2, 47)];
    line_tool.backgroundColor = [UIColor clearColor];
    [line_tool addTarget:self action:@selector(line_tool_selected) forControlEvents:UIControlEventTouchUpInside];    
    [self addSubview:line_tool];   
    
    color_tool = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, 148/2, 47)];
    color_tool.backgroundColor = [UIColor clearColor];
    [color_tool addTarget:self action:@selector(color_tool_selected) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:color_tool];
    
    //Intialize all the buttons for the interior icons.
    int_1 = [[UIButton alloc] init];        
    int_2 = [[UIButton alloc] init];    
    int_3 = [[UIButton alloc] init];
    int_4 = [[UIButton alloc] init];
    int_5 = [[UIButton alloc] init];
    int_6 = [[UIButton alloc] init];
    int_7 = [[UIButton alloc] init];
    int_8 = [[UIButton alloc] init];
    int_9 = [[UIButton alloc] init];
    int_10 = [[UIButton alloc] init];
    int_11 = [[UIButton alloc] init];
    
    //Intialize all the buttons for the exterior icons.
    ext_1 = [[UIButton alloc] init];
    ext_2 = [[UIButton alloc] init];
    ext_3 = [[UIButton alloc] init];
    ext_4 = [[UIButton alloc] init];
    ext_5 = [[UIButton alloc] init];
    ext_6 = [[UIButton alloc] init];
    ext_7 = [[UIButton alloc] init];
    ext_8 = [[UIButton alloc] init];
    ext_9 = [[UIButton alloc] init];
    ext_10 = [[UIButton alloc] init];
    ext_11 = [[UIButton alloc] init];
    
    circle_interior = [[UIButton alloc] init];
    circle_exterior = [[UIButton alloc] init];
    square_interior = [[UIButton alloc] init];
    square_exterior = [[UIButton alloc] init];
    
    //Intialize all the buttons for the colors
    
    red = [[UIButton alloc] init];
    blue = [[UIButton alloc] init];
    green = [[UIButton alloc] init];
    light_blue = [[UIButton alloc] init];
    light_green = [[UIButton alloc] init];
    light_yellow = [[UIButton alloc] init];
    pink = [[UIButton alloc] init];   
    yellow = [[UIButton alloc] init]; 
    black = [[UIButton alloc] init];
    gray = [[UIButton alloc] init]; 
    
    //Intialize all the buttons for the line styles
    normal = [[UIButton alloc] init];
    thick = [[UIButton alloc] init];
    dotted = [[UIButton alloc] init];
    super_dotted = [[UIButton alloc] init];
    
    //Undo and redo buttons    
    [self normal_pressed];
    [self black_pressed];
    
}
-(void)interior_tool_selected
{
    exterior = NO;
    
    color = NO;    
    line = NO;    
    draw = NO;
    text = NO;
    straight_line = NO;
    if (!interior)
    {
    [self clear_sub_menu];    
    [sub_menu_background removeFromSuperview];    
    //Change the views frame then add the background image to the view with the frame form the view.
    
    sub_menu.frame = CGRectMake(64, 0, 353/2, 773/2);
    sub_menu_background.image = current_background_interior;
    sub_menu_background.frame = CGRectMake(0, 0, 353/2, 773/2);    
    [sub_menu addSubview:sub_menu_background];
    //Set up the buttons and then add them to the uiview.
    
    int_1.frame = CGRectMake(23, 17, 57, 42);
    int_1.backgroundColor = [UIColor clearColor];
    [int_1 addTarget:self action:@selector(int_1_pressed) forControlEvents:UIControlEventTouchUpInside];
    [sub_menu addSubview:int_1];
        
    int_2.frame = CGRectMake(93, 17, 57, 42);
    int_2.backgroundColor = [UIColor clearColor];
    [int_2 addTarget:self action:@selector(int_2_pressed) forControlEvents:UIControlEventTouchUpInside];
    [sub_menu addSubview:int_2];
        
    int_3.frame = CGRectMake(23, 70, 57, 42);
    int_3.backgroundColor = [UIColor clearColor];
    [int_3 addTarget:self action:@selector(int_3_pressed) forControlEvents:UIControlEventTouchUpInside];
    [sub_menu addSubview:int_3];    
        
    int_4.frame = CGRectMake(93, 70, 57, 42);
    int_4.backgroundColor = [UIColor clearColor];
    [int_4 addTarget:self action:@selector(int_4_pressed) forControlEvents:UIControlEventTouchUpInside];
    [sub_menu addSubview:int_4];  
        
    int_5.frame = CGRectMake(23, 122, 57, 42);
    int_5.backgroundColor = [UIColor clearColor];
    [int_5 addTarget:self action:@selector(int_5_pressed) forControlEvents:UIControlEventTouchUpInside];
    [sub_menu addSubview:int_5]; 
        
    int_6.frame = CGRectMake(93, 122, 57, 42);
    int_6.backgroundColor = [UIColor clearColor];
    [int_6 addTarget:self action:@selector(int_6_pressed) forControlEvents:UIControlEventTouchUpInside];
    [sub_menu addSubview:int_6]; 
        
    int_7.frame = CGRectMake(23, 175, 57, 42);
    int_7.backgroundColor = [UIColor clearColor];
    [int_7 addTarget:self action:@selector(int_7_pressed) forControlEvents:UIControlEventTouchUpInside];
    [sub_menu addSubview:int_7];    
        
    int_8.frame = CGRectMake(93, 175, 57, 42);
    int_8.backgroundColor = [UIColor clearColor];
    [int_8 addTarget:self action:@selector(int_8_pressed) forControlEvents:UIControlEventTouchUpInside];
    [sub_menu addSubview:int_8];   
        
    int_9.frame = CGRectMake(23, 224, 57, 42);
    int_9.backgroundColor = [UIColor clearColor];
    [int_9 addTarget:self action:@selector(int_9_pressed) forControlEvents:UIControlEventTouchUpInside];
    [sub_menu addSubview:int_9];  
        
    int_10.frame = CGRectMake(93, 224, 57, 42);
    int_10.backgroundColor = [UIColor clearColor];
    [int_10 addTarget:self action:@selector(int_10_pressed) forControlEvents:UIControlEventTouchUpInside];
    [sub_menu addSubview:int_10];
        
    int_11.frame = CGRectMake(58, 276, 57, 42);
    int_11.backgroundColor = [UIColor clearColor];
    [int_11 addTarget:self action:@selector(int_11_pressed) forControlEvents:UIControlEventTouchUpInside];
    [sub_menu addSubview:int_11];
        
    if (icon_overlay_interior.frame.origin.x == 0 && icon_overlay_interior.frame.origin.y == 0) 
    {
        //do nothing because no icon has never been selected!
    } 
    else 
    {
        [sub_menu addSubview:icon_overlay_interior]; 
    }       
    //add the submenu to the main controller's view.
    
    circle_interior.frame = CGRectMake(23, 330, 57, 42);
    circle_interior.backgroundColor = [UIColor clearColor];
    [circle_interior addTarget:self action:@selector(circle_interior_pressed) forControlEvents:UIControlEventTouchUpInside];
    [sub_menu addSubview:circle_interior];
    
    square_interior.frame = CGRectMake(93, 330, 57, 42);
    square_interior.backgroundColor = [UIColor clearColor];
    [square_interior addTarget:self action:@selector(square_interior_pressed) forControlEvents:UIControlEventTouchUpInside];
    [sub_menu addSubview:square_interior];
    
    [self addSubview:sub_menu];
    //change the details controller view's background.
    
    background.image = [UIImage imageNamed:@"toll_bar_1_interior_icons.png"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"draw_deselected" object:nil];  
    //Tell view controller to change its frame to fit the submenu.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sub_menu_present_icons" object:nil];
    }
    else 
    {
     
        background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
        [self clear_sub_menu];
        [sub_menu removeFromSuperview];
        
        
    }
    interior = !interior;
    
    
    
    
}
-(void)exterior_tool_selected
{
    
    interior = NO;
    color = NO;
    
    straight_line = NO;
    line = NO;
    draw = NO;
    text = NO;
    if (!exterior)
    {
        sub_menu.frame = CGRectMake(64, 0, 353/2, 773/2);
        sub_menu_background.image = current_background_exterior;
        sub_menu_background.frame = CGRectMake(0, 0, 353/2, 773/2);    
        [sub_menu addSubview:sub_menu_background];
        //Set up the buttons and then add them to the uiview.
        
        ext_1.frame = CGRectMake(23, 17, 57, 42);
        ext_1.backgroundColor = [UIColor clearColor];
        [ext_1 addTarget:self action:@selector(ext_1_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:ext_1];
        
        ext_2.frame = CGRectMake(93, 17, 57, 42);
        ext_2.backgroundColor = [UIColor clearColor];
        [ext_2 addTarget:self action:@selector(ext_2_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:ext_2];
        
        ext_3.frame = CGRectMake(23, 70, 57, 42);
        ext_3.backgroundColor = [UIColor clearColor];
        [ext_3 addTarget:self action:@selector(ext_3_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:ext_3];
        
        ext_4.frame = CGRectMake(93, 70, 57, 42);
        ext_4.backgroundColor = [UIColor clearColor];
        [ext_4 addTarget:self action:@selector(ext_4_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:ext_4];
        
        ext_5.frame = CGRectMake(23, 122, 57, 42);
        ext_5.backgroundColor = [UIColor clearColor];
        [ext_5 addTarget:self action:@selector(ext_5_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:ext_5];
        
        ext_6.frame = CGRectMake(93, 122, 57, 42);
        ext_6.backgroundColor = [UIColor clearColor];
        [ext_6 addTarget:self action:@selector(ext_6_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:ext_6];
        
        ext_7.frame = CGRectMake(23, 175, 57, 42);
        ext_7.backgroundColor = [UIColor clearColor];
        [ext_7 addTarget:self action:@selector(ext_7_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:ext_7];
        
        ext_8.frame = CGRectMake(93, 175, 57, 42);
        ext_8.backgroundColor = [UIColor clearColor];
        [ext_8 addTarget:self action:@selector(ext_8_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:ext_8];
        
        ext_9.frame = CGRectMake(23, 224, 57, 42);
        ext_9.backgroundColor = [UIColor clearColor];
        [ext_9 addTarget:self action:@selector(ext_9_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:ext_9];
        
        ext_10.frame = CGRectMake(93, 224, 57, 42);
        ext_10.backgroundColor = [UIColor clearColor];
        [ext_10 addTarget:self action:@selector(ext_10_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:ext_10];
        
        ext_11.frame = CGRectMake(58, 276, 57, 42);
        ext_11.backgroundColor = [UIColor clearColor];
        [ext_11 addTarget:self action:@selector(ext_11_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:ext_11];
        
        if (icon_overlay_exterior.frame.origin.x == 0 && icon_overlay_exterior.frame.origin.y == 0)
        {
            //do nothing because no icon has never been selected!
        }
        else
        {
            [sub_menu addSubview:icon_overlay_exterior];
        }
        //add the submenu to the main controller's view.
        
        circle_exterior.frame = CGRectMake(23, 330, 57, 42);
        circle_exterior.backgroundColor = [UIColor clearColor];
        [circle_exterior addTarget:self action:@selector(circle_exterior_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:circle_exterior];
        
        square_exterior.frame = CGRectMake(93, 330, 57, 42);
        square_exterior.backgroundColor = [UIColor clearColor];
        [square_exterior addTarget:self action:@selector(square_exterior_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:square_exterior];
        
        [self addSubview:sub_menu];
        //change the details controller view's background.
        background.image = [UIImage imageNamed:@"toll_bar_2_exterior_icons.png"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"draw_deselected" object:nil];
        
        //Tell the view controller a submenu is present. A bigger one.
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sub_menu_present_icons" object:nil];  
    }
    else 
    {
        background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
        [self clear_sub_menu];
        [sub_menu removeFromSuperview];

    }
    exterior = !exterior;
    
    
}
-(void)draw_tool_selected
{
    exterior = NO;
    interior = NO;
    
    straight_line = NO;
    color = NO;
    line = NO;    
    text = NO;
    if (!draw)
    {
        [sub_menu removeFromSuperview];
        background.image = [UIImage imageNamed:@"toll_bar_3_draw.png"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"draw_selected" object:nil];
        
        //Tell that no submenu is present.
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sub_menu_not_present" object:nil];  
    }
    else 
    {
        background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
        [self clear_sub_menu];
        [sub_menu removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"draw_deselected" object:nil];

        
    }
    draw = !draw;
   
    
}
-(void)text_tool_selected
{  
    exterior = NO;
    interior = NO;
    
    straight_line = NO;
    color = NO;
    line = NO;
    draw = NO;
   
    if (!text) 
    {
        [sub_menu removeFromSuperview];    
        background.image = [UIImage imageNamed:@"toll_bar_4_type.png"];    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"text_selected" object:nil];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"draw_deselected" object:nil];
        //Tell that no submenu is present
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sub_menu_not_present" object:nil];
        
    }
    else 
    {
        background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
        [self clear_sub_menu];
        [sub_menu removeFromSuperview];
        
        //POST NOTIFICATION SO THAT THE NEXT TOUCH WILL NO LONGER PLACE TEXT.
        [[NSNotificationCenter defaultCenter] postNotificationName:@"text_deselected" object:nil];
        
        
    }
    text = !text;
    
}
-(void)line_tool_selected
{
    exterior = NO;
    interior = NO;
    
    color = NO;
    straight_line = NO;
    draw = NO;
    text = NO;
    if (!line)
    {
        [sub_menu removeFromSuperview];     
        sub_menu.frame = CGRectMake(64, 105, 177/2, 504/2);
        sub_menu_background.image = current_background_line_style;
        sub_menu_background.frame = CGRectMake(0, 0, 177/2, 504/2);
        [sub_menu addSubview:sub_menu_background];
        [self addSubview:sub_menu];
        
        background.image = [UIImage imageNamed:@"toll_bar_5_line_type.png"];
        
        normal.frame = CGRectMake(18, 13, 50, 50);
        normal.backgroundColor = [UIColor clearColor];
        [normal addTarget:self action:@selector(normal_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:normal];
        
        thick.frame = CGRectMake(18, 70, 50, 50);
        thick.backgroundColor = [UIColor clearColor];
        [thick addTarget:self action:@selector(thick_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:thick];
        
        dotted.frame = CGRectMake(18, 70+58, 50, 50);
        dotted.backgroundColor = [UIColor clearColor];
        [dotted addTarget:self action:@selector(dotted_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:dotted];
        
        super_dotted.frame = CGRectMake(18, 70+58+58, 50, 50);
        super_dotted.backgroundColor = [UIColor clearColor];
        [super_dotted addTarget:self action:@selector(super_dotted_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:super_dotted];
        
        //Submenu present but not that big.
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sub_menu_present_line" object:nil];
    }
    else 
    {
        background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
        [self clear_sub_menu];
        [sub_menu removeFromSuperview];
        
    }
    line = !line;
    

    
    
    
    
}
-(void)color_tool_selected
{   
    exterior = NO;
    interior = NO;
  
    line = NO;
    draw = NO;
    text = NO;
    straight_line = NO;
    if (!color) 
    {
        [self clear_sub_menu];
        
        [sub_menu removeFromSuperview];   
        
        sub_menu.frame = CGRectMake(64, 53, 299/2, 613/2);
        sub_menu_background.image = current_background_color;
        sub_menu_background.frame = CGRectMake(0, 0, 299/2, 613/2);
        [sub_menu addSubview:sub_menu_background];
        [self addSubview:sub_menu];    
        background.image = [UIImage imageNamed:@"toll_bar_6_color_pressed.png"];
        
        red.frame = CGRectMake(18, 13, 50, 50);
        red.backgroundColor = [UIColor clearColor];
        [red addTarget:self action:@selector(red_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:red];
        
        pink.frame = CGRectMake(77, 13, 50, 50);
        pink.backgroundColor = [UIColor clearColor];
        [pink addTarget:self action:@selector(pink_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:pink];
        
        yellow.frame = CGRectMake(18, 70, 50, 50);
        yellow.backgroundColor = [UIColor clearColor];
        [yellow addTarget:self action:@selector(yellow_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:yellow];
        
        light_yellow.frame = CGRectMake(77, 70, 50, 50);
        light_yellow.backgroundColor = [UIColor clearColor];
        [light_yellow addTarget:self action:@selector(light_yellow_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:light_yellow];
        
        green.frame = CGRectMake(18, 127, 50, 50);
        green.backgroundColor = [UIColor clearColor];
        [green addTarget:self action:@selector(green_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:green];
        
        light_green.frame = CGRectMake(77, 127, 50, 50);
        light_green.backgroundColor = [UIColor clearColor];
        [light_green addTarget:self action:@selector(light_green_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:light_green];
        
        blue.frame = CGRectMake(18, 127+58, 50, 50);
        blue.backgroundColor = [UIColor clearColor];
        [blue addTarget:self action:@selector(blue_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:blue];
        
        light_blue.frame = CGRectMake(77, 127+58, 50, 50);
        light_blue.backgroundColor = [UIColor clearColor];
        [light_blue addTarget:self action:@selector(light_blue_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:light_blue];
        
        black.frame = CGRectMake(18, 127+116, 50, 50);
        black.backgroundColor = [UIColor clearColor];
        [black addTarget:self action:@selector(black_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:black];
        
        gray.frame = CGRectMake(77, 127+116, 50, 50);
        gray.backgroundColor = [UIColor clearColor];
        [gray addTarget:self action:@selector(gray_pressed) forControlEvents:UIControlEventTouchUpInside];
        [sub_menu addSubview:gray]; 
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sub_menu_present_colors" object:nil];  
    }
    else 
    {
        background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
        [self clear_sub_menu];
        [sub_menu removeFromSuperview];
        
    }
    color = !color;
    
    
    
        
}
-(void)straight_line_tool_selected
{
    
    exterior = NO;
    interior = NO;
    
    color = NO;
    line = NO;
    text = NO;
    draw = NO;
    
    if (!straight_line)
    {
        [sub_menu removeFromSuperview];
        background.image = [UIImage imageNamed:@"toll_bar_3_ALT_draw.png"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"straight_line_selected" object:nil];
        
        //Tell that no submenu is present.
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sub_menu_not_present" object:nil];
    }
    else
    {
        background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
        [self clear_sub_menu];
        [sub_menu removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"straight_line_deselected" object:nil];
        
        
    }
    straight_line = !straight_line;   
    
    
}
-(void)clear_sub_menu
{
    for (UIView * to_be_removed in sub_menu.subviews) 
    {
        [to_be_removed removeFromSuperview];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sub_menu_not_present" object:nil];
  
}
-(void)int_1_pressed
{
    //change the frame of the icon overlay image to make it look like a selected state.
    icon_overlay_interior.frame = int_1.frame;
    //Chnage the background image to the image with that slected icon.        
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"int_1"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    
    interior = !interior;    
    
}
-(void)int_2_pressed
{
    //change the frame of the icon overlay image to make it look like a selected state.
    icon_overlay_interior.frame = int_2.frame;
    //Chnage the background image to the image with that slected icon.  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"int_2"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    interior = !interior;    
    
}
-(void)int_3_pressed
{
    //change the frame of the icon overlay image to make it look like a selected state.
    icon_overlay_interior.frame = int_3.frame;
    //Chnage the background image to the image with that slected icon.  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"int_3"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    interior = !interior;    
    
}
-(void)int_4_pressed
{
    //change the frame of the icon overlay image to make it look like a selected state.
    icon_overlay_interior.frame = int_4.frame;
    //Chnage the background image to the image with that slected icon.  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"int_4"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    interior = !interior;    
    
}
-(void)int_5_pressed
{
    //change the frame of the icon overlay image to make it look like a selected state.
    icon_overlay_interior.frame = int_5.frame;
    //Chnage the background image to the image with that slected icon.  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"int_5"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    interior = !interior;    
    
}
-(void)int_6_pressed
{
    //change the frame of the icon overlay image to make it look like a selected state.
    icon_overlay_interior.frame = int_6.frame;
    //Chnage the background image to the image with that slected icon.  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"int_6"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    interior = !interior;    
    
}
-(void)int_7_pressed
{
    //change the frame of the icon overlay image to make it look like a selected state.
    icon_overlay_interior.frame = int_7.frame;
    //Chnage the background image to the image with that slected icon.  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"int_7"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    interior = !interior;    
    
}
-(void)int_8_pressed
{
    //change the frame of the icon overlay image to make it look like a selected state.
    icon_overlay_interior.frame = int_8.frame;
    //Chnage the background image to the image with that slected icon.  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"int_8"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    interior = !interior;    
    
}
-(void)int_9_pressed
{
    //change the frame of the icon overlay image to make it look like a selected state.
    icon_overlay_interior.frame = int_9.frame;
    //Chnage the background image to the image with that slected icon.  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"int_9"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    interior = !interior;    
    
}
-(void)int_10_pressed
{
    //change the frame of the icon overlay image to make it look like a selected state.
    icon_overlay_interior.frame = int_10.frame;
    //Chnage the background image to the image with that slected icon.  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"int_10"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    interior = !interior;    
    
}
-(void)int_11_pressed
{
    //change the frame of the icon overlay image to make it look like a selected state.
    icon_overlay_interior.frame = int_11.frame;
    //Chnage the background image to the image with that slected icon.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"int_11"];
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    interior = !interior;
    
}

-(void)ext_1_pressed
{
    //change the frame of the icon overlay image to make it look like a selected state.
    icon_overlay_exterior.frame = ext_1.frame;
    //Chnage the background image to the image with that slected icon.  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"ext_1"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    exterior = !exterior;    
    
}
-(void)ext_2_pressed
{
    //change the frame of the icon overlay image to make it look like a selected state.
    icon_overlay_exterior.frame = ext_2.frame;
    //Chnage the background image to the image with that slected icon.  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"ext_2"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    exterior = !exterior;    
    
}
-(void)ext_3_pressed
{
    //change the frame of the icon overlay image to make it look like a selected state.
    icon_overlay_exterior.frame = ext_3.frame;
    //Chnage the background image to the image with that slected icon.  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"ext_3"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    exterior = !exterior;     
    
}
-(void)ext_4_pressed
{
    //change the frame of the icon overlay image to make it look like a selected state.
    icon_overlay_exterior.frame = ext_4.frame;
    //Chnage the background image to the image with that slected icon.  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"ext_4"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    exterior = !exterior;      
    
}
-(void)ext_5_pressed
{
    NSLog(@"here");
    //change the frame of the icon overlay image to make it look like a selected state.
    icon_overlay_exterior.frame = ext_5.frame;
    //Chnage the background image to the image with that slected icon.  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"ext_5"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    exterior = !exterior;     
    
}
-(void)ext_6_pressed
{
    //change the frame of the icon overlay image to make it look like a selected state.
    icon_overlay_exterior.frame = ext_6.frame;
    //Chnage the background image to the image with that slected icon.  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"ext_6"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    exterior = !exterior;     
    
}
-(void)ext_7_pressed
{
    //change the frame of the icon overlay image to make it look like a selected state.
    icon_overlay_exterior.frame = ext_7.frame;
    //Chnage the background image to the image with that slected icon.  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"ext_7"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    exterior = !exterior;     
    
}
-(void)ext_8_pressed
{
    //change the frame of the icon overlay image to make it look like a selected state.
    icon_overlay_exterior.frame = ext_8.frame;
    //Chnage the background image to the image with that slected icon.  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"ext_8"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    exterior = !exterior;      
    
}
-(void)ext_9_pressed
{
    //change the frame of the icon overlay image to make it look like a selected state.
    icon_overlay_exterior.frame = ext_9.frame;
    //Chnage the background image to the image with that slected icon.  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"ext_9"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
   exterior = !exterior;     
    
}
-(void)ext_10_pressed
{
    //change the frame of the icon overlay image to make it look like a selected state.
    icon_overlay_exterior.frame = ext_10.frame;
    //Chnage the background image to the image with that slected icon.  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"ext_10"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    exterior = !exterior;     
    
}
-(void)ext_11_pressed
{
    //change the frame of the icon overlay image to make it look like a selected state.
    icon_overlay_exterior.frame = ext_11.frame;
    //Chnage the background image to the image with that slected icon.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"ext_11"];
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    exterior = !exterior;
    
}

-(void)red_pressed
{
   current_background_color = [UIImage imageNamed:@"colors_red.png"]; 
   sub_menu_background.image = current_background_color;
   [[NSNotificationCenter defaultCenter] postNotificationName:@"a_color_pressed" object:@"red"];
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    color = !color;
     background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    
}
-(void)pink_pressed
{
    current_background_color = [UIImage imageNamed:@"colors_pink.png"]; 
    sub_menu_background.image = current_background_color;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"a_color_pressed" object:@"pink"];
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];

    color = !color;
     background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    
}
-(void)yellow_pressed
{
    current_background_color = [UIImage imageNamed:@"colors_yellow.png"]; 
    sub_menu_background.image = current_background_color;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"a_color_pressed" object:@"yellow"];
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    color = !color;
     background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];

    
}
-(void)light_yellow_pressed
{
    current_background_color = [UIImage imageNamed:@"colors_light_yellow.png"]; 
    sub_menu_background.image = current_background_color;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"a_color_pressed" object:@"light_yellow"];
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    color = !color;
     background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];

    
}
-(void)green_pressed
{
    current_background_color = [UIImage imageNamed:@"colors_green.png"]; 
    sub_menu_background.image = current_background_color;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"a_color_pressed" object:@"green"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    color = !color;
     background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];

    
}
-(void)light_green_pressed
{
    current_background_color = [UIImage imageNamed:@"colors_light_green.png"]; 
    sub_menu_background.image = current_background_color;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"a_color_pressed" object:@"light_green"];
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    color = !color;
     background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];

    
}
-(void)blue_pressed
{
    current_background_color = [UIImage imageNamed:@"colors_blue.png"]; 
    sub_menu_background.image = current_background_color;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"a_color_pressed" object:@"blue"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    color = !color;
     background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];

    
}
-(void)light_blue_pressed
{
    current_background_color = [UIImage imageNamed:@"colors_light_blue.png"]; 
    sub_menu_background.image = current_background_color;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"a_color_pressed" object:@"light_blue"];
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    color = !color;
     background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];

    
}
-(void)black_pressed
{
    current_background_color = [UIImage imageNamed:@"colors_black.png"]; 
    sub_menu_background.image = current_background_color;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"a_color_pressed" object:@"black"];  
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    color = !color;
     background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];

    
}
-(void)gray_pressed
{
    current_background_color = [UIImage imageNamed:@"colors_white.png"]; 
    sub_menu_background.image = current_background_color;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"a_color_pressed" object:@"gray"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    color = !color;

     background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    
}
-(void)normal_pressed
{
    current_background_line_style = [UIImage imageNamed:@"line_type_1.png"]; 
    sub_menu_background.image = current_background_line_style;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"a_line_style_pressed" object:@"normal"];
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    line = !line;

    
}
-(void)thick_pressed
{
    current_background_line_style = [UIImage imageNamed:@"line_type_2.png"]; 
    sub_menu_background.image = current_background_line_style;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"a_line_style_pressed" object:@"thick"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    line = !line;
     background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];

    
}
-(void)dotted_pressed
{
    current_background_line_style = [UIImage imageNamed:@"line_type_3.png"]; 
    sub_menu_background.image = current_background_line_style;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"a_line_style_pressed" object:@"dotted"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    line = !line;
     background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];

    
}
-(void)super_dotted_pressed
{
    current_background_line_style = [UIImage imageNamed:@"line_type_4.png"]; 
    sub_menu_background.image = current_background_line_style;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"a_line_style_pressed" object:@"super_dotted"];
    [sub_menu removeFromSuperview];
    [self clear_sub_menu];
    line = !line;
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];

    
}
-(void)circle_interior_pressed
{
     icon_overlay_interior.frame = circle_interior.frame;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"circle"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu]; 
    interior = interior;
     background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
}
-(void)circle_exterior_pressed
{
    icon_overlay_exterior.frame = circle_exterior.frame;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"circle"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu]; 
    interior = !interior;
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
}
-(void)square_interior_pressed
{
    icon_overlay_interior.frame = square_interior.frame;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"rectangle"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu]; 
    interior = !interior;
     background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    
}
-(void)square_exterior_pressed
{
    icon_overlay_exterior.frame = square_exterior.frame;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"an_icon_selected" object:@"rectangle"]; 
    [sub_menu removeFromSuperview];
    [self clear_sub_menu]; 
    interior = !interior;
    background.image = [UIImage imageNamed:@"toll_bar_0_none_selected.png"];
    
}




@end
