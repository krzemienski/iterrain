//
//  Freeform_Path.m
//  MAW
//
//  Created by Nicholas Krzemienski on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Freeform_Path.h"

@implementation Freeform_Path
@synthesize point;
@synthesize line_color;
@synthesize line_pattern;

-(void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode the properties of the object
    [encoder encodeObject:self.line_pattern forKey:@"line_pattern"];
    [encoder encodeObject:self.line_color forKey:@"line_color"];
    [encoder encodeObject:self.point forKey:@"point"];
    
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if ( self != nil )
    {
        //decode the properties
        self.line_pattern = [decoder decodeObjectForKey:@"line_pattern"];
        self.line_color = [decoder decodeObjectForKey:@"line_color"];
        self.point = [decoder decodeObjectForKey:@"point"];
        
    }
    return self;
}


@end
