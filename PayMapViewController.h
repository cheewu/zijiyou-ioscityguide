//
//  PayMapViewController.h
//  自己游
//
//  Created by piaochunzhi on 12-10-16.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayMapViewController : UIViewController<SKProductsRequestDelegate,SKPaymentTransactionObserver>

{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
    UIButton *buyButton;
}
@property (nonatomic ,retain) NSString *backpoimongoid;
@property (nonatomic ,retain) NSString *backID;
- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseProUpgrade;
@end