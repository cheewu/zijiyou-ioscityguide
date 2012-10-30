//
//  InAppPurchaseManager.h
//  自己游
//
//  Created by piaochunzhi on 12-10-2.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/SKProduct.h>
#import <StoreKit/StoreKit.h> 

@interface InAppPurchaseManager : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
}
@property (nonatomic ,retain) UIView *depView;

- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseProUpgrade;
@end
