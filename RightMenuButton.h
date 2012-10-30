//
//  RightMenuButton.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-9-2.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightMenuButton : UIButton
{
    UILabel * tile;
    UIImageView *imview;
    UIImage *listi;
    UIImageView *listSelectImage;
}
@property(nonatomic,retain)UIImageView *listSelectImage;
@property (nonatomic,retain) NSString *buttonName;
@property (nonatomic,retain) NSString *categoryName;
-(void)setWithFrame:(CGRect)frame listImageName:(NSString *)imageName listName:(NSString *)name;
-(void) titleIsUnableSelect;
-(void) isButtonSelect:(BOOL)select;

@end
