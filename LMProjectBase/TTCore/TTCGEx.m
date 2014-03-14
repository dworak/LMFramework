//
//  CGPointEx.m
//  TT
//
//  Created by Andrzej Auchimowicz on 24/11/2011.
//  Copyright (c) 2011 Transition Technologies S.A. All rights reserved.
//

#import "TTCGEx.h"

CGFloat
CGDegreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180.;
}

CGFloat
CGClamp(CGFloat value, CGFloat min, CGFloat max)
{
    assert(min <= max);
    return MIN(MAX(value, min), max);
}

CGPoint
CGPointTranslate(CGPoint point, CGFloat tx, CGFloat ty)
{
    return CGPointMake(point.x + tx, point.y + ty);
}

CGFloat
CGPointDistance(CGPoint a, CGPoint b)
{
    return sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y));
}

CGFloat
CGPointDot(CGPoint a, CGPoint b)
{
    return a.x * b.x + a.y * b.y;
}

CGPoint
CGPointFloor(CGPoint point)
{
    return CGPointMake(floor(point.x), floor(point.y));
}

CGPoint
CGPointNormalize(CGPoint point, CGSize size)
{
    return CGPointMake(point.x / size.width, point.y / size.height);
}

CGPoint
CGPointInverse(CGPoint point)
{
    return CGPointMake(- point.x, - point.y);
}

CGPoint
CGRectComputeCenter(CGRect rect)
{
    CGPoint center = CGPointZero;
    center.x = rect.origin.x + rect.size.width / 2.;
    center.y = rect.origin.y + rect.size.height / 2.;
    return center;
}

CGPoint
CGRectComputeLeftTopCorner(CGRect rect)
{
    return rect.origin;
}

CGPoint
CGRectComputeRightBottomCorner(CGRect rect)
{
    return CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
}

CGRect
CGRectFitToAspectRatio(CGRect rect, CGFloat aspectRatio)
{
    // aspectRatio = width / height
    // height = width / aspectRatio
    // width = height * aspectRatio
    
    CGRect result = rect;
    
    CGFloat inputAspectRatio = rect.size.width / rect.size.height;
    
    if (fabs(inputAspectRatio - aspectRatio) < 0.01)
    {
        return result;
    }
    
    if (inputAspectRatio < aspectRatio)
    {
        result.size.height = rect.size.width / aspectRatio;
        result.origin.y = (rect.size.height - result.size.height) / 2;
        result.origin.y += rect.origin.y;
    }
    else
    {
        result.size.width = rect.size.height * aspectRatio;
        result.origin.x = (rect.size.width - result.size.width) / 2;
        result.origin.x += rect.origin.x;
    }

    return result;
}

CGRect
CGRectFillToAspectRatio(CGRect rect, CGFloat aspectRatio)
{
    CGRect result = rect;
    
    CGFloat inputAspectRatio = rect.size.width / rect.size.height;
    
    if (fabs(inputAspectRatio - aspectRatio) < 0.01)
    {
        return result;
    }
    
    if (inputAspectRatio > aspectRatio)
    {
        result.size.height = rect.size.width / aspectRatio;
        result.origin.y = (rect.size.height - result.size.height) / 2;
        result.origin.y += rect.origin.y;
    }
    else
    {
        result.size.width = rect.size.height * aspectRatio;
        result.origin.x = (rect.size.width - result.size.width) / 2;
        result.origin.x += rect.origin.x;
    }
    
    return result;
}

CGRect
CGRectMakeFromTwoCorners(CGPoint pointA, CGPoint pointB)
{
    return CGRectMake(MIN(pointA.x, pointB.x), MIN(pointA.y, pointB.y), fabs(pointA.x - pointB.x), fabs(pointA.y - pointB.y));
}

CGRect
CGRectMakeWithCenter(CGFloat centerX, CGFloat centerY, CGFloat width, CGFloat height)
{
    return CGRectMake(centerX - width / 2, centerY - height / 2, width, height);
}

CGRect
CGRectScaleUniformlyFromCenter(CGRect rect, CGFloat scale)
{
    return CGRectScaleFromCenter(rect, CGPointMake(scale, scale));
}

CGRect
CGRectScaleFromCenter(CGRect rect, CGPoint scale)
{
    CGPoint center = CGRectComputeCenter(rect);
    
    CGSize size = rect.size;
    size.width *= scale.x;
    size.height *= scale.y;
    
    CGRect result = CGRectZero;
    result.size = size;
    
    size.width /= 2;
    size.height /= 2;
    
    result.origin.x = center.x - size.width;
    result.origin.y = center.y - size.height;
    
    return result;
}

CGRect
CGRectFlip(CGRect rect)
{
    CGFloat tmp = rect.origin.x;
    rect.origin.x = rect.origin.y;
    rect.origin.y = tmp;
    
    tmp = rect.size.width;
    rect.size.width = rect.size.height;
    rect.size.height = tmp;
    
    return rect;
}

CGRect
CGRectRound(CGRect rect)
{
    rect.origin.x = roundl(rect.origin.x);
    rect.origin.y = roundl(rect.origin.y);
    rect.size.width = roundl(rect.size.width);
    rect.size.height = roundl(rect.size.height);
    return rect;
}

CGRect
CGRectSum(CGRect rectA, CGRect rectB)
{
    CGPoint pA0 = CGRectComputeLeftTopCorner(rectA);
    CGPoint pA1 = CGRectComputeRightBottomCorner(rectA);
    
    CGPoint pB0 = CGRectComputeLeftTopCorner(rectB);
    CGPoint pB1 = CGRectComputeRightBottomCorner(rectB);
    
    CGPoint p0, p1;
    
    p0.x = MIN(pA0.x, pB0.x);
    p0.y = MIN(pA0.y, pB0.y);
    
    p1.x = MAX(pA1.x, pB1.x);
    p1.y = MAX(pA1.y, pB1.y);
    
    return CGRectMake(p0.x, p0.y, p1.x - p0.x, p1.y - p1.y);
}

CGFloat
CGSizeAspectRatio(CGSize size)
{
    return size.width / size.height;
}

CGSize
CGSizeExpandToPowerOfTwo(CGSize size)
{
    //AA: This implementation is far from most optimal but with expected range of sizes it should suffice. Passing ridiculously high values (such as +Inf) will trigger assert...
    assert(size.width > 0 && size.height > 0);
    assert(size.width < 3000 && size.height < 3000);
    
    CGSize result = CGSizeMake(2, 2);
    
    while (result.width < size.width || result.height < size.height)
    {
        if (result.width < size.width)
        {
            result.width *= 2;
        }
        
        if (result.height < size.height)
        {
            result.height *= 2;
        }
    }
    
    return result;
}

// (1 - t) ^ 3 * P0 + 3 * (1 - t) ^ 2 * t * P1 + 3 * (1 - t) * t ^ 2 * P2 + t ^ 3 * P3

CGFloat
CGComputeCoordOnBezierCubicCurve(CGFloat a, CGFloat b, CGFloat c, CGFloat d, CGFloat step)
{
    return pow(1 - step, 3) * a + 3 * pow(1 - step, 2) * step * b + 3 * (1 - step) * pow(step, 2) * c + pow(step, 3) * d;
}

CGPoint
CGComputePointOnBezierCubicCurve(CGPoint a, CGPoint b, CGPoint c, CGPoint d, CGFloat step)
{
    CGPoint result;
    result.x = CGComputeCoordOnBezierCubicCurve(a.x, b.x, c.x, d.x, step);
    result.y = CGComputeCoordOnBezierCubicCurve(a.y, b.y, c.y, d.y, step);
    return result;
}

BOOL
CGImageToRgba8(UInt8* outputBuffer, Size outputBufferSize, NSUInteger outputBufferWidth, CGImageRef image)
{
    NSUInteger width = CGImageGetWidth(image);
    NSUInteger height = CGImageGetHeight(image);
    
    if (outputBufferSize < width * height * 4)
    {
        assert(NO);
        return NO;
    }
    
    // Zeroing memory must be done or artefacts will occur on images that have transparent parts!
    memset(outputBuffer, 0xFFFFFF00, outputBufferSize);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * outputBufferWidth;
    NSUInteger bitsPerComponent = 8;
    
    CGContextRef context = CGBitmapContextCreate(outputBuffer, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease(colorSpace);
    
    CGContextSetAllowsAntialiasing(context, NO);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    CGContextRelease(context);
    
    return YES;
}

CGFloat
Rgba8luminance(UInt32 rgba8)
{
    CGFloat r = (rgba8 << 24) >> 24;
    CGFloat g = (rgba8 << 16) >> 24;
    CGFloat b = (rgba8 << 8) >> 24;
    
    CGFloat l = r * 0.3 + g * 0.6 + b * 0.1;
    l /= 255;
    return l;
}
