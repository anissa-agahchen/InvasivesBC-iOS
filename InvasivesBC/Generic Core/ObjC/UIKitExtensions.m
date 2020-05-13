//
//  UIKitExtensions.m
//  SwingTIP_Coach
//
//  Created by Pushan Mitra on 18/09/13.
//  Copyright © 2013 Pushan Mitra (ios.dev.mitra@gmail.com). All rights reserved.
//

#import "UIKitExtensions.h"
#import <objc/runtime.h>
//#import "MPAppUtilityManager.h"

//------------------------------------- UIVIew ------------------------------------------------//
#pragma mark - UIView (MPLayoutCategory)
@implementation UIView (MPLayoutCategory)
- (void)removeWithConstraintsFromSuperview {
	NSMutableArray *constraints = [NSMutableArray array];
	UIView *superview = self.superview;
	for (NSLayoutConstraint *constraint in superview.constraints) {
		if ((constraint.firstItem == self) || (constraint.secondItem == self)) {
			[constraints addObject:constraint];
		}
	}
    [self removeFromSuperview];
	[superview removeConstraints:constraints];
	[constraints removeAllObjects];
}

- (void)removeAllConstraintsFromSuperview {
	NSMutableArray *constraints = [NSMutableArray array];
	UIView *superview = self.superview;
	for (NSLayoutConstraint *constraint in superview.constraints) {
		if ((constraint.firstItem == self) || (constraint.secondItem == self)) {
			[constraints addObject:constraint];
		}
	}
	[superview removeConstraints:constraints];
	[constraints removeAllObjects];
}
- (NSArray *) virticalConstraintsWithFrame:(CGRect)rect
{
    NSString * visualFormat = [NSString stringWithFormat:@"V:|-(%f)-[self(%f)]",rect.origin.y,rect.size.height];
    return [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                   options:NSLayoutFormatDirectionLeadingToTrailing 
                                                   metrics:nil 
                                                     views:NSDictionaryOfVariableBindings(self)];
}

- (NSArray *) horizontalConstraintsWithFrame:(CGRect)rect
{
    NSString * visualFormat = [NSString stringWithFormat:@"H:|-(%f)-[self(%f)]",rect.origin.x,rect.size.width];
    return [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                   options:NSLayoutFormatDirectionLeadingToTrailing 
                                                   metrics:nil 
                                                     views:NSDictionaryOfVariableBindings(self)];
}

- (void) addConstraintsToSuperviewRespectToViewFrame
{
    @try {
        NSArray * hConstraints = [self virticalConstraintsWithFrame:self.frame];
        NSArray * vConstraints = [self horizontalConstraintsWithFrame:self.frame];
        
        if (self.superview) {
            [self.superview addConstraints:hConstraints];
            [self.superview addConstraints:vConstraints];
        }
    }
    @catch (NSException *exception) {
        @throw exception;
    }
}
- (void) removeAndAddConstraintsRespectToViewFrameToSuperview
{
    [self removeAllConstraintsFromSuperview];
    [self addConstraintsToSuperviewRespectToViewFrame];
}

- (void) addSubViewWithLayoutSupport:(UIView *) view
{
    //[view removeAllConstraintsFromSuperview];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:view];
    [view addConstraintsToSuperviewRespectToViewFrame];
}

- (NSArray *) allConstraintsInSuperview
{
    NSMutableArray *constraints = [NSMutableArray array];
	UIView *superview = self.superview;
	for (NSLayoutConstraint *constraint in superview.constraints) {
		if ((constraint.firstItem == self) || (constraint.secondItem == self)) {
			[constraints addObject:constraint];
		}
	}
    
    return [NSArray arrayWithArray:constraints];
}

- (void) addSubviewWithFullScreenLayout:(UIView *) subview
{
    if (subview && [subview isKindOfClass:[UIView class]]) {
        [subview setTranslatesAutoresizingMaskIntoConstraints:NO];    
        [self addSubview:subview];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subview]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(subview)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subview]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(subview)]];
    }
    
}

- (UIColor *) colorOfPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIColor *color = [UIColor colorWithIntegerRed:pixel[0] green:pixel[1] blue:pixel[2] alpha:pixel[3]/(float)255.0];
    return color;
}


@end

@implementation UIView (FrameBorder)
@dynamic viewHeight,viewWidth,viewOriginX,viewOriginY,midPoint;
- (void) setFrameWithBorder:(CGBorder)border
{
    if (self.superview) {
        CGRect superBound = self.superview.bounds;
        CGFloat width   = superBound.size.width - (border.left + border.right);
        CGFloat height  = superBound.size.height - (border.top + border.bottom);
        CGRect newFrame = CGRectMake(border.left, border.top,width,height);
        [self setFrame:newFrame];
    }
    
}

- (CGFloat) viewHeight
{
    return self.bounds.size.height;
}

- (CGFloat) viewWidth
{
    return self.bounds.size.width;
}

- (CGFloat) viewOriginX
{
    return self.frame.origin.x;
}
- (CGFloat) viewOriginY
{
    return self.frame.origin.y;
}

- (CGPoint) midPoint
{
    return CGPointMake(self.viewWidth/2.0, self.viewHeight/2.0);
}

@end

@implementation UIView (AppAnim)

- (void) bounceAnimtionWithDuration:(NSTimeInterval) interval offset:(CGFloat)offset type:(UIViewBounceAnimType) type withCompletionHandle:(void(^)(BOOL finished)) handle
{
    // Procced if view is added to some layout structure.
    if (self.superview) {
        // Saving handle
        __strong id _handle = handle;
        // Existing constraint on super view
        __block NSArray * existingConstraints = [self allConstraintsInSuperview];
        
        // Remove all existing constraint from super view
        [self removeAllConstraintsFromSuperview];
        NSLayoutAttribute attibute = NSLayoutAttributeCenterX;
        NSLayoutRelation relation = NSLayoutRelationEqual;
        CGFloat multiplier = 1.0f;
        
        [self layoutIfNeeded];
        [self.superview layoutIfNeeded];
        
        /**
         * @bug         Wrong Bounce
         * @discussion  Now use different constraint for different anm type
         */
        CGFloat offsetWithSign = offset;
        switch (type) {
            case UIViewBounceAnimFromLeft:
            {
                attibute = NSLayoutAttributeCenterX;
                relation = NSLayoutRelationEqual;
                offsetWithSign = offset;
                multiplier = 1.0f;
                [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:attibute relatedBy:relation toItem:self.superview attribute:attibute multiplier:multiplier constant:offsetWithSign]];
                break;
            }
            case UIViewBounceAnimFromRight:
            {
                attibute = NSLayoutAttributeCenterX;
                relation = NSLayoutRelationEqual;
//                offsetWithSign = offset;
                multiplier = 1.0f;
                [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:attibute relatedBy:relation toItem:self.superview attribute:attibute multiplier:multiplier constant:-offset]];
                break;
            }
            default:
                break;
        }
        
        [UIView animateWithDuration:interval animations:^{
            [self.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeAllConstraintsFromSuperview];
                [self.superview addConstraints:existingConstraints];
                [self.superview layoutIfNeeded];
                
                // Calling handle
                if (_handle) {
                    void(^Block)(BOOL finished) = _handle;
                    Block(finished);
                }
            }
        }];
    }
}

- (void) frameBounceAnimationWithDuration:(NSTimeInterval) interval offset:(CGFloat) offset type:(UIViewBounceAnimType) type withCompletionHandle:(void(^)(BOOL finished)) handle
{
    if (self.superview) {
        // Saving handle
        __block id _handle = handle;
        // Existing constraint on super view
        __block NSArray * existingConstraints = [self allConstraintsInSuperview];
        
        // Remove all existing constraint from super view
        [self removeAllConstraintsFromSuperview];
        
        // Copy old frmae.
        __block CGRect frame = self.frame;
        CGFloat offsetWithSign = 0.0f;
        switch (type) {
            case UIViewBounceAnimFromLeft:
            {
                offsetWithSign = offset;
                break;
            }
            case UIViewBounceAnimFromRight:
            {
                offsetWithSign = -offset;
                break;
            }
            default:
                break;
        }
        
        __block CGRect animFrame = CGRectMake(frame.origin.x + offsetWithSign, frame.origin.y,frame.size.width, frame.size.height);
        
        [UIView animateWithDuration:interval animations:^{
            self.frame = animFrame;
        } completion:^(BOOL finished) {
            self.frame = frame;
            [self.superview addConstraints:existingConstraints];
            [self.superview layoutIfNeeded];
            
            // Calling handle
            if (_handle) {
                void(^Block)(BOOL finished) = _handle;
                Block(finished);
            }
        }];
    }
}

- (void) animateTransition:(UIViewTransitionAnimation) type WithDuration:(NSTimeInterval) interval nonGeometricAnimationOut:(void(^)(void)) animBlockOut animationIn:(void(^)(void)) animBlockIn completionHandle:(void(^)(BOOL finished)) handle
{
    // storing handle blocks
    __strong id _animBlockOut = animBlockOut;
    __strong id _animBlockIn = animBlockIn;
    __strong id _handle = handle;
    // Save all constraints.
    __block NSArray * viewConstraints = [self allConstraintsInSuperview];
    
    // Save height and width
    CGFloat height = self.viewHeight;
    CGFloat width  = self.viewWidth;
    
    // Remove all constrints
    [self removeAllConstraintsFromSuperview];
    
    // Time division
    NSTimeInterval gapInterval = 0.05;
    NSTimeInterval phaseInterval = (interval - gapInterval)/2;
    
    NSLayoutAttribute attribute1 , attribute2, attribute;
    
    switch (type) {
        case UIViewLeftTransitionAnimation:
        {
            attribute  = NSLayoutAttributeCenterY;
            attribute1 = NSLayoutAttributeRight;
            attribute2 = NSLayoutAttributeLeft;
            break;
        }
        case UIViewRightTransitionAnimation:
        {
            attribute  = NSLayoutAttributeCenterY;
            attribute1 = NSLayoutAttributeLeft;
            attribute2 = NSLayoutAttributeRight;
            break;
        }
        case UIViewTopTransitionAnimation:
        {
            attribute  = NSLayoutAttributeCenterX;
            attribute1 = NSLayoutAttributeTop;
            attribute2 = NSLayoutAttributeBottom;
            break;
        }
        case UIViewBottomTransitionAnimation:
        {
            attribute  = NSLayoutAttributeCenterX;
            attribute1 = NSLayoutAttributeBottom;
            attribute2 = NSLayoutAttributeTop;
            break;
        }
        default:
            break;
    }
    
    void(^AddStaticConstrints)(void) = ^{
        // Height Constraints
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height]];
        
        // Width Constraint
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width]];
        
        // Static Allignment Constriants
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:attribute multiplier:1.0 constant:0.0]];
    };
    
    // Forcing all pending layouts
    [self.superview layoutIfNeeded];
    
    // Adding 1st movement
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:attribute1 relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:attribute1 multiplier:1.0 constant:0.0]];
    AddStaticConstrints();
    
    [UIView animateWithDuration:phaseInterval animations:^{
        @try {
            //1a. Call non geometric out animation
            if (_animBlockOut) {
                void (^Block)(void) = _animBlockOut;
                Block();
            }
            
            //1b. Layouting.
            [self layoutIfNeeded];
        }
        @catch (NSException *exception) {
            // Ignore it.
        }
        
    } completion:^(BOOL finished) {
        // Remove added constraint
        [self removeAllConstraintsFromSuperview];
        //2a. 2nd movement
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:attribute2 relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:attribute2 multiplier:1.0 constant:0.0]];
        AddStaticConstrints();
        // Force layout
        [self.superview layoutIfNeeded];
        
        // Calling third pahse with gap delay
        double delayInSeconds = gapInterval;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Remove old one
            [self removeAllConstraintsFromSuperview];
            //3a. Movement to center again
            [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
            [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
            
            [UIView animateWithDuration:phaseInterval animations:^{
                @try {
                    //3b. Calling In animation
                    if (_animBlockIn) {
                        void(^Block)(void) = _animBlockIn;
                        Block();
                    }
                    
                    //3c. Layouting
                    [self.superview layoutIfNeeded];
                }
                @catch (NSException *exception) {
                    
                }
            } completion:^(BOOL finished) {
                
                //4. Finalize 
                //a. Delete all animate constraints
                [self removeAllConstraintsFromSuperview];
                //b. Restore old Constraints
                [self.superview addConstraints:viewConstraints];
                //c. Layouting
                [self.superview layoutIfNeeded];
                
                // Calling handle.
                if (_handle) {
                    void(^Block)(BOOL finished) = _handle;
                    Block(finished);
                }
            }];
        });
        
    }];
    
}

- (void) frameBasedTransitionFromBottonIn:(BOOL) inAnim withCompletionHandle:(void(^)(BOOL finished))handle
{
    [self layoutIfNeeded];
    [self.layer removeAllAnimations];
    __block __strong id _handle = handle;
    __block NSArray * existingConstraint = [self allConstraintsInSuperview];
    [self removeAllConstraintsFromSuperview];
    
    __block CGRect actualFrame = self.frame;
    CGFloat orgY = self.superview.viewHeight;
    if (!inAnim) {
        orgY = 0.0;
    }
    __block CGRect startFrame =  CGRectMake(self.viewOriginX,orgY,self.viewWidth, self.viewHeight);
    
    orgY = 0.0f;
    if (!inAnim) {
        orgY = self.superview.viewHeight;
    }
    __block CGRect endFrame = CGRectMake(self.viewOriginX,orgY,self.viewWidth, self.viewHeight);
    
    self.frame = startFrame;
    
    [self.superview layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = endFrame;;
    } completion:^(BOOL finished) {
        self.frame = actualFrame;
        [self.superview layoutIfNeeded];
        [self.superview addConstraints:existingConstraint];
        if (_handle) {
            void(^CompletionHandle)(BOOL finished) = _handle;
            CompletionHandle(finished);
        }
    }];
}

@end

@implementation UIView (NibLoad)

+ (UIView *) viewFromNib:(NSString *) nibName bundle:(NSBundle *) bundle owner:(id) owner andIndex:(NSInteger) indx
{
    UINib * nib = [UINib nibWithNibName:nibName bundle:bundle];
    
    NSArray * allObjects = [nib instantiateWithOwner:owner options:nil];
    
    if (allObjects && allObjects.count > 0 && indx < allObjects.count) {
        return allObjects[indx];
    }
    else
        return nil;
}

@end



@implementation UIColor (Extension)

+ (UIColor *) colorWithRGBAInArray:(NSArray *)array
{
    if (array && array.count >= 4) {
        CGFloat rgba[4] = {0.0,0.0,0.0,0.0};
        int i = 0;
        BOOL error = NO;
        for (id num in array) {
            if ([num isKindOfClass:[NSNumber class]]) {
                rgba[i] = [num floatValue];
            }
            else
            {
                error = YES;
                break;
            }
            i++;
        }
        
        if (error) {
            return nil;
        }
        
        return [UIColor colorWithRed:rgba[0] green:rgba[1] blue:rgba[2] alpha:rgba[3]];
    }
    return nil;
}

+ (UIColor *) colorWithIntegerRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue alpha:(CGFloat)alpha
{
    CGFloat r = (CGFloat)((CGFloat)red/255.0);
    CGFloat g = (CGFloat)((CGFloat)green/255.0);
    CGFloat b = (CGFloat)((CGFloat)blue/255.0);
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

+ (UIColor *) colorWithR:(uint8_t)red g:(uint8_t)green b:(uint8_t)blue a:(CGFloat)alpha
{
    return [UIColor colorWithIntegerRed:red green:green blue:blue alpha:alpha];
}

@end


@implementation UIViewController (ApplicationState)

- (void) registerForApplicationStateNotification{
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(applicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    [center addObserver:self selector:@selector(applicationDidEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [center addObserver:self selector:@selector(applicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [center addObserver:self selector:@selector(applicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
}
- (void) unregisterForApplicationStateNotification
{
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [center removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [center removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [center removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}
- (void)applicationWillResignActiveNotification:(NSNotification *) notification{}
- (void)applicationDidEnterBackgroundNotification:(NSNotification *) notification{}
- (void)applicationWillEnterForegroundNotification:(NSNotification *) notification{}
- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification{}

@end

@implementation UIButton (Extension)

- (void) setTitleForAllState:(NSString *) title
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateSelected];
    [self setTitle:title forState:UIControlStateDisabled];
}

@end



@implementation UISlider (Utility)

- (void) setThumbImageForAllState:(UIImage *)image
{
    [self setThumbImage:image forState:UIControlStateNormal];
    [self setThumbImage:image forState:UIControlStateSelected];
    [self setThumbImage:image forState:UIControlStateDisabled];
    [self setThumbImage:image forState:UIControlStateHighlighted];
}

- (void) setTrackImageForAllState:(UIImage *)image
{
    NSArray * array = @[@(UIControlStateNormal),@(UIControlStateSelected),@(UIControlStateHighlighted),@(UIControlStateDisabled)];
    
    for (NSNumber * num in array) {
        UIControlState state = [num unsignedIntegerValue];
        [self setMaximumTrackImage:image forState:state];
        [self setMinimumTrackImage:image forState:state];
    }
}

@end


@implementation UIImage (TextImage)

+ (UIImage *) image:(UIImage *)img withText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color
{
    @autoreleasepool {
        int w = img.size.width;
        int h = img.size.height;
        CGRect rect = CGRectMake(0, 0, w, h);
        
        // Creating context.
        UIGraphicsBeginImageContext(img.size);
        
        // Drawing image.
        [img drawInRect:rect];
        
        UILabel * lable = [[UILabel alloc] initWithFrame:rect];
        // Text value.
        lable.text = text;
        // Alignment
        lable.textAlignment = NSTextAlignmentCenter;
        // Setting font
        if (font && [font isKindOfClass:[UIFont class]]) {
            lable.font = font;
        }
        else
        {
            lable.font = [UIFont fontWithName:@"Helvetica Neue" size:10];
        }
        // Text color
        if (color && [color isKindOfClass:[UIColor class]]) {
            lable.textColor = color;
        }
        else
            lable.textColor = [UIColor whiteColor];
        
        // Drawing text.
        [lable drawTextInRect:rect];
        
        // Getting image from context.
        UIImage * retImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // Ending image context.
        UIGraphicsEndImageContext();
        
        return retImage;
    }
}

@end

@implementation UIView (LayerAnimation)

-(void) addBlinkAnimationWithDuration:(NSTimeInterval) duration
{
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(opacity))];
    alphaAnimation.fromValue = @1.0;
    alphaAnimation.toValue = @0.0;
    alphaAnimation.duration = duration;
    alphaAnimation.autoreverses = YES;
    alphaAnimation.repeatCount = HUGE_VALF;
    [alphaAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [self.layer addAnimation:alphaAnimation forKey:NSStringFromSelector(@selector(opacity))];
}

@end


@implementation UIImage (BlurImage)

+ (UIImage *) blurImageForImage:(UIImage *)theImage
{
    @autoreleasepool {
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
        
        // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        [filter setValue:[NSNumber numberWithFloat:4.0f] forKey:@"inputRadius"];
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        
        // CIGaussianBlur has a tendency to shrink the image a little,
        // this ensures it matches up exactly to the bounds of our original image
        CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
        
        UIImage *returnImage = [UIImage imageWithCGImage:cgImage];//create a UIImage for this function to "return" so that ARC can manage the memory of the blur... ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
        CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
        
        return returnImage;
    }
}

- (UIImage *) blurImage
{
    return [UIImage blurImageForImage:self];
}

@end


@implementation UIView (Images)

- (UIImage *) screenShot
{
    // Creating view image with context.
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    [self.layer renderInContext:context];
    UIImage * viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

- (UIImage *) blurImageOfView
{
    if (self.frame.size.width > 0 && self.frame.size.height > 0) {
        // Creating View image
        UIImage * viewImage = [self screenShot];
        
        // Returing blur image.
        return [viewImage blurImage];
    }
    else
        return nil;
}

- (void) getBlurImage:(void(^)(UIImage * blurImg))callback
{
    __block id _cb = callback;
    __block UIImage * viewImage = [self screenShot];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage * blurImage = [viewImage blurImage];
        void(^CB)(UIImage * img) = _cb;
        CB(blurImage);
    });
}

@end

@implementation UIView (Customization)

- (void) addDashBorderWithColor:(UIColor *) color
{
    // Creating dash rect shape layer
    CAShapeLayer * shape = [CAShapeLayer layer];
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:self.bounds];
    shape.path = [path CGPath];
    [shape setStrokeColor:[color CGColor]];
    [shape setFillColor:[[UIColor clearColor] CGColor]];
    [shape setLineWidth:1.0];
    [shape setLineDashPattern:@[@6,@2]];
    [shape setLineDashPhase:0.0];
    [shape setStrokeStart:0.0];
    [shape setStrokeEnd:1.0];
    
    // Adding to self layer
    [self.layer insertSublayer:shape atIndex:0];
    
}

- (void) addDashBorderWithColor:(UIColor *)color width:(CGFloat) width dashPattern:(NSArray *) pattern onTop:(BOOL) onTop
{
    // Setting dash pattern
    NSArray * pattn = pattern;
    if (pattn == nil) {
        // Default
        pattn = @[@6,@2];
    }
    
    // Setting line width 
    // Default
    CGFloat lineWidth  = 1.0f;
    if (width > 0) {
        lineWidth = width;
    }
    
    // Creating dash rect shape layer
    CAShapeLayer * shape = [CAShapeLayer layer];
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:self.bounds];
    shape.path = [path CGPath];
    [shape setStrokeColor:[color CGColor]];
    [shape setFillColor:[[UIColor clearColor] CGColor]];
    [shape setLineWidth:lineWidth];
    [shape setLineDashPattern:pattn];
    [shape setLineDashPhase:0.0];
    [shape setStrokeStart:0.0];
    [shape setStrokeEnd:1.0];
    
    // Adding to self layer
    if (onTop) {
        [self.layer addSublayer:shape];
    }
    else
        [self.layer insertSublayer:shape atIndex:0];
}
@end

@implementation NSObject (RemoteTask)
static NSString * activeTask = @"activeTask";
@dynamic remoteSessionTask;
- (void) setRemoteSessionTask:(NSURLSessionTask *)remoteTask {
    @try {
        objc_setAssociatedObject(self, &activeTask, remoteTask, OBJC_ASSOCIATION_ASSIGN);
    }
    @catch (NSException *exception) {
        NSLog(@"Exception:x1 %@: %@", NSStringFromClass([self class]), exception);
    }
}

- (NSURLSessionTask *) remoteSessionTask {
    @try {
        id obj = objc_getAssociatedObject(self, &activeTask);
        return obj;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception:x1 %@: %@", NSStringFromClass([self class]), exception);
        return nil;
    }
}
@end
