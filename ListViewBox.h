//
//  ListViewBox.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-24.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewBox : UIView<UIGestureRecognizerDelegate>{
    UIImageView* _userImageView;
	UILabel* _displayTextLabel;
}
typedef void (^JMWhenTappedBlock)();
@property (nonatomic,retain) UIImageView* userImageView;
@property (nonatomic,retain) UILabel* displayTextLabel;
@property (nonatomic,retain) NSString *lineId;
@property (nonatomic ,retain) NSDictionary *poiData;
- (id)initWithFrame:(CGRect)frame imgURL:(NSString *)imgurl textColor:(NSString *)textColor text:(NSString *)text;
- (id)initWithFrame:(CGRect)frame imgURL:(NSString *)imgurl textColor:(NSString *)textColor text:(NSString *)text stationText:(NSString *)stationText leftImage:(NSString *)image;
- (void)whenTouchedUp:(JMWhenTappedBlock)block;
- (id)initWithFrame:(CGRect)frame imgURL:(NSString *)imgurl textColor:(NSString *)textColor text:(NSString *)text stationText:(NSString *)stationText leftImage:(NSString *)image sandetName:(NSString *)sandetName;
@end
