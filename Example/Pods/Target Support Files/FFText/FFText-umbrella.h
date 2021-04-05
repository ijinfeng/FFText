#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FFLabel.h"
#import "FFLine.h"
#import "FFRunDelegate.h"
#import "FFText.h"
#import "FFTextAttachment.h"
#import "FFTextAttribute.h"
#import "FFTextAttributeDelegate.h"
#import "FFTextDetector.h"
#import "FFTextLayoutDescription.h"
#import "FFTextRender.h"
#import "FFWeakProxy.h"
#import "NSAttributedString+FFText.h"

FOUNDATION_EXPORT double FFTextVersionNumber;
FOUNDATION_EXPORT const unsigned char FFTextVersionString[];

