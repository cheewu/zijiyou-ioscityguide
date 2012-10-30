//
//  PCTOPUIview.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-29.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCTOPUIview : UIView
- (id)initWithFrame:(CGRect)frame title:(NSString *)title backTitle:(NSString *)backTitle righTitle:(NSString *)righTitle;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) UIButton *rightButton;
@end
