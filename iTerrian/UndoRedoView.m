//
//  UndoRedoView.m
//  MAW
//
//  Created by Nicholas Krzemienski on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UndoRedoView.h"

@implementation UndoRedoView

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
    undo = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 77/2, 71/2)];   
    [undo setImage:[UIImage imageNamed:@"btn_undo_black.png"] forState:UIControlStateNormal];  
    undo.backgroundColor = [UIColor clearColor];     
    [undo addTarget: self action:@selector(undo_pressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:undo];    
    
    redo = [[UIButton alloc] initWithFrame:CGRectMake(48, 0, 77/2, 71/2)];   
    [redo setImage:[UIImage imageNamed:@"btn_redo_black.png"] forState:UIControlStateNormal];  
    redo.backgroundColor = [UIColor clearColor];     
    [redo addTarget: self action:@selector(redo_pressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:redo];    
    
    
}
-(void)undo_pressed
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"undo_draw" object:nil];        
        
}
-(void)redo_pressed
{    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"redo_draw" object:nil];   
        
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
