//
//  DrawingView.m
//  iTerrian
//
//  Created by Nicholas Krzemienski on 10/15/12.
//  Copyright (c) 2012 Nicholas Krzemienski. All rights reserved.
//

#import "DrawingView.h"

@implementation DrawingView
@synthesize points;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        current_color = [UIColor blackColor];
        current_line_pattern = @"normal";
        self.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(draw_selected) name:@"draw_selected" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(draw_deselected) name:@"draw_deselected" object:nil];
        
        draw_selected = NO;
    }
    return self;
}
-(void)draw_selected
{
    draw_selected = YES;
    
}
-(void)draw_deselected
{
    draw_selected = NO;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (draw_selected)
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
    
    }

}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (draw_selected)
    {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    Line_Point * to_be_added = [[Line_Point alloc] init];
    to_be_added.line_color = [UIColor colorWithCGColor: current_color.CGColor];
    to_be_added.line_pattern = [NSString stringWithString: current_line_pattern];
    to_be_added.point = [NSValue valueWithCGPoint:(touchLocation)];
    [self.points addObject:to_be_added];
    [self setNeedsDisplay];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (draw_selected)
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


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
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
}
+ (Class)layerClass
{
    return [CATiledLayer class];
}



@end
