//
//  DetailButtonUIView.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-9-13.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailButtonUIView : UIView{
    //UIButton *button;
    UIImageView *image;
    UILabel *label;
}
- (id)initWithFrame:(CGRect)frame imageName:(NSString *)imageName text:(NSString *)text;
@property (nonatomic,retain)UIButton *button;
@end
