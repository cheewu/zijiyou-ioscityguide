//
//  SubWayDrawViewController.h
//  zijiyou-ioscityguide
//
//  Created by piaochunzhi on 12-12-31.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubWayDrawViewController : UIViewController{
    
}
@property (nonatomic, retain) NSString *lineid;
@property (nonatomic, retain) NSMutableDictionary *lineDictionary;
@property (retain, nonatomic)  UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableDictionary *idSubDirs;//所有地铁数据
@end
