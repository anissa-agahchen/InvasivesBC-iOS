//
//  UIKitExtensions.h
//  SwingTIP_Coach
//
//  Created by Pushan Mitra on 18/09/13.
//  Copyright © 2013 Pushan Mitra (ios.dev.mitra@gmail.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

/**
 * @version     2.0
 * @date        21.8.2014
 * @discussion  Utility 
 */

/**
 * @discussion
 */
#define NSStringWithFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

/**
 * @category    UIView (MPLayoutCategory)
 * @discussion  Some additional extention to work with visual constraints
 */
@interface UIView (MPLayoutCategory)
/**
 * @method      removeWithConstraintsFromSuperview
 * @discussion  Category of removeFromSuperview with additional operation of removing all related constraint from super view.
 */
- (void)removeWithConstraintsFromSuperview;

/**
 * @method      removeAllConstraintsFromSuperview
 * @discussion  Method to remove all view related constraint from superview
 */
- (void)removeAllConstraintsFromSuperview;

/**
 * @method      virticalConstraintsWithFrame
 * @discussion  Create a vartical contraint from rect respect to view and return it.
 */
- (NSArray *) virticalConstraintsWithFrame:(CGRect) rect; 

/**
 * @method      horizontalConstraintsWithFrame
 * @discussion  Create a horizontal contraint from rect respect to view and return it.
 */
- (NSArray *) horizontalConstraintsWithFrame:(CGRect) rect;

/**
 * @method      addConstraintWithRespectToFrame
 * @discussion  Add new constraint as per view's own frame.
 */
- (void) addConstraintsToSuperviewRespectToViewFrame;

/*!
 * @method      removeAndAddConstraintsRespectToViewFrameToSuperview
 * @discussion  Remove all old constraint and add new constraint as per view's own frame
 */
- (void) removeAndAddConstraintsRespectToViewFrameToSuperview;

/**
 * @method      addSubViewWithLayoutSupport
 * @discussion  A wraper over addSubview to support autolayout.  
 */
- (void) addSubViewWithLayoutSupport:(UIView *) view;

/**
 * @method      allConstraintsOnSuperview
 * @discussion  Return all existing contraints related to view
 */
- (NSArray *) allConstraintsInSuperview;

/**
 * @method      addSubviewWithFullScreenLayout
 * @discussion  Add sub view with full screen layout of the superview.
 */
- (void) addSubviewWithFullScreenLayout:(UIView *) subview;

- (UIColor *) colorOfPoint:(CGPoint)point;
@end

/**
 * @category
 */
@interface UIView (NibLoad)
/**
 * @method      viewFromNib:bundle:owner:andIndex
 * @discussion  This method load view from nib and return it. In case of main bundle put nil in bundle argument .
 */
+ (UIView *) viewFromNib:(NSString *) nibName bundle:(NSBundle *) bundle owner:(id) owner andIndex:(NSInteger) indx;
@end

/**
 * @struct      CGBorder 
 * @discussion  Structure to hold border info of rect
 */
typedef struct {
    CGFloat top;
    CGFloat bottom;
    CGFloat left;
    CGFloat right;
} CGBorder;


@interface UIView (FrameBorder)
/**
 * @method
 */
- (void) setFrameWithBorder:(CGBorder) border;

@property (readonly) CGFloat viewHeight;
@property (readonly) CGFloat viewWidth;
@property (readonly) CGFloat viewOriginX;
@property (readonly) CGFloat viewOriginY;

@property (readonly) CGPoint midPoint;
@end


/**
 * @typedef     UIViewBounceAnimType
 * @const       UIViewBounceAnimFromLeft
 * @discussion  Bounce from left boundary
 
 * @const       UIViewBounceAnimFromRight
 * @discussion  Bounce from right boundary
 */
typedef enum {
    UIViewBounceAnimFromLeft,
    UIViewBounceAnimFromRight
} UIViewBounceAnimType;

typedef enum {
    UIViewLeftTransitionAnimation,
    UIViewRightTransitionAnimation,
    UIViewTopTransitionAnimation,
    UIViewBottomTransitionAnimation
} UIViewTransitionAnimation;

/**
 * @category    UIView (AppAnim)
 * @discussion  NSLayoutConstraint based animation
 */
@interface UIView (AppAnim)

/**
 * @discussion Bounce animation on view
 */
- (void) bounceAnimtionWithDuration:(NSTimeInterval) interval offset:(CGFloat)offset type:(UIViewBounceAnimType) type withCompletionHandle:(void(^)(BOOL finished)) handle;

/**
 * @discussion Frame base bounce animation.
 */
- (void) frameBounceAnimationWithDuration:(NSTimeInterval) interval offset:(CGFloat) offset type:(UIViewBounceAnimType) type withCompletionHandle:(void(^)(BOOL finished)) handle;

/**
 * @discussion View transition animation
 */
- (void) animateTransition:(UIViewTransitionAnimation) type WithDuration:(NSTimeInterval) interval nonGeometricAnimationOut:(void(^)(void)) animBlockOut animationIn:(void(^)(void)) animBlockIn completionHandle:(void(^)(BOOL finished)) handle;

/**
 * @discussion View transition from bottom of super view
 */
- (void) frameBasedTransitionFromBottonIn:(BOOL) inAnim withCompletionHandle:(void(^)(BOOL finished))handle;

@end

/**
 * @category    
 * @discussion None  
 */
@interface NSValue (CGBorderValue)

+ (NSValue *) valueWithCGBorder:(CGBorder) border;

- (CGBorder) borderValue;

@end



@interface UIColor (Extension)

/**
 * @discussion Return UIColor object with RGB values in array of length 4 .
 * @note In array Index[0] = R, Index[1] = G, Index[2] = B , Index[3] = Alpha
 */
+ (UIColor *) colorWithRGBAInArray:(NSArray *)array;

+ (UIColor *) colorWithIntegerRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue alpha:(CGFloat)alpha;

+ (UIColor *) colorWithR:(uint8_t)r g:(uint8_t)g b:(uint8_t)b a:(CGFloat)a;

@end

/**
 * @category        UIViewController (ApplicationState)
 * @discussion      This categorry add support for view controller class to handle various application state change
 */
@interface UIViewController (ApplicationState)

- (void) registerForApplicationStateNotification;
- (void) unregisterForApplicationStateNotification;

- (void)applicationWillResignActiveNotification:(NSNotification *) notification;
- (void)applicationDidEnterBackgroundNotification:(NSNotification *) notification;
- (void)applicationWillEnterForegroundNotification:(NSNotification *) notification;
- (void)applicationDidBecomeActiveNotification:(NSNotification *) notification;
@end

/**
 * @category        UIButton (Extension)
 * @discussion      Add additional fuctionality of UIButton class
 */
@interface UIButton (Extension)

/**
 * @discussion Set title for all state in application
 */
- (void) setTitleForAllState:(NSString *) title;
@end


/**
 * @category    UISlider (Utility)
 * @discussion  A category to set image for slider for all state.
 */
@interface UISlider (Utility)
- (void) setThumbImageForAllState:(UIImage *)image;
- (void) setTrackImageForAllState:(UIImage *) image;
@end


/**
 * @category    UIImage (TextImage)
 * @discussion  Utility to create image with text  
 */
@interface UIImage (TextImage)
/**
 * @discussion Create new image from a image with given text in middle of the image.
 */
+ (UIImage *) image:(UIImage *) image withText:(NSString *) text font:(UIFont *) font textColor:(UIColor *) color;
@end

/**
 * @category    UIImage (BlurImage)
 * @discussion  Utility to obtain GaussianBlur image of a normal image.        
 */
@interface UIImage (BlurImage)
- (UIImage *) blurImage;
+ (UIImage *) blurImageForImage:(UIImage *) image;
@end


/**
 * @category    UIView (LayerAnimation)
 * @discussion  Blink animation for view  
 */
@interface UIView (LayerAnimation)
-(void) addBlinkAnimationWithDuration:(NSTimeInterval) duration;
@end

/**
 * @category    UIView (BlurView)
 * @discussion  Category to create blur image
 */
@interface UIView (Images)

/**
 * @discussion Screen shot of the view
 */
- (UIImage *) screenShot;

/**
 * @discussion Blur image of the view
 */
- (UIImage *) blurImageOfView;

/**
 * @discussion Get blur image of the view asyn
 */
- (void) getBlurImage:(void(^)(UIImage * blurImg))callback;
@end


@interface UIView (Customization)
/**
 * @discussion Adding a 1 pixel border
 */
- (void) addDashBorderWithColor:(UIColor *) color;

/**
 * @discussion Adding a custom dash boarder.
 */
- (void) addDashBorderWithColor:(UIColor *)color width:(CGFloat) width dashPattern:(NSArray *) pattern onTop:(BOOL) onTop;

@end

@interface NSObject (RemoteTask)
@property (weak, nonatomic, nullable) NSURLSessionTask * remoteSessionTask;
@end
