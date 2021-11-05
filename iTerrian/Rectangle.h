//
//  Rectangle.h
//  MAW
//
//  Created by Nicholas Krzemienski on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Rectangle : UIView
{
    UIColor * line_color;
    NSString * line_pattern;
}
@property (nonatomic, retain) UIColor * line_color;
@property (nonatomic, retain) NSString * line_pattern;
@end
