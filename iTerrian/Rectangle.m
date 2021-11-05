//
//  Rectangle.m
//  MAW
//
//  Created by Nicholas Krzemienski on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Rectangle.h"

@implementation Rectangle
@synthesize line_color;
@synthesize line_pattern;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self setNeedsDisplay];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode the properties of the object
    [encoder encodeObject:self.line_color forKey:@"line_color"];
    [encoder encodeObject:self.line_pattern forKey:@"line_pattern"];
    [encoder encodeCGRect:self.frame forKey:@"frame"];
    
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if ( self != nil )
    {
        //decode the properties
        self.line_color = [decoder decodeObjectForKey:@"line_color"];
        self.line_pattern = [decoder decodeObjectForKey:@"line_pattern"];
        self.frame = [decoder decodeCGRectForKey:@"frame"];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.height-20)];
    [[UIColor clearColor] setFill];
    [rectanglePath fill];
    
    [line_color setStroke];   
    if ([line_pattern isEqualToString:@"normal"]) 
    {
        rectanglePath.lineWidth = 1;
        [rectanglePath stroke];
    }
    else if([line_pattern isEqualToString:@"thick"])
    {
       [rectanglePath setLineWidth: 3]; 
    }
    else if([line_pattern isEqualToString:@"dotted"])
    {
        [rectanglePath setLineWidth: 1];
        CGFloat rectanglePattern[] = {5, 5, 5, 5};
        [rectanglePath setLineDash: rectanglePattern count: 4 phase: 0];
        [rectanglePath stroke];
    }
    else if ([line_pattern isEqualToString:@"super_dotted"]) 
    {
        [rectanglePath setLineWidth: 1];
        CGFloat rectanglePattern[] = {2, 2, 2, 2};
        [rectanglePath setLineDash: rectanglePattern count: 4 phase: 0];
        [rectanglePath stroke];
    }
   

}

@end
