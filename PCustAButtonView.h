//
//  PCustAButtonView.h
//  zijiyoun
//
//  Created by piaochunzhi on 12-9-18.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCustAButtonView : UIView
- (id)initWithFrame:(CGRect)frame imageName:(NSString *)image text:(NSString *)text;
-(void) isSelect:(BOOL)select;
@property(nonatomic,retain)UIButton *button;
@end
