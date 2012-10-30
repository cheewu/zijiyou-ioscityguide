//
//  PListUITabelView.h
//  zijiyoun
//
//  Created by piaochunzhi on 12-9-19.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"
#import "MyAccountViewController.h"
typedef enum {
    CheckInType= 0,
    FavouriteType = 1,
}PListUITabelViewType;

@interface PListUITabelView : UITableView<UITableViewDelegate, UITableViewDataSource,WBSendViewDelegate>{
    NSMutableDictionary *poiData;
    UIButton *synButton;
    WBSendView *sendView;
}
@property (nonatomic, retain) NSMutableDictionary *checkinEntries;
@property (nonatomic, retain) NSMutableArray* entries;
//@property (nonatomic, retain) WBEngine *weiBoEngine;
@property (nonatomic, assign)PListUITabelViewType *ptype;
@property(nonatomic,retain) MyAccountViewController *myAccountViewController;
- (id)initWithFrame:(CGRect)frame entries:(NSMutableArray*) entrie;
@end
