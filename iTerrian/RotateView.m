//
//  RotateView.m
//  MAW
//
//  Created by Nicholas Krzemienski on 8/24/12.
//
//

#import "RotateView.h"

@implementation RotateView

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
    rotate = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 77/2, 71/2)];
    [rotate setImage:[UIImage imageNamed:@"btn_rotate_0.PNG"] forState:UIControlStateNormal];
    [rotate setImage:[UIImage imageNamed:@"btn_rotate_1.PNG"] forState:UIControlStateHighlighted];    
    rotate.backgroundColor = [UIColor clearColor];
    [rotate addTarget: self action:@selector(rotate_pressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rotate];   
    
}
-(void)rotate_pressed
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"rotate_view" object:nil];
    
    
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
