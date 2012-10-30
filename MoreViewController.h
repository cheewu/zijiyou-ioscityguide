//
//  MoreViewController.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-9-9.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h> 
@interface MoreViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate>
{
    NSArray *objValue;
}
@property(nonatomic,retain) PCTOPUIview * pctop;
@property (strong, nonatomic) IBOutlet UITableView *mtabelView;
@end
