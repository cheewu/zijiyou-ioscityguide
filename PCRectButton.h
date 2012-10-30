//
//  PCRectButton.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-29.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCRectButton : UIView
@property (nonatomic, retain) UIButton *button;
- (id)initWithFrame:(CGRect)frame text:(NSString *)text;
@end
