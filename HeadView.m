//
//  HeadView.m
//  Test04
//
//  Created by HuHongbing on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView
@synthesize delegate = _delegate;
@synthesize section,open,titleLabel,arrowUIImageView,lineUIImageView,contentUIView,contentUIViewHeight;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        open = NO;
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 340, 45.5);
        [btn addTarget:self action:@selector(doSelected) forControlEvents:UIControlEventTouchUpInside];
        titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 340, 45.5)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:18]];
        titleLabel.textColor=[UIColor blackColor];
        UIImageView *arrow=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowdown"]];
        [arrow setFrame:CGRectMake(280, (btn.frame.size.height- arrow.image.size.height)/2+1, arrow.image.size.width, arrow.image.size.height)];
        arrowUIImageView=arrow;
        lineUIImageView =[self getUIImageView:CGRectMake(10,btn.frame.size.height-5, 290, 2.5)];
        [self addSubview:lineUIImageView];
        
         [self addSubview:arrow];
        [self addSubview:titleLabel];
        [self addSubview:btn];
    //    self.backBtn = btn;

    }
    return self;
}
-(void)setOpenUIImageView:(BOOL) isOpen{
    if(!isOpen){
        arrowUIImageView.image= [UIImage imageNamed:@"arrowdown"];
    }else{
        arrowUIImageView.image= [UIImage imageNamed:@"arrowup"];
    }
}

-(UIImageView *) getUIImageView:(CGRect)rect{
    UIImageView *iView =[[UIImageView alloc]initWithFrame:rect];
    //    UIImage * xuxianbg= [UIImage imageNamed:@"xuxian"];
    //    //平铺
    //    iView.backgroundColor=[UIColor colorWithPatternImage:xuxianbg];
    UIImage *xuxianbg= [[UIImage imageNamed:@"line"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    [iView setImage:xuxianbg];
    return iView;
}
-(void)doSelected{
    //    [self setImage];
    if (_delegate && [_delegate respondsToSelector:@selector(selectedWith:)]){
     	[_delegate selectedWith:self];
    }
}
@end
