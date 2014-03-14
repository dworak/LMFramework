//
//  CGPointEx.h
//  TT
//
//  Created by Andrzej Auchimowicz on 24/11/2011.
//  Copyright (c) 2011 Transition Technologies S.A. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

struct CGRect;

CGFloat
CGDegreesToRadians(CGFloat degrees);

CGFloat
CGClamp(CGFloat value, CGFloat min, CGFloat max);

CGPoint
CGPointTranslate(CGPoint point, CGFloat tx, CGFloat ty);

CGFloat
CGPointDistance(CGPoint a, CGPoint b);

CGFloat
CGPointDot(CGPoint a, CGPoint b);

CGPoint
CGPointFloor(CGPoint point);

CGPoint
CGPointNormalize(CGPoint point, CGSize size);

CGPoint
CGPointInverse(CGPoint point);

CGPoint
CGRectComputeCenter(CGRect rect);

CGPoint
CGRectComputeLeftTopCorner(CGRect rect);

CGPoint
CGRectComputeRightBottomCorner(CGRect rect);

CGRect
CGRectFitToAspectRatio(CGRect rect, CGFloat aspectRatio);

CGRect
CGRectFillToAspectRatio(CGRect rect, CGFloat aspectRatio);

CGRect
CGRectMakeFromTwoCorners(CGPoint pointA, CGPoint pointB);

CGRect
CGRectMakeWithCenter(CGFloat centerX, CGFloat centerY, CGFloat width, CGFloat height);

CGRect
CGRectScaleUniformlyFromCenter(CGRect rect, CGFloat scale);

CGRect
CGRectScaleFromCenter(CGRect rect, CGPoint scale);

/**
    Swap x with y and width with height.
*/

CGRect
CGRectFlip(CGRect rect);

CGRect
CGRectRound(CGRect rect);

CGRect
CGRectSum(CGRect rectA, CGRect rectB);

CGFloat
CGSizeAspectRatio(CGSize size);

CGSize
CGSizeExpandToPowerOfTwo(CGSize size);

CGFloat
CGComputeCoordOnBezierCubicCurve(CGFloat a, CGFloat b, CGFloat c, CGFloat d, CGFloat step);

CGPoint
CGComputePointOnBezierCubicCurve(CGPoint a, CGPoint b, CGPoint c, CGPoint d, CGFloat step);

BOOL
CGImageToRgba8(UInt8* outputBuffer, Size outputBufferSize, NSUInteger outputBufferWidth, CGImageRef image);

CGFloat
Rgba8luminance(UInt32 rgba8);
