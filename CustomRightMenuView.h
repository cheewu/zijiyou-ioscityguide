//
//  CustomRightMenuView.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-31.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RightMenuButton.h"
@protocol CustomRightMenuClickProtocal <NSObject>
@required
- (void)callbackClick:(id)sender;
@end

@interface CustomRightMenuView : UIView
{
    
}
@property(nonatomic,retain)UIView *mainView;
@property (nonatomic, retain) id<CustomRightMenuClickProtocal> delegate;
@property(nonatomic,retain) NSMutableArray *categoryArrayArray;
@property(nonatomic,retain) NSMutableDictionary *buttonDirects;

//@property(nonatomic,retain)NSMutableArray *listImageArray;
- (id)initWithFrame:(CGRect)frame nameArray:(NSArray *)listArray imageArray:(NSArray *)listImageArray categoryArray:(NSArray *)categoryArray;
- (id)initWithFrame:(CGRect)frame;
- (void)saixuanClick:(id)sender ;
-(void) setActionButton:(UIButton *)button;
-(void)selectMenu:(id)sender;
+(NSMutableDictionary*) getAllTypes;
-(void)allSelectButtonISselect:(BOOL)select;
@end
