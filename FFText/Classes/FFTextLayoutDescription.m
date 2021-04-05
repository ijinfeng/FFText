//
//  FFTextLayoutDescription.m
//  FFText-oc
//
//  Created by jinfeng on 2021/3/19.
//

#import "FFTextLayoutDescription.h"

@implementation FFTextLayoutDescription

- (CGMutablePathRef)createRenderPathIgnoreExclusionPaths:(BOOL)ignore {
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, CGRectMake(_insets.left, _insets.bottom, _size.width - _insets.left - _insets.right, _size.height - _insets.top - _insets.bottom));
    if (ignore) {
        return pathRef;
    }
    for (UIBezierPath *exclusionPath in _exclusionPaths) {
        UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:exclusionPath.CGPath];
        [path applyTransform:CGAffineTransformMakeTranslation(0, _size.height - path.bounds.size.height - path.currentPoint.y * 2)];
        CGPathAddPath(pathRef, NULL, path.CGPath);
    }
    return pathRef;
}

@end
