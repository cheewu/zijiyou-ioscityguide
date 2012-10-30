//
//  StationView.h
//  自己游
//
//  Created by piaochunzhi on 12-9-25.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationView : UIView
{
    UIImageView* _userImageView;
	UILabel* _displayTextLabel;
}
@property (nonatomic ,retain) NSDictionary *poiData;
@property (nonatomic ,retain)  NSArray *poiStations;
- (id)initWithFrame:(CGRect)frame transferStations:(NSArray *)stations poiData:(NSDictionary *)poiData;
@end
