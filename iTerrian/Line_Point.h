//
//  Line_Point.h
//  MAW
//
//  Created by Nicholas Krzemienski on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Line_Point : NSObject
{
    UIColor * line_color;
    NSValue * point;
    NSString * line_pattern;
    
    
}
@property (nonatomic, retain) UIColor * line_color;
@property (nonatomic, retain) NSString * line_pattern;
@property (nonatomic, retain) NSValue * point;
@end
