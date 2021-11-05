

#import <Foundation/Foundation.h>
#import "Circle.h"
#import "Rectangle.h"

typedef struct SPUserResizableViewAnchorPoint 
{
    CGFloat adjustsX;
    CGFloat adjustsY;
    CGFloat adjustsH;
    CGFloat adjustsW;
} 
SPUserResizableViewAnchorPoint;

@protocol SPUserResizableViewDelegate;
@class SPGripViewBorderView;

@interface SPUserResizableView : UIView<UITextViewDelegate> 
{
    SPGripViewBorderView *borderView;
    UIView *contentView;
    CGPoint touchStart;
    CGFloat minWidth;
    CGFloat minHeight;
    BOOL not_movable;
    BOOL is_icon;
    UIImageView * imageView;
    NSString * commentString;
    UILabel * number;
    UIView * wrapper;
    // Used to determine which components of the bounds we'll be modifying, based upon where the user's touch started.
    SPUserResizableViewAnchorPoint anchorPoint;
    
    id <SPUserResizableViewDelegate> delegate;
}

@property (nonatomic, retain) UIImageView * imageView;
@property (nonatomic, retain) NSString * commentString;
@property (nonatomic, retain) UILabel * number;
@property (nonatomic, retain) UIView * wrapper;

@property (nonatomic, assign) id <SPUserResizableViewDelegate> delegate;

// Will be retained as a subview.
@property (nonatomic, assign) UIView *contentView;

//Will make the view not movable and respond to whats in it.
@property BOOL not_movable;
@property BOOL is_icon;


// Default is 48.0 for each.
@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat minHeight;

// Defaults to YES. Disables the user from dragging the view outside the parent view's bounds.
@property (nonatomic) BOOL preventsPositionOutsideSuperview;

- (void)hideEditingHandles;
- (void)showEditingHandles;
- (void)select_text_field;

@end

@protocol SPUserResizableViewDelegate <NSObject>

@optional

// Called when the resizable view receives touchesBegan: and activates the editing handles.
- (void)userResizableViewDidBeginEditing:(SPUserResizableView *)userResizableView;

// Called when the resizable view receives touchesEnded: or touchesCancelled:
- (void)userResizableViewDidEndEditing:(SPUserResizableView *)userResizableView;



@end
