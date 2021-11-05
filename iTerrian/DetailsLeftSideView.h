//
//  DetailsLeftSideViewController.h
//  MAW
//
//  Created by Nicholas Krzemienski on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsLeftSideView : UIView
{
    
    UIImageView * background;
    UIButton * interior_tool;
    UIButton * exterior_tool;
    UIButton * draw_tool;
    UIButton * text_tool;
    UIButton * line_tool;
    UIButton * straight_line_tool;
    UIButton * color_tool;
    UIView * sub_menu;
    UIImageView * sub_menu_background;
    
    //Exterior icons
    UIButton * ext_1;
    UIButton * ext_2;
    UIButton * ext_3;
    UIButton * ext_4;
    UIButton * ext_5;
    UIButton * ext_6;
    UIButton * ext_7;
    UIButton * ext_8;
    UIButton * ext_9;
    UIButton * ext_10;
    UIButton * ext_11;
    
    //Shape Icons
    UIButton * circle_interior;
    UIButton * circle_exterior;
    UIButton * square_interior;
    UIButton * square_exterior;
    
    //Interior icons
    UIButton * int_1;
    UIButton * int_2;
    UIButton * int_3;
    UIButton * int_4;
    UIButton * int_5;
    UIButton * int_6;
    UIButton * int_7;
    UIButton * int_8;
    UIButton * int_9;
    UIButton * int_10;
    UIButton * int_11;
    
    //Colors
    UIButton * red;
    UIButton * blue;
    UIButton * green;
    UIButton * light_blue;
    UIButton * light_green;
    UIButton * light_yellow;
    UIButton * pink;   
    UIButton * yellow;
    UIButton * black;
    UIButton * gray;
    
    //This is used for the current state of the background so when you come back to it will stay the same background png
    UIImage * current_background_color;
    UIImage * current_background_interior;
    UIImage * current_background_exterior;
    UIImage * current_background_line_style;
    
    //Line Styles
    UIButton * normal;
    UIButton * thick;
    UIButton * dotted;
    UIButton * super_dotted;
    
    //Undo and redo buttons
    UIButton * undo;
    UIButton * redo;
    
    UIImageView * icon_overlay_interior;    
    UIImageView * icon_overlay_exterior;
    
    //Booleans as to what areas are selected
    BOOL exterior;
    BOOL interior;
    BOOL draw;
    BOOL line;
    BOOL color;
    BOOL text;
    BOOL straight_line;
    
    

    
    
}

@end
