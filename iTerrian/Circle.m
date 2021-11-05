//
//  Circle.m
//  MAW
//
//  Created by Nicholas Krzemienski on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Circle.h"

@implementation Circle
@synthesize line_pattern;
@synthesize line_color;

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
    [encoder encodeObject:self.line_pattern forKey:@"line_pattern"];
    [encoder encodeObject:self.line_color forKey:@"line_color"];
    [encoder encodeCGRect:self.frame forKey:@"frame"];

}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if ( self != nil )
    {
        //decode the properties
        self.line_pattern = [decoder decodeObjectForKey:@"line_pattern"];
        self.line_color = [decoder decodeObjectForKey:@"line_color"];
        self.frame = [decoder decodeCGRectForKey:@"frame"];
        
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [[UIColor clearColor] setFill];
    [ovalPath fill];
    
    [line_color setStroke];
      
    if ([line_pattern isEqualToString:@"normal"]) 
    {
         ovalPath.lineWidth = 1;
        [ovalPath stroke];
    }
    else if([line_pattern isEqualToString:@"thick"])
    {
        [ovalPath setLineWidth: 3]; 
    }
    else if([line_pattern isEqualToString:@"dotted"])
    {
        [ovalPath setLineWidth: 1];
        CGFloat rectanglePattern[] = {5, 5, 5, 5};
        [ovalPath setLineDash: rectanglePattern count: 4 phase: 0];
        [ovalPath stroke];
    }
    else if ([line_pattern isEqualToString:@"super_dotted"]) 
    {
        [ovalPath setLineWidth: 1];
        CGFloat rectanglePattern[] = {2, 2, 2, 2};
        [ovalPath setLineDash: rectanglePattern count: 4 phase: 0];
        [ovalPath stroke];
    }
  
  
}


@end
