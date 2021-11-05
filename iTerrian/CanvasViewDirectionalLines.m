//
//  CanvasViewDirectionalLines.m
//  MAW
//
//  Created by Nicholas Krzemienski on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//




#import "CanvasViewDirectionalLines.h"


@implementation CanvasViewDirectionalLines
@synthesize straight_line_points;
@synthesize points;
@synthesize labels_text;
@synthesize labels;
@synthesize comments;
@synthesize straight_line_tool_points;
@synthesize item;
@synthesize background;

//All booleans for the app go here.
bool new_object = NO;
bool place_icon = NO;
bool place_textfield = NO;
bool draw_slected = NO;
bool straight_line_selected = NO;
bool first_point_foundation = YES;
bool drawing = NO;
int count2 = 0;
int v_total = 0;
int h_total = 0;
int comments_count = 0;
int commentCount = 1;
CGPoint point_a;

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
    new_object = YES;
    [self setClearsContextBeforeDrawing:NO];
    self.backgroundColor = [UIColor whiteColor];    
     
    //freeline_view= [[DrawingView alloc] initWithFrame:self.frame];
    //[self addSubview:freeline_view];
    
    //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_square.jpg"]];
    //List for the commands from the left side controller.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(up_pressed) name:@"up_pressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(down_pressed) name:@"down_pressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(left_pressed) name:@"left_pressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(right_pressed) name:@"right_pressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculate_distance:) name:@"calculate_distance" object:nil];
    
    //NOTIFICATIONS FOR THE UNDO AND REDO AND ROTATE CALLS
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(undo_pressed) name:@"undo_draw" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redo_pressed) name:@"redo_draw" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotate) name:@"rotate_view" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(add_icon:) name:@"an_icon_selected" object:nil];
    //MIGHT NOT BE NEEDED JUST LEAVING IN FOR THE TIME BEING.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dont_add_icon) name:@"an_icon_deselected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(add_textbox) name:@"text_selected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dont_add_textbox) name:@"text_deselected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(draw_selected) name:@"draw_selected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(straight_line_selected) name:@"straight_line_selected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(straight_line_deselected) name:@"straight_line_deselected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(color:) name:@"a_color_pressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(line:) name:@"a_line_style_pressed" object:nil];    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clear) name:@"clear_icon_pressed" object:nil];
    
    
    //BUTTONS START OFF IN A NON PRESSED STATE
    up_pressed = NO;
    down_pressed = NO;
    left_pressed = NO;
    right_pressed = NO;    
    
    //create all variables that need to be controlled
    current_color = [[UIColor alloc] initWithCGColor:[[UIColor blackColor] CGColor]];
    current_line_pattern = [[NSString alloc] initWithString:@"normal"];
    track_of_activites = [[NSMutableArray alloc] init];
    holding_of_activities = [[NSMutableArray alloc] init];
    self.straight_line_tool_points = [[NSMutableArray alloc] init];
    NSMutableArray *newPoints = [[NSMutableArray alloc] init];
    self.straight_line_points = newPoints;
    [newPoints release];
    
    icons_array = [[NSMutableArray alloc] init];
    straight_line_tool_points_array = [[NSMutableArray alloc] init];
    textboxes_array = [[NSMutableArray alloc] init];
    points_array = [[NSMutableArray alloc] init];
    comments_array = [[NSMutableArray alloc] init];
    rect_array = [[NSMutableArray alloc] init];
    circle_array = [[NSMutableArray alloc] init];
    
    holding_array_circles = [[NSMutableArray alloc] init];
    holding_array_rects = [[NSMutableArray alloc] init];
    
    
    [self add_starting_point];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foundation_icon_pressed) name:@"foundation_icon_pressed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(details_icon_pressed) name:@"details_icon_pressed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comments_icon_pressed) name:@"comments_selected" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comments_icon_depressed) name:@"comments_deselected" object:nil];
    
    
    [NSTimer scheduledTimerWithTimeInterval: 0.5f target: self selector: @selector(updateTime:) userInfo: nil repeats: NO];
    
}
-(void)updateTime: (NSTimer *) timer
{
    NSFileManager *filemgr;
    NSString *docsDir;
    NSArray *dirPaths;
    filemgr = [NSFileManager defaultManager];
    
    
    //Store the archive in the library directory not the documents directory because it should not be accessible by itunes file sharing.
    dirPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    //USE THE NAME OF THE CLIENT IN THE NAME OF THIS FILE TO MAKE IT UNIQUE WHEN DATABASING WORKS BETTER.
    dataFilePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: item.address]];
    
    NSLog(@"ADDRESS %@", item.address);
    
    if ([filemgr fileExistsAtPath: dataFilePath])
    {
        NSArray * old_arrays = [NSKeyedUnarchiver unarchiveObjectWithFile: dataFilePath];
        
        NSMutableArray * straight_points_old =  [old_arrays objectAtIndex:0];
        self.straight_line_points = [[NSMutableArray alloc] initWithArray:straight_points_old];
        
        NSMutableArray * points_old =  [old_arrays objectAtIndex:1];
        self.points = [[NSMutableArray alloc] initWithArray:points_old];
        
        NSMutableArray * old_labels = [old_arrays objectAtIndex:2];
        self.labels = [[NSMutableArray alloc] initWithArray:old_labels];
        
        NSMutableArray * old_icons = [old_arrays objectAtIndex:3];
        holding_array_icons = [[NSMutableArray alloc] initWithArray:old_icons];
        
        NSMutableArray * old_holding_labels = [old_arrays objectAtIndex:4];
        holding_array_labels = [[NSMutableArray alloc] initWithArray:old_holding_labels];
        
        NSMutableArray * old_text = [old_arrays objectAtIndex:5];
        holding_array_textboxes = [[NSMutableArray alloc] initWithArray:old_text];
        
        NSMutableArray * old_activities = [old_arrays objectAtIndex:6];
        holding_of_activities = [[NSMutableArray alloc] initWithArray:old_activities];
        
        NSMutableArray * old_points = [old_arrays objectAtIndex:7];
        self.straight_line_tool_points = [[NSMutableArray alloc] initWithArray:old_points];
        
        new_object = [old_arrays objectAtIndex:8];
        
        place_icon = [old_arrays objectAtIndex:9];
        
        place_textfield = [old_arrays objectAtIndex:10];
        
        draw_slected = [old_arrays objectAtIndex:11];
        
        straight_line_selected = [old_arrays objectAtIndex:12];
        
        first_point_foundation = [old_arrays objectAtIndex:13];
        
        drawing = [old_arrays objectAtIndex:14];
        
        id temp = [old_arrays objectAtIndex:15];
        count2 = [temp integerValue];
        
        temp = [old_arrays objectAtIndex:16];
        v_total = [temp integerValue];
        
        temp = [old_arrays objectAtIndex:17];
        h_total = [temp integerValue];
        
        temp = [old_arrays objectAtIndex:18];
        comments_count = [temp integerValue];
        
        temp = [old_arrays objectAtIndex:19];
        commentCount = [temp integerValue];
        
        NSMutableArray * old_track = [old_arrays objectAtIndex:20];
        track_of_activites =  [[NSMutableArray alloc] initWithArray:old_track];
        
        NSMutableArray * old_points_tool = [old_arrays objectAtIndex:21];
        temp_straight_line_tool_points =  [[NSMutableArray alloc] initWithArray:old_points_tool];
        
        NSMutableArray * old_points_held = [old_arrays objectAtIndex:22];
        holding_array_points =  [[NSMutableArray alloc] initWithArray:old_points_held];
        
        NSMutableArray * old_temp_icons = [old_arrays objectAtIndex:23];
        temp_icons =  [[NSMutableArray alloc] initWithArray:old_temp_icons];
        
        NSMutableArray * old_temp_textboxes = [old_arrays objectAtIndex:24];
        temp_textboxes =  [[NSMutableArray alloc] initWithArray:old_temp_textboxes];
        
        NSMutableArray * old_temp_points = [old_arrays objectAtIndex:25];
        temp_points =  [[NSMutableArray alloc] initWithArray:old_temp_points];
        
        NSMutableArray * old_icons_array= [old_arrays objectAtIndex:26];
        icons_array =  [[NSMutableArray alloc] initWithArray:old_icons_array];
        
        NSMutableArray * old_straight_line_tool_points_array = [old_arrays objectAtIndex:27];
        straight_line_tool_points_array =  [[NSMutableArray alloc] initWithArray:old_straight_line_tool_points_array];
        
        NSMutableArray * old_textboxes_array = [old_arrays objectAtIndex:28];
        textboxes_array =  [[NSMutableArray alloc] initWithArray:old_textboxes_array];
        
        NSMutableArray * old_points_array = [old_arrays objectAtIndex:29];
        points_array =  [[NSMutableArray alloc] initWithArray:old_points_array];
        
        NSMutableArray * old_comments_array = [old_arrays objectAtIndex:30];
        comments_array =  [[NSMutableArray alloc] initWithArray:old_comments_array];
        
        NSMutableArray * old_temp_comments_array = [old_arrays objectAtIndex:31];
        temp_comments =  [[NSMutableArray alloc] initWithArray:old_temp_comments_array];
        
        NSMutableArray * old_rect_array = [old_arrays objectAtIndex:32];
        rect_array =  [[NSMutableArray alloc] initWithArray:old_rect_array];
        
        NSMutableArray * old_circle_array = [old_arrays objectAtIndex:33];
        circle_array =  [[NSMutableArray alloc] initWithArray:old_circle_array];
        
        NSMutableArray * old_temp_rect_array = [old_arrays objectAtIndex:34];
        temp_rects =  [[NSMutableArray alloc] initWithArray:old_temp_rect_array];
        
        NSMutableArray * old_temp_circle_array = [old_arrays objectAtIndex:35];
        temp_circles =  [[NSMutableArray alloc] initWithArray:old_temp_circle_array];
        
        NSMutableArray * old_holding_circle_array = [old_arrays objectAtIndex:36];
        holding_array_circles =  [[NSMutableArray alloc] initWithArray:old_holding_circle_array];
        
        NSMutableArray * old_holding_rect_array = [old_arrays objectAtIndex:37];
        holding_array_rects =  [[NSMutableArray alloc] initWithArray:old_holding_rect_array];
        
        
        NSLog(@"straight_line_points - %@", straight_line_points);
        NSLog(@"points - %@", points);
        NSLog(@"labels - %@", labels);
        NSLog(@"holding_array_icons - %@", holding_array_icons);
        NSLog(@"holding_array_labels - %@", holding_array_labels);
        NSLog(@"holding_array_textboxes - %@", holding_array_textboxes);
        NSLog(@"holding_of_activities - %@", holding_of_activities);
        NSLog(@"straight_line_tool_points - %@", straight_line_tool_points);
        NSLog(@"track_of_activites - %@", track_of_activites);
        NSLog(@"temp_straight_line_tool_points - %@", temp_straight_line_tool_points);
        NSLog(@"holding_array_points - %@", holding_array_points);
        NSLog(@"temp_icons - %@", temp_icons);
        NSLog(@"temp_textboxes - %@", temp_textboxes);
        NSLog(@"temp_points - %@", temp_points);
        NSLog(@"icons_array - %@", icons_array);
        NSLog(@"straight_line_tool_points_array - %@", straight_line_tool_points_array);
        NSLog(@"textboxes_array - %@", textboxes_array);
        NSLog(@"points_array - %@", points_array);
        NSLog(@"comments_array - %@", comments_array);
        NSLog(@"temp_comments - %@", temp_comments);
        NSLog(@"rect_array - %@", rect_array);
        NSLog(@"circle_array - %@", circle_array);
        NSLog(@"temp_rects - %@", temp_rects);
        NSLog(@"temp_circles - %@", temp_circles);
        NSLog(@"holding_array_circles - %@", holding_array_circles);
        NSLog(@"holding_array_rects - %@", holding_array_rects);
        
        NSLog(@"new_object - %i", new_object);
        NSLog(@"place_icon - %i", place_icon);
        NSLog(@"place_textfield - %i", place_textfield);
        NSLog(@"draw_slected - %i", draw_slected);
        NSLog(@"straight_line_selected - %i", straight_line_selected);
        NSLog(@"first_point_foundation - %i", first_point_foundation);
        NSLog(@"drawing - %i", drawing);
        NSLog(@"count2 - %i", count2);
        NSLog(@"v_total - %i", v_total);
        NSLog(@"h_total - %i", h_total);
        NSLog(@"comments_count - %i", comments_count);
        NSLog(@"commentCount - %i", commentCount);
        
        //Update Foundation Lables
        
        //Update Icons
        for (int i = 0; i < icons_array.count; i++)
        {
            SPUserResizableView * to_be_added_back = [icons_array objectAtIndex:i];
            to_be_added_back.frame = [[icons_array objectAtIndex:i] frame];
            [to_be_added_back setAutoresizesSubviews:YES];
            to_be_added_back.imageView.image = [[[icons_array objectAtIndex:i] imageView]image];
            to_be_added_back.contentView = [[icons_array objectAtIndex:i] imageView];
            to_be_added_back.delegate = self;
            to_be_added_back.is_icon = YES;
            [to_be_added_back hideEditingHandles];
            [self addSubview:to_be_added_back];
            
            UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];
            [panrecognizer setCancelsTouchesInView:NO];
            [to_be_added_back addGestureRecognizer:panrecognizer];
            
            UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];
            [messagesTap setDelegate:self];
            [messagesTap setNumberOfTapsRequired:2];
            [to_be_added_back addGestureRecognizer:messagesTap];
            
            
        }
        
        //Update Rects
        for (int i = 0; i < rect_array.count; i++)
        {
            SPUserResizableView * userResizableView = [rect_array objectAtIndex:i];
            Rectangle * rect_view = [[Rectangle alloc] initWithFrame: [[rect_array objectAtIndex:i] frame]];
            rect_view.line_color = current_color;
            rect_view.line_pattern = current_line_pattern;
            rect_view.backgroundColor = [UIColor clearColor];
            rect_view.userInteractionEnabled = NO;
            [userResizableView setAutoresizesSubviews:YES];
            userResizableView.contentView = rect_view;
            userResizableView.delegate = self;
            userResizableView.is_icon = YES;
            [userResizableView hideEditingHandles];
            currentlyEditingView = userResizableView;
            lastEditedView = userResizableView;
            
            [self addSubview:userResizableView];
            
            UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];
            [panrecognizer setCancelsTouchesInView:NO];
            [userResizableView addGestureRecognizer:panrecognizer];
            
            UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];
            [messagesTap setDelegate:self];
            [messagesTap setNumberOfTapsRequired:2];
            [userResizableView addGestureRecognizer:messagesTap];
        }
        
        //Update Circles
        for (int i = 0; i < circle_array.count; i++)
        {
            SPUserResizableView * userResizableView = [circle_array objectAtIndex:i];
            Circle * circle_view = [[Circle alloc] initWithFrame:[[circle_array objectAtIndex:i] frame]];
            circle_view.line_color = current_color;
            circle_view.line_pattern = current_line_pattern;
            circle_view.backgroundColor = [UIColor clearColor];
            circle_view.userInteractionEnabled = NO;
            [userResizableView setAutoresizesSubviews:YES];
            userResizableView.contentView = circle_view;
            userResizableView.delegate = self;
            userResizableView.is_icon = YES;
            [userResizableView hideEditingHandles];
            currentlyEditingView = userResizableView;
            lastEditedView = userResizableView;
            
            [self addSubview:userResizableView];
            
            UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];
            [panrecognizer setCancelsTouchesInView:NO];
            [userResizableView addGestureRecognizer:panrecognizer];
            
            UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];
            [messagesTap setDelegate:self];
            [messagesTap setNumberOfTapsRequired:2];
            [userResizableView addGestureRecognizer:messagesTap];
        }
        
        //Update Textboxes
        for (int i = 0; i < textboxes_array.count; i++)
        {
            SPUserResizableView * to_be_added_back = [textboxes_array objectAtIndex:i];
            to_be_added_back.frame = [[textboxes_array objectAtIndex:i] frame];
            [to_be_added_back setAutoresizesSubviews:YES];
            to_be_added_back.contentView = [[textboxes_array objectAtIndex:i] wrapper];
            to_be_added_back.delegate = self;
            to_be_added_back.is_icon = YES;
            [to_be_added_back hideEditingHandles];
            [self addSubview:to_be_added_back];
            
            UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];
            [panrecognizer setCancelsTouchesInView:NO];
            [to_be_added_back addGestureRecognizer:panrecognizer];
            
            UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];
            [messagesTap setDelegate:self];
            [messagesTap setNumberOfTapsRequired:2];
            [to_be_added_back addGestureRecognizer:messagesTap];
        }
        
        //Update Comments
        for (int i = 0; i < comments_array.count; i++)
        {
            SPUserResizableView * to_be_added_back = [comments_array objectAtIndex:i];
            to_be_added_back.frame = [[comments_array objectAtIndex:i] frame];
            [to_be_added_back setAutoresizesSubviews:YES];
            to_be_added_back.imageView.image = [[[comments_array objectAtIndex:i] imageView]image];
            to_be_added_back.contentView = [[comments_array objectAtIndex:i] imageView];
            to_be_added_back.delegate = self;
            to_be_added_back.is_icon = YES;
            [to_be_added_back hideEditingHandles];
            [self addSubview:to_be_added_back];
            
            UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];
            [panrecognizer setCancelsTouchesInView:NO];
            [to_be_added_back addGestureRecognizer:panrecognizer];
            
            UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comment_tapped:)];
            [messagesTap setDelegate:self];
            [messagesTap setNumberOfTapsRequired:1];
            [to_be_added_back addGestureRecognizer:messagesTap];
            
            UITapGestureRecognizer *messagesTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(display_comments:)];
            [messagesTap2 setDelegate:self];
            [messagesTap2 setNumberOfTapsRequired:2];
            [to_be_added_back addGestureRecognizer:messagesTap2];
            
        }
        
        
    }
    
    [self setNeedsDisplay];
}
-(void)save
{
    if (self.points == nil)
    {
        self.points = [[NSMutableArray alloc] init];
    }
    if (self.straight_line_points == nil)
    {
        self.straight_line_points = [[NSMutableArray alloc] init];
    }
    if (self.labels == nil)
    {
        self.labels = [[NSMutableArray alloc] init];
    }
    if (holding_array_icons == nil)
    {
        holding_array_icons = [[NSMutableArray alloc] init];
    }
    if (holding_array_labels == nil)
    {
        holding_array_labels = [[NSMutableArray alloc] init];
    }
    if (holding_array_textboxes == nil)
    {
        holding_array_textboxes = [[NSMutableArray alloc] init];
    }
    if (holding_of_activities == nil)
    {
        holding_of_activities = [[NSMutableArray alloc] init];
    }
    if (self.straight_line_tool_points == nil)
    {
        self.straight_line_tool_points = [[NSMutableArray alloc] init];
    }
    if(track_of_activites == nil)
    {
        track_of_activites = [[NSMutableArray alloc] init];
    }
    if(temp_straight_line_tool_points == nil)
    {
        temp_straight_line_tool_points = [[NSMutableArray alloc] init];
    }
    if(holding_array_points == nil)
    {
        holding_array_points = [[NSMutableArray alloc] init];
    }
    if(temp_icons == nil)
    {
        temp_icons = [[NSMutableArray alloc] init];
    }
    if(temp_textboxes == nil)
    {
        temp_textboxes = [[NSMutableArray alloc] init];
    }
    if(temp_points == nil)
    {
        temp_points = [[NSMutableArray alloc] init];
    }
    if(icons_array == nil)
    {
        icons_array = [[NSMutableArray alloc] init];
    }
    if(straight_line_tool_points_array == nil)
    {
        straight_line_tool_points_array = [[NSMutableArray alloc] init];
    }
    if(textboxes_array == nil)
    {
        textboxes_array = [[NSMutableArray alloc] init];
    }
    if(points_array == nil)
    {
        points_array = [[NSMutableArray alloc] init];
    }
    if(comments_array == nil)
    {
        comments_array = [[NSMutableArray alloc] init];
    }
    if(temp_comments == nil)
    {
        temp_comments = [[NSMutableArray alloc] init];
    }
    if(rect_array == nil)
    {
        rect_array = [[NSMutableArray alloc] init];
    }
    if(circle_array == nil)
    {
        circle_array = [[NSMutableArray alloc] init];
    }
    if(temp_rects == nil)
    {
        temp_rects = [[NSMutableArray alloc] init];
    }
    if(temp_circles == nil)
    {
        temp_circles = [[NSMutableArray alloc] init];
    }
    if(holding_array_circles == nil)
    {
        holding_array_circles = [[NSMutableArray alloc] init];
    }
    if(holding_array_rects == nil)
    {
        holding_array_rects = [[NSMutableArray alloc] init];
    }
    
    NSArray * points_arrays = [NSArray arrayWithObjects:self.straight_line_points, self.points, self.labels, holding_array_icons,holding_array_labels, holding_array_textboxes, holding_of_activities, self.straight_line_tool_points, [NSNumber numberWithBool:new_object] , [NSNumber numberWithBool:place_icon] , [NSNumber numberWithBool:place_textfield] , [NSNumber numberWithBool:draw_slected] , [NSNumber numberWithBool:straight_line_selected] , [NSNumber numberWithBool:first_point_foundation] , [NSNumber numberWithBool:drawing] ,  [NSNumber numberWithInteger:count2],  [NSNumber numberWithInteger:v_total],  [NSNumber numberWithInteger:h_total],  [NSNumber numberWithInteger:comments_count],  [NSNumber numberWithInteger:commentCount], track_of_activites, temp_straight_line_tool_points, holding_array_points, temp_icons, temp_textboxes, temp_points,icons_array,straight_line_tool_points_array,textboxes_array,points_array,comments_array,temp_comments,rect_array, circle_array, temp_rects, temp_circles, holding_array_circles, holding_array_rects,  nil];
    
   // NSLog(@"ARRAY = %@", points_arrays);
    NSLog(@"straight_line_points - %@", straight_line_points);
    NSLog(@"points - %@", points);
    NSLog(@"labels - %@", labels);
    NSLog(@"holding_array_icons - %@", holding_array_icons);
    NSLog(@"holding_array_labels - %@", holding_array_labels);
    NSLog(@"holding_array_textboxes - %@", holding_array_textboxes);
    NSLog(@"holding_of_activities - %@", holding_of_activities);
    NSLog(@"straight_line_tool_points - %@", straight_line_tool_points);
    NSLog(@"track_of_activites - %@", track_of_activites);
    NSLog(@"temp_straight_line_tool_points - %@", temp_straight_line_tool_points);
    NSLog(@"holding_array_points - %@", holding_array_points);
    NSLog(@"temp_icons - %@", temp_icons);
    NSLog(@"temp_textboxes - %@", temp_textboxes);
    NSLog(@"temp_points - %@", temp_points);
    NSLog(@"icons_array - %@", icons_array);
    NSLog(@"straight_line_tool_points_array - %@", straight_line_tool_points_array);
    NSLog(@"textboxes_array - %@", textboxes_array);
    NSLog(@"points_array - %@", points_array);
    NSLog(@"comments_array - %@", comments_array);
    NSLog(@"temp_comments - %@", temp_comments);
    NSLog(@"rect_array - %@", rect_array);
    NSLog(@"circle_array - %@", circle_array);
    NSLog(@"temp_rects - %@", temp_rects);
    NSLog(@"temp_circles - %@", temp_circles);
    NSLog(@"holding_array_circles - %@", holding_array_circles);
    NSLog(@"holding_array_rects - %@", holding_array_rects);
    
    [NSKeyedArchiver archiveRootObject:points_arrays toFile:dataFilePath];
    
}
-(void)foundation_icon_pressed
{
    foundation_mode = YES;
    details_mode = NO;
    comments_mode = NO;
}
-(void)details_icon_pressed
{
    foundation_mode = NO;
    details_mode = YES;
    comments_mode = NO;
    
}
-(void)comments_icon_pressed
{
    foundation_mode = NO;
    details_mode = NO;
    comments_mode = YES;
    
}
-(void)comments_icon_depressed
{   
    comments_mode = NO;    
}
-(void)clear
{
    for (UIView * to_be_removed in self.subviews)
    {
        [to_be_removed removeFromSuperview];
        
    }
    
    [points removeAllObjects];
    [holding_array_icons removeAllObjects];
    [straight_line_points removeAllObjects];
    [holding_array_labels removeAllObjects];
    [holding_array_textboxes removeAllObjects];
    [holding_of_activities removeAllObjects];
    [straight_line_tool_points removeAllObjects];
    [track_of_activites removeAllObjects];
    [temp_straight_line_tool_points removeAllObjects];
    [labels removeAllObjects];
    
    
    [self.points removeAllObjects];
    [self.straight_line_points removeAllObjects];
    [self.labels removeAllObjects];
    [holding_array_icons removeAllObjects];
    [holding_array_labels removeAllObjects];
    [holding_array_textboxes removeAllObjects];
    [holding_of_activities removeAllObjects];
    [self.straight_line_tool_points removeAllObjects];
    [track_of_activites removeAllObjects];
    [temp_straight_line_tool_points removeAllObjects];
    [holding_array_points removeAllObjects];
    [temp_icons removeAllObjects];
    [temp_textboxes removeAllObjects];
    [temp_points removeAllObjects];
    [icons_array removeAllObjects];
    [straight_line_tool_points_array removeAllObjects];
    [textboxes_array removeAllObjects];
    [points_array removeAllObjects];
    [comments_array removeAllObjects];
    [temp_comments removeAllObjects];
    [circle_array removeAllObjects];
    [rect_array removeAllObjects];
    [holding_array_circles removeAllObjects];
    [holding_array_rects removeAllObjects];
    [temp_circles removeAllObjects];
    [temp_rects removeAllObjects];
    
    new_object = NO;
    place_icon = NO;
    place_textfield = NO;
    draw_slected = NO;
    straight_line_selected = NO;
    first_point_foundation = YES;
    drawing = NO;
    count2 = 0;
    v_total = 0;
    h_total = 0;
    comments_count = 0;
    commentCount = 1;
    
    [self setNeedsDisplay];
    [self add_starting_point];
    
    [self save];
    
}
-(void)undo_pressed
{
    
    //If there are no points do nothing.
     if (details_mode)
    {
        if (track_of_activites.count == 0) 
        {
            //NOTHING TO BE UNDONE.
        }
        else 
        {
            

            
            NSString * what_was_done_last = [track_of_activites lastObject];
            [track_of_activites removeLastObject];
            [holding_of_activities addObject:what_was_done_last];
            if ([what_was_done_last isEqualToString:@"placed_icon"]) 
            {
                [icons_array removeLastObject];
                
                SPUserResizableView * undo_view = [holding_array_icons lastObject];
                [holding_array_icons removeLastObject];
                if (temp_icons == nil) 
                {
                    temp_icons = [[NSMutableArray alloc] init];
                }
                [temp_icons addObject:undo_view];
                
                for (SPUserResizableView * to_be_removed in self.subviews) 
                {
                    if ([to_be_removed isEqual:undo_view]) 
                    {
                        [to_be_removed removeFromSuperview];
                    }
                }
                
                
            }
            else if ([what_was_done_last isEqualToString:@"placed_rectangle"])
            {
                [rect_array removeLastObject];
                
                SPUserResizableView * undo_view = [holding_array_rects lastObject];
                [holding_array_rects removeLastObject];
                if (temp_rects == nil)
                {
                    temp_rects = [[NSMutableArray alloc] init];
                }
                [temp_rects addObject:undo_view];
                
                for (SPUserResizableView * to_be_removed in self.subviews)
                {
                    if ([to_be_removed isEqual:undo_view])
                    {
                        [to_be_removed removeFromSuperview];
                    }
                }

                
                
            }
            else if ([what_was_done_last isEqualToString:@"placed_circle"])
            {
                [circle_array removeLastObject];
                
                SPUserResizableView * undo_view = [holding_array_circles lastObject];
                [holding_array_circles removeLastObject];
                if (temp_circles == nil)
                {
                    temp_circles = [[NSMutableArray alloc] init];
                }
                [temp_circles addObject:undo_view];
                
                for (SPUserResizableView * to_be_removed in self.subviews)
                {
                    if ([to_be_removed isEqual:undo_view])
                    {
                        [to_be_removed removeFromSuperview];
                    }
                }
                
                
                
            }
            else if ([what_was_done_last isEqualToString:@"place_textfield"])
            {
                [textboxes_array removeLastObject];
                
                SPUserResizableView * undo_view = [holding_array_textboxes lastObject];
                [holding_array_textboxes removeLastObject];
                if (temp_textboxes == nil) 
                {
                    temp_textboxes = [[NSMutableArray alloc] init];
                }
                [temp_textboxes addObject:undo_view];
                
                for (SPUserResizableView * to_be_removed in self.subviews) 
                {
                    if ([to_be_removed isEqual:undo_view]) 
                    {
                        [to_be_removed removeFromSuperview];
                    }
                }
                
                
            }
            else if ([what_was_done_last isEqualToString:@"freeform_tool"]) 
            {
                if (temp_points == nil) 
                {
                    temp_points = [[NSMutableArray alloc] init];
                }
                
                int target = self.points.count-1;
                for (int i = self.points.count-1; i>=0; i--) 
                {
                    Line_Point * nextPoint = [self.points objectAtIndex:i];
                    if (i == target) 
                    {
                        [points_array removeObjectAtIndex:target];
                        [self.points removeObjectAtIndex:target];
                        [temp_points addObject:nextPoint];
                    }
                    else if (nextPoint.point.CGPointValue.x < 0 && nextPoint.point.CGPointValue.y < 0)
                    {
                        
                        [points_array removeObjectAtIndex:i];
                        [self.points removeObjectAtIndex:i];
                        [temp_points addObject:nextPoint];
                        break; 
                        
                    }
                    else 
                    {
                        [points_array removeObjectAtIndex:i];
                        [self.points removeObjectAtIndex:i];
                        [temp_points addObject:nextPoint];
                    }
                    
                }
                
                
                [self setNeedsDisplay];
                 
                
            }
            else if ([what_was_done_last isEqualToString:@"straight_line_tool"])
            {
                if (temp_straight_line_tool_points == NULL)
                {
                    temp_straight_line_tool_points = [[NSMutableArray alloc] init];
                }
                
                if (self.straight_line_tool_points.count == 1)
                {
                    Line_Point * undo = [self.straight_line_tool_points lastObject];                    
                    [self.straight_line_tool_points removeLastObject];
                    [straight_line_tool_points_array removeLastObject];
                }
                
                else if (self.straight_line_tool_points.count == 0)
                {
                    //do nothing
                }
                else
                {
                    
                Line_Point * undo = [self.straight_line_tool_points lastObject];                
                [self.straight_line_tool_points removeLastObject];
                [temp_straight_line_tool_points addObject:undo];
                    
                Line_Point * undo2 = [self.straight_line_tool_points lastObject];                
                [self.straight_line_tool_points removeLastObject];
                [temp_straight_line_tool_points addObject:undo2];
                    
                [straight_line_tool_points_array removeLastObject];
                [straight_line_tool_points_array removeLastObject];
                
                
             /*   undo = [self.straight_line_tool_points lastObject];
                
                [self.straight_line_tool_points removeLastObject];
                
                [temp_straight_line_tool_points addObject:undo];
                undo = [self.straight_line_tool_points lastObject];              
                
                //Add it to the holding array.
                [temp_straight_line_tool_points addObject:undo];
                [self.straight_line_tool_points removeLastObject];*/
                    
                [self setNeedsDisplay];
                    
                }

                                
            }
            
            
        }
  
    }
    else if(comments_mode)
    {
        if (track_of_activites.count == 0) 
        {
            //NOTHING TO BE UNDONE.
        }
        else 
        {
            NSString * what_was_done_last = [track_of_activites lastObject];
            [track_of_activites removeLastObject];
            [holding_of_activities addObject:what_was_done_last];
            
            if ([what_was_done_last isEqualToString:@"comment"]) 
            {
                SPUserResizableView * undo_view = [holding_array_icons lastObject];
                
                [comments_array removeLastObject];
                [holding_array_icons removeLastObject];
                if (temp_comments == nil) 
                {
                    temp_comments = [[NSMutableArray alloc] init];
                }
                [temp_comments addObject:undo_view];
                
                for (SPUserResizableView * to_be_removed in self.subviews) 
                {
                    if ([to_be_removed isEqual:undo_view]) 
                    {
                        [to_be_removed removeFromSuperview];
                        
                        commentCount --;
                    }
                }
            }
            
        }
        
    }
    
    [self save];
    
    
    
}
-(void)redo_pressed
{
    if(details_mode)
    {  
        if (holding_of_activities.count == 0) 
        {
            //NOTHING TO BE UNDONE.
        }
        else 
        {
            
            NSString * last_undo = [holding_of_activities lastObject];
            [holding_of_activities removeLastObject];
            [track_of_activites addObject:last_undo];
            
            if ([last_undo isEqualToString:@"placed_icon"]) 
            {
                SPUserResizableView * to_be_added_back = [temp_icons lastObject];
                to_be_added_back.frame = [[temp_icons lastObject] frame];
                [to_be_added_back setAutoresizesSubviews:YES];
                to_be_added_back.imageView.image = [[[temp_icons lastObject] imageView]image];
                to_be_added_back.contentView = [[temp_icons lastObject] imageView];
                to_be_added_back.delegate = self;
                to_be_added_back.is_icon = YES;
                [to_be_added_back hideEditingHandles];
                [self addSubview:to_be_added_back];
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];
                [panrecognizer setCancelsTouchesInView:NO];
                [to_be_added_back addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];
                [to_be_added_back addGestureRecognizer:messagesTap];

                [temp_icons removeLastObject];
                [holding_array_icons addObject:to_be_added_back];
                [icons_array addObject:to_be_added_back];
            }
           else if ([last_undo isEqualToString:@"placed_rectangle"])
            {
                SPUserResizableView * to_be_added_back = [temp_rects lastObject];
                to_be_added_back.frame = [[temp_rects lastObject] frame];
                [to_be_added_back setAutoresizesSubviews:YES];
                to_be_added_back.imageView.image = [[[temp_rects lastObject] imageView]image];
                to_be_added_back.contentView = [[temp_rects lastObject] imageView];
                to_be_added_back.delegate = self;
                to_be_added_back.is_icon = YES;
                [to_be_added_back hideEditingHandles];
                [self addSubview:to_be_added_back];
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];
                [panrecognizer setCancelsTouchesInView:NO];
                [to_be_added_back addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];
                [to_be_added_back addGestureRecognizer:messagesTap];
                
                [temp_rects removeLastObject];
                [holding_array_rects addObject:to_be_added_back];
                [rect_array addObject:to_be_added_back];
            }
           else if ([last_undo isEqualToString:@"placed_circle"])
            {
                SPUserResizableView * to_be_added_back = [temp_circles lastObject];
                to_be_added_back.frame = [[temp_circles lastObject] frame];
                [to_be_added_back setAutoresizesSubviews:YES];
                to_be_added_back.imageView.image = [[[temp_circles lastObject] imageView]image];
                to_be_added_back.contentView = [[temp_circles lastObject] imageView];
                to_be_added_back.delegate = self;
                to_be_added_back.is_icon = YES;
                [to_be_added_back hideEditingHandles];
                [self addSubview:to_be_added_back];
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];
                [panrecognizer setCancelsTouchesInView:NO];
                [to_be_added_back addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];
                [to_be_added_back addGestureRecognizer:messagesTap];
                
                [temp_circles removeLastObject];
                [holding_array_circles addObject:to_be_added_back];
                [circle_array addObject:to_be_added_back];
            }
            else if ([last_undo isEqualToString:@"place_textfield"]) 
            {
                SPUserResizableView * to_be_added_back = [temp_textboxes lastObject];
                to_be_added_back.frame = [[textboxes_array lastObject] frame];
                [to_be_added_back setAutoresizesSubviews:YES];
                to_be_added_back.contentView = [[textboxes_array lastObject] wrapper];
                to_be_added_back.delegate = self;
                to_be_added_back.is_icon = YES;
                [to_be_added_back hideEditingHandles];
                [self addSubview:to_be_added_back];
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];
                [panrecognizer setCancelsTouchesInView:NO];
                [to_be_added_back addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];
                [to_be_added_back addGestureRecognizer:messagesTap];
                
                
                [temp_textboxes removeLastObject];
               // [self addSubview:to_be_added_back];
                [holding_array_textboxes addObject:to_be_added_back];
                [textboxes_array addObject:to_be_added_back];
            }
            else if ([last_undo isEqualToString:@"freeform_tool"]) 
            {     
                int target = temp_points.count-1;
                for (int i = temp_points.count-1; i>= 0; i--) 
                {
                    Line_Point * nextPoint = [temp_points objectAtIndex:i];
                    if (nextPoint.point.CGPointValue.x < 0 && nextPoint.point.CGPointValue.y < 0 && i != target)
                    {             
                        
                        [temp_points removeObjectAtIndex:i];
                        [self.points addObject:nextPoint];
                        [points_array addObject:nextPoint];
                        break; 
                        
                    }
                    else 
                    {
                        [temp_points removeObjectAtIndex:i];
                        [self.points addObject:nextPoint];
                        [points_array addObject: nextPoint];
                    }
                    
                }
                
                
                [self setNeedsDisplay];
                
                
                
            }
           else if ([last_undo isEqualToString:@"straight_line_tool"])
           {
               Line_Point * redo = [temp_straight_line_tool_points lastObject];       
               
               [straight_line_tool_points_array addObject:redo];
               [self.straight_line_tool_points addObject:redo];
               [temp_straight_line_tool_points removeLastObject];
               
               Line_Point * redo2 = [temp_straight_line_tool_points lastObject];
               [straight_line_tool_points_array addObject:redo2];
               [self.straight_line_tool_points addObject:redo2];
               [temp_straight_line_tool_points removeLastObject];
               
               
               [self setNeedsDisplay];
               
               
           }
            
        }
        
    }
    else if(comments_mode)
    {
        if (holding_of_activities.count == 0) 
        {
            //NOTHING TO BE UNDONE.
        }
        else 
        {            
            NSString * last_undo = [holding_of_activities lastObject];
            [holding_of_activities removeLastObject];
            [track_of_activites addObject:last_undo];
            [comments_array addObject:last_undo];
            
            if ([last_undo isEqualToString:@"comment"]) 
            {
                SPUserResizableView * to_be_added_back = [temp_comments lastObject];
                to_be_added_back.frame = [[temp_comments lastObject] frame];
                [to_be_added_back setAutoresizesSubviews:YES];
                to_be_added_back.imageView.image = [[[temp_comments lastObject] imageView]image];
                to_be_added_back.contentView = [[temp_comments lastObject] imageView];
                to_be_added_back.delegate = self;
                to_be_added_back.is_icon = YES;
                [to_be_added_back hideEditingHandles];
                [self addSubview:to_be_added_back];
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];
                [panrecognizer setCancelsTouchesInView:NO];
                [to_be_added_back addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comment_tapped:)];
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:1];
                [to_be_added_back addGestureRecognizer:messagesTap];
                
                UITapGestureRecognizer *messagesTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(display_comments:)];
                [messagesTap2 setDelegate:self];
                [messagesTap2 setNumberOfTapsRequired:2];
                [to_be_added_back addGestureRecognizer:messagesTap2];
                
                [temp_icons removeLastObject];
                [holding_array_icons addObject:to_be_added_back];
                
                commentCount ++;
            }
        }


        
    }
    
    [self save];
    
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (details_mode)
    {
        if (place_icon)
        {
            if (holding_array_icons == nil) 
            {
                holding_array_icons = [[NSMutableArray alloc] init];
            }
            UITouch *touch = [[event touchesForView:self] anyObject];
            CGPoint location = [touch locationInView:self];
            //Check if it is equal to the interior icons set of strings (refracture to not use a million lines of code!) move if stateming into just asigning the image!
            if ([icon_type isEqualToString:@"int_1"]) 
            {  
                
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                userResizableView.imageView.frame = gripFrame;
                userResizableView.imageView.image = [UIImage imageNamed:@"icon_furnace.png"];
                userResizableView.contentView = userResizableView.imageView;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                
                
                currentlyEditingView = userResizableView;
                lastEditedView = userResizableView;
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];       
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];        
                [userResizableView addGestureRecognizer:messagesTap];           
                [holding_array_icons addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_icon"];
                
                [icons_array addObject:userResizableView];
                
                
                
            }
            
            if ([icon_type isEqualToString:@"int_2"]) 
            {  
                
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                userResizableView.imageView.frame = gripFrame;
                userResizableView.imageView.image = [UIImage imageNamed:@"icon_icon_interior_oil_tank.png"];
                userResizableView.contentView = userResizableView.imageView;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];       
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];        
                [userResizableView addGestureRecognizer:messagesTap];           
                [holding_array_icons addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_icon"];
                
                [icons_array addObject:userResizableView];
            }
            
            if ([icon_type isEqualToString:@"int_3"]) 
            {  
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                userResizableView.imageView.frame = gripFrame;
                userResizableView.imageView.image = [UIImage imageNamed:@"icon_icon_interior_hot_water_heater.png"];
                userResizableView.contentView = userResizableView.imageView;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];       
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];        
                [userResizableView addGestureRecognizer:messagesTap];           
                [holding_array_icons addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_icon"];
                
                [icons_array addObject:userResizableView];
            }
            
            if ([icon_type isEqualToString:@"int_4"]) 
            {
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                userResizableView.imageView.frame = gripFrame;
                userResizableView.imageView.image = [UIImage imageNamed:@"icon_icon_interior_sump_pump.png"];
                userResizableView.contentView = userResizableView.imageView;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];       
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];        
                [userResizableView addGestureRecognizer:messagesTap];           
                [holding_array_icons addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_icon"];
                
                [icons_array addObject:userResizableView];
            }
            
            if ([icon_type isEqualToString:@"int_5"]) 
            {
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                userResizableView.imageView.frame = gripFrame;
                userResizableView.imageView.image = [UIImage imageNamed:@"icon_icon_interior_washer_dryer.png"];
                userResizableView.contentView = userResizableView.imageView;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];       
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];        
                [userResizableView addGestureRecognizer:messagesTap];           
                [holding_array_icons addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_icon"];
                
                [icons_array addObject:userResizableView];
            }
            
            if ([icon_type isEqualToString:@"int_6"]) 
            {
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                userResizableView.imageView.frame = gripFrame;
                userResizableView.imageView.image = [UIImage imageNamed:@"icon_laundry-tub.png"];
                userResizableView.contentView = userResizableView.imageView;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];       
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];        
                [userResizableView addGestureRecognizer:messagesTap];           
                [holding_array_icons addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_icon"];
                
                [icons_array addObject:userResizableView];
            }
            
            if ([icon_type isEqualToString:@"int_7"]) 
            {  
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                userResizableView.imageView.frame = gripFrame;
                userResizableView.imageView.image = [UIImage imageNamed:@"icon_stairs.png"];
                userResizableView.contentView = userResizableView.imageView;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];       
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];        
                [userResizableView addGestureRecognizer:messagesTap];           
                [holding_array_icons addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_icon"];
                
                [icons_array addObject:userResizableView];
            }
            
            if ([icon_type isEqualToString:@"int_8"]) 
            {  
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                userResizableView.imageView.frame = gripFrame;
                userResizableView.imageView.image = [UIImage imageNamed:@"icon_baseboard-heat.png"];
                userResizableView.contentView = userResizableView.imageView;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];       
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];        
                [userResizableView addGestureRecognizer:messagesTap];           
                [holding_array_icons addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_icon"];
                
                [icons_array addObject:userResizableView];
            }
            
            if ([icon_type isEqualToString:@"int_9"]) 
            {  
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                userResizableView.imageView.frame = gripFrame;
                userResizableView.imageView.image = [UIImage imageNamed:@"icon_partition.png"];
                userResizableView.contentView = userResizableView.imageView;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];       
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];        
                [userResizableView addGestureRecognizer:messagesTap];           
                [holding_array_icons addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_icon"];
                
                [icons_array addObject:userResizableView];
            }
            
            if ([icon_type isEqualToString:@"int_10"]) 
            {
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                userResizableView.imageView.frame = gripFrame;
                userResizableView.imageView.image = [UIImage imageNamed:@"icon_shelving.png"];
                userResizableView.contentView = userResizableView.imageView;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];       
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];        
                [userResizableView addGestureRecognizer:messagesTap];           
                [holding_array_icons addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_icon"];
                
                [icons_array addObject:userResizableView];
            }
            if ([icon_type isEqualToString:@"int_11"])
            {
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                userResizableView.imageView.frame = gripFrame;
                userResizableView.imageView.image = [UIImage imageNamed:@"icon_Door.png"];
                userResizableView.contentView = userResizableView.imageView;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];
                [userResizableView addGestureRecognizer:messagesTap];
                [holding_array_icons addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_icon"];
                
                [icons_array addObject:userResizableView];
            }            
            //Check if it is equal to the exterior icons set of strings (refracture to not use a million lines of code!) move if stateming into just asigning the image!
            if ([icon_type isEqualToString:@"ext_1"]) 
            {
                
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                userResizableView.imageView.frame = gripFrame;
                userResizableView.imageView.image = [UIImage imageNamed:@"icon_deck.png"];
                userResizableView.contentView = userResizableView.imageView;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];       
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];        
                [userResizableView addGestureRecognizer:messagesTap];           
                [holding_array_icons addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_icon"];
                
                [icons_array addObject:userResizableView];
            }
            
            if ([icon_type isEqualToString:@"ext_2"]) 
            {  
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                userResizableView.imageView.frame = gripFrame;
                userResizableView.imageView.image = [UIImage imageNamed:@"icon_patio.png"];
                userResizableView.contentView = userResizableView.imageView;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];       
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];        
                [userResizableView addGestureRecognizer:messagesTap];           
                [holding_array_icons addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_icon"];
                
                [icons_array addObject:userResizableView];
            }
            
            if ([icon_type isEqualToString:@"ext_3"]) 
            {  
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                userResizableView.imageView.frame = gripFrame;
                userResizableView.imageView.image = [UIImage imageNamed:@"icon_addition.png"];
                userResizableView.contentView = userResizableView.imageView;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];       
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];        
                [userResizableView addGestureRecognizer:messagesTap];           
                [holding_array_icons addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_icon"];
                
                [icons_array addObject:userResizableView];
            }
            
            if ([icon_type isEqualToString:@"ext_4"]) 
            {
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                userResizableView.imageView.frame = gripFrame;
                userResizableView.imageView.image = [UIImage imageNamed:@"icon_front-porch.png"];
                userResizableView.contentView = userResizableView.imageView;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];       
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];        
                [userResizableView addGestureRecognizer:messagesTap];           
                [holding_array_icons addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_icon"];
                
                [icons_array addObject:userResizableView];
            }
            
            if ([icon_type isEqualToString:@"ext_5"]) 
            {  
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                userResizableView.imageView.frame = gripFrame;
                userResizableView.imageView.image = [UIImage imageNamed:@"icon_shrubbery.png"];
                userResizableView.contentView = userResizableView.imageView;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];       
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];        
                [userResizableView addGestureRecognizer:messagesTap];           
                [holding_array_icons addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_icon"];
                
                [icons_array addObject:userResizableView];
            }
            
            if ([icon_type isEqualToString:@"ext_6"]) 
            {  
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                userResizableView.imageView.frame = gripFrame;
                userResizableView.imageView.image = [UIImage imageNamed:@"icon_trees.png"];
                userResizableView.contentView = userResizableView.imageView;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];       
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];        
                [userResizableView addGestureRecognizer:messagesTap];           
                [holding_array_icons addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_icon"];
                
                [icons_array addObject:userResizableView];
            }
            
            if ([icon_type isEqualToString:@"ext_7"]) 
            {  
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                userResizableView.imageView.frame = gripFrame;
                userResizableView.imageView.image = [UIImage imageNamed:@"icon_driveway.png"];
                userResizableView.contentView = userResizableView.imageView;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];       
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];        
                [userResizableView addGestureRecognizer:messagesTap];           
                [holding_array_icons addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_icon"];
                
                [icons_array addObject:userResizableView];
            }
            
            if ([icon_type isEqualToString:@"ext_8"]) 
            {  
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                userResizableView.imageView.frame = gripFrame;
                userResizableView.imageView.image = [UIImage imageNamed:@"icon_sidewalk.png"];
                userResizableView.contentView = userResizableView.imageView;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];       
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];        
                [userResizableView addGestureRecognizer:messagesTap];           
                [holding_array_icons addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_icon"];
                
                [icons_array addObject:userResizableView];
            }
            
            if ([icon_type isEqualToString:@"ext_9"]) 
            {  
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                userResizableView.imageView.frame = gripFrame;
                userResizableView.imageView.image = [UIImage imageNamed:@"icon_ac.png"];
                userResizableView.contentView = userResizableView.imageView;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];       
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];        
                [userResizableView addGestureRecognizer:messagesTap];           
                [holding_array_icons addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_icon"];
                
                [icons_array addObject:userResizableView];
            }
            
            if ([icon_type isEqualToString:@"ext_10"]) 
            {  
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                userResizableView.imageView.frame = gripFrame;
                userResizableView.imageView.image = [UIImage imageNamed:@"icon_stairs.png"];
                userResizableView.contentView = userResizableView.imageView;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];       
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];        
                [userResizableView addGestureRecognizer:messagesTap];           
                [holding_array_icons addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_icon"];
                
                [icons_array addObject:userResizableView];
            }
            if ([icon_type isEqualToString:@"ext_11"])
            {
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                userResizableView.imageView.frame = gripFrame;
                userResizableView.imageView.image = [UIImage imageNamed:@"icon_Door.png"];
                userResizableView.contentView = userResizableView.imageView;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];
                [userResizableView addGestureRecognizer:messagesTap];
                [holding_array_icons addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_icon"];
                
                [icons_array addObject:userResizableView];
            }

            //Last statment if it is a circle or square resuse the code.
            if ([icon_type isEqualToString:@"circle"]) 
            {  
                
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                Circle * circle_view = [[Circle alloc] initWithFrame:gripFrame];
                circle_view.line_color = current_color;
                circle_view.line_pattern = current_line_pattern;
                circle_view.backgroundColor = [UIColor clearColor];
                circle_view.userInteractionEnabled = NO;  
                [userResizableView setAutoresizesSubviews:YES];
                userResizableView.contentView = circle_view;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                currentlyEditingView = userResizableView;
                lastEditedView = userResizableView;
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];       
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];        
                [userResizableView addGestureRecognizer:messagesTap];           
                [holding_array_circles addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_circle"];
                
                [circle_array addObject:userResizableView];
            }
            if ([icon_type isEqualToString:@"rectangle"]) 
            {  
                
                CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
                SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
                Rectangle * rect_view = [[Rectangle alloc] initWithFrame:gripFrame];
                rect_view.line_color = current_color;
                rect_view.line_pattern = current_line_pattern;
                rect_view.backgroundColor = [UIColor clearColor];
                rect_view.userInteractionEnabled = NO;  
                [userResizableView setAutoresizesSubviews:YES];
                userResizableView.contentView = rect_view;
                userResizableView.delegate = self;
                userResizableView.is_icon = YES;
                [userResizableView showEditingHandles];
                currentlyEditingView = userResizableView;
                lastEditedView = userResizableView;
                
                [self addSubview:userResizableView];
                
                //set the currently selected view to one you just placed in order for rotate to work
                currently_selected_view = userResizableView;
                
                UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
                [panrecognizer setCancelsTouchesInView:NO];
                [userResizableView addGestureRecognizer:panrecognizer];
                
                UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(icon_double_tapped:)];       
                [messagesTap setDelegate:self];
                [messagesTap setNumberOfTapsRequired:2];        
                [userResizableView addGestureRecognizer:messagesTap];           
                [holding_array_rects addObject:userResizableView];
                
                [self deselect_all_icons_and_textfields_except_one:userResizableView];
                
                place_icon = NO;
                [track_of_activites addObject:@"placed_rectangle"];
                
                [rect_array addObject:userResizableView];
            }


        }
        else if (place_textfield) 
        {
            if (holding_array_textboxes == nil) 
            {
                holding_array_textboxes = [[NSMutableArray alloc] init];
            }
            
            UITouch *touch = [[event touchesForView:self] anyObject];
            CGPoint location = [touch locationInView:self]; 
            
            //USE 
            CGRect gripFrame = CGRectMake(location.x, location.y, 240, 100);
            SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];        
            userResizableView.wrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 100)];
            userResizableView.wrapper.backgroundColor = [UIColor clearColor];
            
            UITextView * to_add = [[UITextView alloc] init];
            to_add.frame = CGRectMake(0, 20, 220, 60);
            to_add.delegate = userResizableView;        
            to_add.font = [UIFont fontWithName:@"Arial" size:20];
            to_add.textAlignment = UITextAlignmentCenter;
            //to_add.placeholder = @"Double Tap to add text";
            to_add.text = @"";
            to_add.textColor = current_color;
            [to_add setBackgroundColor:[self colorWithHexString:@"e6e9eb"]];  
            
            [userResizableView.wrapper addSubview:to_add];
            userResizableView.contentView = userResizableView.wrapper;
            userResizableView.contentView.backgroundColor = [UIColor clearColor];
            
            userResizableView.delegate = self;
            
            
            [userResizableView showEditingHandles];
            
            currentlyEditingView = userResizableView;
            lastEditedView = userResizableView;
            
            [self addSubview:userResizableView];
            
            UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];       
            [panrecognizer setCancelsTouchesInView:NO];
            [userResizableView addGestureRecognizer:panrecognizer];
            
            UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(text_field_double_tapped:)];       
            [messagesTap setDelegate:self];
            [messagesTap setNumberOfTapsRequired:2];        
            [userResizableView addGestureRecognizer:messagesTap];
            [holding_array_textboxes addObject:userResizableView];
            [self deselect_all_icons_and_textfields_except_one:userResizableView];
            [userResizableView select_text_field];
            place_textfield = NO;
            [track_of_activites addObject: @"place_textfield"];
            
            [textboxes_array addObject:userResizableView];
            
        }
        else if(draw_slected) 
        {
            
            Line_Point * to_be_added = [[Line_Point alloc] init];
            to_be_added.line_color = [UIColor colorWithCGColor: current_color.CGColor];
            to_be_added.line_pattern = [NSString stringWithString: current_line_pattern];        
            UITouch *touch = [[event touchesForView:self] anyObject];
            CGPoint location = [touch locationInView:self];
            to_be_added.point = [NSValue valueWithCGPoint:(location)];
            if (location.x == 0 && location.y == 0) 
            {
                
                
            }
            else 
            {
                [self.points addObject:to_be_added]; 
            }
            
            Line_Point * to_end = [[Line_Point alloc] init];
            to_end.line_color = [UIColor colorWithCGColor: current_color.CGColor];
            to_end.line_pattern = [NSString stringWithString: current_line_pattern];
            CGPoint endPoint = CGPointMake(-99, -99); //"end of path" indicator
            to_end.point = [NSValue valueWithCGPoint:(endPoint)];
            [self.points addObject:to_end];            
            [self setNeedsDisplay];            
            
            drawing = NO;
            
            [track_of_activites addObject:@"freeform_tool"];
            
        }
        else if (straight_line_selected)
        {            
            
            Line_Point * to_be_added = [[Line_Point alloc] init];
            to_be_added.line_color = [UIColor colorWithCGColor: current_color.CGColor];
            to_be_added.line_pattern = [NSString stringWithString: current_line_pattern];
            UITouch *touch = [[event touchesForView:self] anyObject];
            CGPoint location = [touch locationInView:self];
            to_be_added.point = [NSValue valueWithCGPoint:(location)];
            
            if (location.x == 0 && location.y == 0)
            {
                
                
            }
            else
            {               
                
                if(self.straight_line_tool_points.count == 0)
                {
                    NSLog(@"first press");
                    [self.straight_line_tool_points addObject:to_be_added];
                    [self setNeedsDisplay];
                    [track_of_activites addObject:@"straight_line_tool"];
                }
                else
                {
                                       
                    //Add the point to draw too
                    [self.straight_line_tool_points addObject:to_be_added];
                    
                    [self setNeedsDisplay];
                    [track_of_activites addObject:@"straight_line_tool"];
                    
                    
                    /*
                    
                    //end the line
                    Line_Point * to_end = [[Line_Point alloc] init];
                    to_end.line_color = [UIColor colorWithCGColor: [UIColor blackColor].CGColor];
                    to_end.line_pattern = [NSString stringWithString: current_line_pattern];
                    CGPoint endPoint = CGPointMake(-99, -99); //"end of path" indicator
                    to_end.point = [NSValue valueWithCGPoint:(endPoint)];
                    [self.straight_line_tool_points addObject:to_end];
                    
                    //start the new line
                    Line_Point * to_be_added2 = [[Line_Point alloc] init];
                    to_be_added2.line_color = [UIColor colorWithCGColor: current_color.CGColor];
                    to_be_added2.line_pattern = [NSString stringWithString: current_line_pattern];
                    UITouch *touch = [[event touchesForView:self] anyObject];
                    CGPoint location = [touch locationInView:self];
                    to_be_added2.point = [NSValue valueWithCGPoint:(location)];
                    [self.straight_line_tool_points addObject:to_be_added2];                  
                    [self setNeedsDisplay];
                    [track_of_activites addObject:@"straight_line_tool"];
                    
                     */
                }

               
               
                
            }
         
        
        
        
            
        }

  
    }
    else if (comments_mode) 
    {
        
        UITouch *touch = [[event touchesForView:self] anyObject];
        CGPoint location = [touch locationInView:self];
        
        CGRect gripFrame = CGRectMake(location.x, location.y, 75, 75);
        SPUserResizableView * userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
        
        //Comments * icon_view = [[Comments alloc] initWithFrame:gripFrame];
        
        userResizableView.imageView.frame = gripFrame;
        userResizableView.imageView.image = [UIImage imageNamed:@"Icon.png"];
     //   icon_view.number.text = [NSString stringWithFormat:@"%d",commentCount];
        userResizableView.number.text = [NSString stringWithFormat:@"%d",commentCount];
        if(commentCount > 9)
        {
            // icon_view.number.frame = CGRectMake(13, 10, 30, 30);
            userResizableView.number.frame =  CGRectMake(13, 10, 30, 30);
        }
        else
        {
            // icon_view.number.frame = CGRectMake(20, 10, 30, 30);
            userResizableView.number.frame =  CGRectMake(20, 10, 30, 30);
        }
        
        //set number frame 
    /*    if(commentCount > 9)
        {
           // icon_view.number.frame = CGRectMake(13, 10, 30, 30);
            userResizableView.number.frame =  CGRectMake(13, 10, 30, 30);
        }
        else
        {
           // icon_view.number.frame = CGRectMake(20, 10, 30, 30);
            userResizableView.number.frame =  CGRectMake(20, 10, 30, 30);
        }
        */
      //  icon_view.image = [UIImage imageNamed:@"Icon.png"];
      //  icon_view.userInteractionEnabled = YES;
        
        
        userResizableView.contentView = userResizableView.imageView;
        userResizableView.delegate = self;
        userResizableView.is_icon = YES;       
        currentlyEditingView = userResizableView;
        lastEditedView = userResizableView;
        
        [self addSubview:userResizableView];
        
        UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] init];
        [panrecognizer setCancelsTouchesInView:NO];
        [userResizableView addGestureRecognizer:panrecognizer];
        
        UITapGestureRecognizer *messagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comment_tapped:)];
        [messagesTap setDelegate:self];
        [messagesTap setNumberOfTapsRequired:1];
        [userResizableView addGestureRecognizer:messagesTap];
        
        UITapGestureRecognizer *messagesTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(display_comments:)];
        [messagesTap2 setDelegate:self];
        [messagesTap2 setNumberOfTapsRequired:2];
        [userResizableView addGestureRecognizer:messagesTap2];
        
        if (holding_array_icons == nil) 
        {
            holding_array_icons = [[NSMutableArray alloc] init];
        }
        
        [holding_array_icons addObject:userResizableView];
        
        [self deselect_all_icons_and_textfields_except_one:userResizableView];
        
        place_icon = NO;
        [track_of_activites addObject:@"comment"];
        commentCount++;
        
        [comments_array addObject:userResizableView];

        
    }
    
    
    
     [self save];
    
    
    
}
-(void)comment_tapped:(UITapGestureRecognizer *)gr
{    
    view_tapped = (SPUserResizableView*)gr.view;
    [self deselect_all_icons_and_textfields_except_one:view_tapped];
    for (SPUserResizableView * to_be_changed in holding_array_icons) 
    {
        if ([to_be_changed isEqual:view_tapped]) 
        {
            currently_selected_view = to_be_changed;
            to_be_changed.not_movable = !to_be_changed.not_movable;
            if (to_be_changed.not_movable == YES) 
            {               
                [view_tapped hideEditingHandles];
            }
            else 
            {
                [view_tapped showEditingHandles];
            }
        }
    }   
}
-(void)text_field_double_tapped:(UITapGestureRecognizer *)gr
{
    view_tapped = (SPUserResizableView*)gr.view;
    [self deselect_all_icons_and_textfields_except_one:view_tapped];
       
    
    for (SPUserResizableView * to_be_changed in holding_array_textboxes) 
    {
        if ([to_be_changed isEqual:view_tapped]) 
        {
            currently_selected_view = to_be_changed;
            to_be_changed.not_movable = !to_be_changed.not_movable;
            if (to_be_changed.not_movable == YES) 
            {               
                [view_tapped hideEditingHandles];
            }
            else 
            {
                [view_tapped showEditingHandles];
            }
        }
    }
    
    
    
}
-(void)icon_double_tapped:(UITapGestureRecognizer *)gr
{    
    view_tapped = (SPUserResizableView*)gr.view;
    [self deselect_all_icons_and_textfields_except_one:view_tapped];
    for (SPUserResizableView * to_be_changed in holding_array_icons) 
    {
        if ([to_be_changed isEqual:view_tapped]) 
        {
            currently_selected_view = to_be_changed;
            to_be_changed.not_movable = !to_be_changed.not_movable;
            if (to_be_changed.not_movable == YES) 
            {               
                [view_tapped hideEditingHandles];
            }
            else 
            {
                [view_tapped showEditingHandles];
            }
        }
    }   
}
-(void)rotate
{
    if (currently_selected_view.not_movable == YES)
    {
        //not editable
    }
    else
    {   
        CGAffineTransform transform;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationCurve:UIViewAnimationOptionBeginFromCurrentState];
        currently_selected_view.alpha = 1;
        transform = CGAffineTransformRotate(currently_selected_view.transform,0.5*M_PI);
        [currently_selected_view setUserInteractionEnabled:YES];
        currently_selected_view.transform = transform;
        [UIView commitAnimations];
    }
}
-(void)deselect_all_icons_and_textfields_except_one:(SPUserResizableView*)selected
{
    
    for (SPUserResizableView * to_be_changed in self.subviews) 
    {
        if ([to_be_changed isKindOfClass:[SPUserResizableView class]] && ![to_be_changed isEqual:selected]) 
        {
            to_be_changed.not_movable = YES;            
            [to_be_changed hideEditingHandles];
            
        }
    }   
    
}
-(void)up_pressed
{    
    up_pressed = YES;
    
}
-(void)down_pressed
{    
    down_pressed = YES;    
}
-(void)left_pressed
{    
    left_pressed = YES;    
}
-(void)right_pressed
{
    right_pressed = YES;  
    
}
-(void)drawRect:(CGRect)rect
{
               
        
        //Free form tool.
        if (self.points.count == 0)        
        {
            
        }
        else 
        {    
            Line_Point * first = [self.points objectAtIndex:0];
            CGContextRef context2 = UIGraphicsGetCurrentContext();
            CGContextSetStrokeColorWithColor(context2, first.line_color.CGColor);
            if ([first.line_pattern isEqualToString:@"normal"]) 
            {
                CGContextSetLineWidth(context2, 1.0);
                CGContextSetLineDash(context2, 0, NULL, 0);
            }
            else if([first.line_pattern isEqualToString:@"thick"])            
            {
                CGContextSetLineWidth(context2, 4.0);
                CGContextSetLineDash(context2, 0, NULL, 0);
            }
            else if([first.line_pattern isEqualToString:@"dotted"])            
            {
                CGFloat Pattern[] = {5, 5, 5, 5};
                CGContextSetLineDash(context2, 0, Pattern, 4);
            }
            else if([first.line_pattern isEqualToString:@"super_dotted"])            
            {   
                CGContextSetLineWidth(context2, 2.0); 
                CGFloat Pattern[] = {1, 2, 1, 2}; 
                CGContextSetLineDash(context2, 0, Pattern, 4); 
            }           
            CGPoint firstPoint2 = [first.point CGPointValue];
            CGContextBeginPath(context2);
            CGContextMoveToPoint(context2, firstPoint2.x, firstPoint2.y);
            
            int i2 = 1;
            while (i2 < self.points.count)
            {                    
                Line_Point * nextPoint = [self.points objectAtIndex:i2]; 
                
                if (nextPoint.point.CGPointValue.x < 0 && nextPoint.point.CGPointValue.y < 0)
                {
                    CGContextDrawPath(context2, kCGPathStroke);
                    
                    if (i2 < (self.points.count-1))
                    {
                        
                        CGContextBeginPath(context2);
                        Line_Point * nextPoint2 = [self.points objectAtIndex:i2+1];                
                        CGContextMoveToPoint(context2, nextPoint2.point.CGPointValue.x, nextPoint2.point.CGPointValue.y);
                        CGContextSetStrokeColorWithColor(context2, nextPoint2.line_color.CGColor);
                        if ([nextPoint2.line_pattern isEqualToString:@"normal"]) 
                        {
                            CGContextSetLineWidth(context2, 1.0);
                            CGContextSetLineDash(context2, 0, NULL, 0);
                        }
                        else if([nextPoint2.line_pattern isEqualToString:@"thick"])            
                        {
                            CGContextSetLineWidth(context2, 4.0);
                            CGContextSetLineDash(context2, 0, NULL, 0);
                        }
                        else if([nextPoint2.line_pattern isEqualToString:@"dotted"])            
                        {
                            CGContextSetLineWidth(context2, 2.0);
                            CGFloat Pattern[] = {5, 5, 5, 5};
                            CGContextSetLineDash(context2, 0, Pattern, 4);  
                        }
                        else if([nextPoint2.line_pattern isEqualToString:@"super_dotted"])            
                        {
                            CGContextSetLineWidth(context2, 2.0);
                            CGFloat Pattern[] = {1, 2, 1, 2}; 
                            CGContextSetLineDash(context2, 0, Pattern, 4);
                        }        
                        i2 = i2 + 2;
                        
                    }
                    else
                        i2++;
                }
                else
                {
                    CGContextAddLineToPoint(context2, nextPoint.point.CGPointValue.x, nextPoint.point.CGPointValue.y);
                    i2++;
                }
                       
            }
            
            CGContextDrawPath(context2, kCGPathStroke);
        }
    
    //This method is for the free line tool point.
    if (self.straight_line_tool_points.count == 0)
    {
        return;
    }
    else
    {
       /* Line_Point * first = [self.straight_line_tool_points objectAtIndex:0];
        CGContextRef context2 = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context2, first.line_color.CGColor);
        if ([first.line_pattern isEqualToString:@"normal"])
        {
            CGContextSetLineWidth(context2, 1.0);
            CGContextSetLineDash(context2, 0, NULL, 0);
        }
        else if([first.line_pattern isEqualToString:@"thick"])
        {
            CGContextSetLineWidth(context2, 4.0);
            CGContextSetLineDash(context2, 0, NULL, 0);
        }
        else if([first.line_pattern isEqualToString:@"dotted"])
        {
            CGFloat Pattern[] = {5, 5, 5, 5};
            CGContextSetLineDash(context2, 0, Pattern, 4);
        }
        else if([first.line_pattern isEqualToString:@"super_dotted"])
        {
            CGContextSetLineWidth(context2, 2.0);
            CGFloat Pattern[] = {1, 2, 1, 2};
            CGContextSetLineDash(context2, 0, Pattern, 4);
        }
        CGPoint firstPoint2 = [first.point CGPointValue];
        CGContextBeginPath(context2);
        CGContextMoveToPoint(context2, firstPoint2.x, firstPoint2.y);*/
        
        
        int i2 = 0;
        while (i2 < self.straight_line_tool_points.count)
        {
            if(i2 % 2)
            {
                Line_Point * nextPoint = [self.straight_line_tool_points objectAtIndex:i2];
                //MKOverlayView * new  = [[MKOverlayView alloc] initWithFrame:self.frame];                
                CGContextRef context2 = UIGraphicsGetCurrentContext();
                CGContextSetStrokeColorWithColor(context2, nextPoint.line_color.CGColor);
                if ([nextPoint.line_pattern isEqualToString:@"normal"])
                {
                    CGContextSetLineWidth(context2, 1.0);
                    CGContextSetLineDash(context2, 0, NULL, 0);
                }
                else if([nextPoint.line_pattern isEqualToString:@"thick"])
                {
                    CGContextSetLineWidth(context2, 4.0);
                    CGContextSetLineDash(context2, 0, NULL, 0);
                }
                else if([nextPoint.line_pattern isEqualToString:@"dotted"])
                {
                    CGFloat Pattern[] = {5, 5, 5, 5};
                    CGContextSetLineDash(context2, 0, Pattern, 4);
                }
                else if([nextPoint.line_pattern isEqualToString:@"super_dotted"])
                {
                    CGContextSetLineWidth(context2, 2.0);
                    CGFloat Pattern[] = {1, 2, 1, 2};
                    CGContextSetLineDash(context2, 0, Pattern, 4);
                }
                
                CGContextAddLineToPoint(context2, nextPoint.point.CGPointValue.x, nextPoint.point.CGPointValue.y);
                i2++;
                CGContextDrawPath(context2, kCGPathStroke);
                
            }
            
            else
            {
                Line_Point * first = [self.straight_line_tool_points objectAtIndex:i2];
                CGContextRef context2 = UIGraphicsGetCurrentContext();
                CGContextSetStrokeColorWithColor(context2, first.line_color.CGColor);
                if ([first.line_pattern isEqualToString:@"normal"])
                {
                    CGContextSetLineWidth(context2, 1.0);
                    CGContextSetLineDash(context2, 0, NULL, 0);
                }
                else if([first.line_pattern isEqualToString:@"thick"])
                {
                    CGContextSetLineWidth(context2, 4.0);
                    CGContextSetLineDash(context2, 0, NULL, 0);
                }
                else if([first.line_pattern isEqualToString:@"dotted"])
                {
                    CGFloat Pattern[] = {5, 5, 5, 5};
                    CGContextSetLineDash(context2, 0, Pattern, 4);
                }
                else if([first.line_pattern isEqualToString:@"super_dotted"])
                {
                    CGContextSetLineWidth(context2, 2.0);
                    CGFloat Pattern[] = {1, 2, 1, 2};
                    CGContextSetLineDash(context2, 0, Pattern, 4);
                }
                
                CGPoint firstPoint2 = [first.point CGPointValue];
                CGContextBeginPath(context2);
                CGContextMoveToPoint(context2, firstPoint2.x, firstPoint2.y);
                i2++;
            }
        }
            
            /*
            
            if (nextPoint.point.CGPointValue.x < 0 && nextPoint.point.CGPointValue.y < 0)
            {
                CGContextDrawPath(context2, kCGPathStroke);
                
                if (i2 < (self.straight_line_tool_points.count-1))
                {                    
                    CGContextBeginPath(context2);
                    Line_Point * nextPoint2;
                    Line_Point * nextPoint_for_color;
                    if (self.straight_line_tool_points.count > i2 +2)
                    {
                        nextPoint_for_color = [self.straight_line_tool_points objectAtIndex:i2 + 2];              
                                                                       
                    }
                    else
                    {
                        nextPoint_for_color = [self.straight_line_tool_points objectAtIndex:i2 + 1];
                    }
                   
                    nextPoint2 = [self.straight_line_tool_points objectAtIndex:i2 + 1];                    
                    CGContextMoveToPoint(context2, nextPoint2.point.CGPointValue.x, nextPoint2.point.CGPointValue.y);
                    CGContextSetStrokeColorWithColor(context2, nextPoint_for_color.line_color.CGColor);
                    if ([nextPoint_for_color.line_pattern isEqualToString:@"normal"])
                    {
                        CGContextSetLineWidth(context2, 1.0);
                        CGContextSetLineDash(context2, 0, NULL, 0);
                    }
                    else if([nextPoint_for_color.line_pattern isEqualToString:@"thick"])
                    {
                        CGContextSetLineWidth(context2, 4.0);
                        CGContextSetLineDash(context2, 0, NULL, 0);
                    }
                    else if([nextPoint_for_color.line_pattern isEqualToString:@"dotted"])
                    {
                        CGContextSetLineWidth(context2, 2.0);
                        CGFloat Pattern[] = {5, 5, 5, 5};
                        CGContextSetLineDash(context2, 0, Pattern, 4);
                    }
                    else if([nextPoint_for_color.line_pattern isEqualToString:@"super_dotted"])
                    {
                        CGContextSetLineWidth(context2, 2.0);
                        CGFloat Pattern[] = {1, 2, 1, 2};
                        CGContextSetLineDash(context2, 0, Pattern, 4);
                    }
                    i2 = i2 + 2;
                    
                }
            
                else
                    i2++;
            }
            else
            {
                CGContextAddLineToPoint(context2, nextPoint.point.CGPointValue.x, nextPoint.point.CGPointValue.y);
                i2++;
            }
             
         CGContextDrawPath(context2, kCGPathStroke);
        */
    }

    
     
    
    
    
}
-(void)add_starting_point
{
    first_point_foundation = YES;
    
}
-(void)new_object
{
    CGPoint endPoint = CGPointMake(-99, -99); //"end of path" indicator
    [self.straight_line_points addObject:[NSValue valueWithCGPoint:(endPoint)]];
    
    count2++;
    new_object = YES;    
}
-(void)add_icon:(NSNotification*)message
{
    if (icon_type == nil) 
    {
        icon_type = [[NSString alloc] init];
    }     
    icon_type = message.object;
    place_icon = YES;
    draw_slected = NO;
    place_textfield = NO;
    straight_line_selected = NO;
}
-(void)dont_add_icon
{
    place_icon = NO;
    draw_slected = NO;
    place_textfield = NO;
    straight_line_selected = NO;
    
}
-(void)add_textbox
{
  draw_slected = NO;
  place_textfield = YES;
  place_icon = NO;
  straight_line_selected = NO;
    
}
-(void)dont_add_textbox
{
    draw_slected = NO;
    place_textfield = NO;
    place_icon = NO;
    straight_line_selected = NO;
    
}
-(void)draw_selected
{
    draw_slected = YES;    
    place_icon = NO;
    place_textfield = NO;
    straight_line_selected = NO;
    
}
-(void)straight_line_selected
{
    
    straight_line_selected = YES;
    draw_slected = NO;
    place_icon = NO;
    place_textfield = NO;
    
}
-(void)straight_line_deselected
{
    straight_line_selected = NO;
    draw_slected = NO;
    place_icon = NO;
    place_textfield = NO;
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{        
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"touch" object:nil];
    if (foundation_mode) 
    {
        
    }
    else if(details_mode)
    {
        if (draw_slected) 
        {   
            
            
            Line_Point * to_be_added = [[Line_Point alloc] init];
            to_be_added.line_color = [UIColor colorWithCGColor: current_color.CGColor];
            to_be_added.line_pattern = [NSString stringWithString: current_line_pattern]; 
            
            UITouch *touch = [[event touchesForView:self] anyObject];
                        
            CGPoint location = [touch locationInView:self];
            to_be_added.point = [NSValue valueWithCGPoint:(location)];  
            
            if (self.points == nil)
            {
                NSMutableArray *newPoints = [[NSMutableArray alloc] init];
                self.points = newPoints;
                [newPoints release];
            }
            
            if (location.x == 0 && location.y == 0) 
            {
                
                
            }
            else 
            {
                [self.points addObject:to_be_added]; 
            }           

            
            
        }
         
    }
    else if (comments_mode) 
    {
        
    }
        
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (foundation_mode) 
    {
        
    }
    else if(details_mode)
    {
        /*if (draw_slected)
        {   
                       
            UITouch *touch = [touches anyObject];
            CGPoint touchLocation = [touch locationInView:self];
            Line_Point * to_be_added = [[Line_Point alloc] init];
            to_be_added.line_color = [UIColor colorWithCGColor: current_color.CGColor];
            to_be_added.line_pattern = [NSString stringWithString: current_line_pattern];
            to_be_added.point = [NSValue valueWithCGPoint:(touchLocation)];
            [self.points addObject:to_be_added];
            //[self setNeedsDisplay];
            
            
        }*/
 
    }
    else if (comments_mode) 
    {
        
    }

            
    
}

- (UIColor *) colorWithHexString: (NSString *) hexString 
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) 
    {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];          
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];                      
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];                      
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}
- (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length 
{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}
-(void)color:(NSNotification*)message
{
    NSString * color = message.object;
    if ([color isEqualToString:@"red"]) 
    {
        current_color = [[self colorWithHexString:@"ff0000"] retain]; 
    }
    else if ([color isEqualToString:@"blue"]) 
    {        
        current_color = [[self colorWithHexString:@"1f487c"] retain];
    } 
    else if ([color isEqualToString:@"light_blue"]) 
    {        
        current_color = [[self colorWithHexString:@"8fa4bf"] retain];
    }
    else if ([color isEqualToString:@"green"]) 
    {        
        current_color = [[self colorWithHexString:@"9bbb58"] retain];
    }
    else if ([color isEqualToString:@"light_green"]) 
    {        
        current_color = [[self colorWithHexString:@"cdddac"] retain];
    }
    else if ([color isEqualToString:@"red"]) 
    {        
        current_color = [[self colorWithHexString:@"ff0000"] retain];
    }
    else if ([color isEqualToString:@"pink"]) 
    {        
        current_color = [[self colorWithHexString:@"ff7f7e"] retain];
    }
    else if ([color isEqualToString:@"yellow"]) 
    {        
        current_color = [[self colorWithHexString:@"ffff00"] retain];
    }
    else if ([color isEqualToString:@"light_yellow"]) 
    {        
        current_color = [[self colorWithHexString:@"feff7f"] retain];
    }
    else if ([color isEqualToString:@"black"]) 
    {        
        current_color = [[self colorWithHexString:@"000000"] retain];
    }
    else if ([color isEqualToString:@"gray"]) 
    {        
        current_color = [[self colorWithHexString:@"7f7f7f"] retain];
    }

    
}
-(void)line:(NSNotification*)message
{
   current_line_pattern = message.object;    
    
}
+ (Class)layerClass
{
    return [CATiledLayer class];
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


@end

















