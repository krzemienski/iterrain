//
//  Freeform_Path.h
//  MAW
//
//  Created by Nicholas Krzemienski on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Freeform_Path : UIBezierPath
{
    UIColor * line_color;
    NSValue * point;
    NSString * line_pattern;
    
    
}
@property (nonatomic, retain) UIColor * line_color;
@property (nonatomic, retain) NSString * line_pattern;
@property (nonatomic, retain) NSValue * point;
@end


