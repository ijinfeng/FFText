//
//  FFTextAttachment.h
//  FFText-oc
//
//  Created by jinfeng on 2021/3/22.
//

#import "FFRunDelegate.h"
#import <UIKit/UIKit.h>
#import "FFTextAttribute.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FFTextAttachmentType) {
    FFTextAttachmentImage,
    FFTextAttachmentCustomView,
};

@interface FFTextAttachment : FFRunDelegate

@property (nonatomic, strong) id content;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic) CGSize size;

@property (nonatomic) UIEdgeInsets insets;

@property (nonatomic) NSUInteger insertLocation;

@property (nonatomic) FFVerticalTextAlignment verticalTextAlignment;

- (NSAttributedString *)createTextAttachmentString;

- (FFTextAttachmentType)attachmentType;

@property (nonatomic, assign) CGPoint drawOrigin;

@end

NS_ASSUME_NONNULL_END
