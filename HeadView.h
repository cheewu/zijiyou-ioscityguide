//
//  HeadView.h
//  Test04
//
//  Created by HuHongbing on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HeadViewDelegate; 

@interface HeadView : UIView{
    id<HeadViewDelegate> _delegate;//代理
    NSInteger section;
   // UIButton* backBtn;
    BOOL open;
}
@property(nonatomic, retain) id<HeadViewDelegate> delegate;
@property(nonatomic, assign) NSInteger section;
@property(nonatomic, assign) BOOL open;
//@property(nonatomic, retain) UIButton* backBtn;
@property(nonatomic, retain) UILabel *titleLabel;
@property(nonatomic, retain) UIImageView *arrowUIImageView;
//@property(nonatomic, retain) NSString *contentString;
@property(nonatomic, retain) UIImageView *lineUIImageView;
@property(nonatomic, retain) UIView *contentUIView;
@property(nonatomic, assign) int contentUIViewHeight;
-(void)setOpenUIImageView:(BOOL) isOpen;
@end

@protocol HeadViewDelegate <NSObject>
-(void)selectedWith:(HeadView *)view;

@end
