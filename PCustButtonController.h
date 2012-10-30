//
//  PCustButton.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-21.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCustButtonController : UIView

@property (nonatomic, retain) UIButton *button;
@property (nonatomic,retain) UIImage *type;
@property (nonatomic,retain) UILabel *text;
@property (nonatomic,retain) NSString *typeString;

- (id)initWithFrame:(CGRect)frame typeImageName:(NSString *)typeName textString:(NSString *)textString;
-(void)addCustomElements;

@end
