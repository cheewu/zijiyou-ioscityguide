//
//  PayMapViewController.m
//  自己游
//
//  Created by piaochunzhi on 12-10-16.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//


#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"
#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseProUpgradeProductId @"HKOFFLINECN"

#import "InAppPurchaseManager.h"
#import "MapDownViewController.h"
#import "PayMapViewController.h"

@interface PayMapViewController ()

@end

@implementation PayMapViewController
@synthesize backpoimongoid;
@synthesize backID;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super viewDidLoad];
    UIImage * tabelbg= [UIImage imageNamed:@"tabelbag"];
    
    //平铺
    self.view.backgroundColor=[UIColor colorWithPatternImage:tabelbg];
    
    PCTOPUIview *pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:@"香港离线数据购买" backTitle:@"" righTitle:nil];
    [pctop.button addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    //HomeIndex
    [self.view addSubview: pctop];
    
    UIImage *mapicon=[UIImage imageNamed:@"mapicon"];
    UIImageView *mapiocnView=[[UIImageView alloc] initWithImage:mapicon];
    [mapiocnView setFrame:CGRectMake(16, 60, mapicon.size.width, mapicon.size.height)];
    buyButton=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buyImg=[UIImage imageNamed:@"buymapnor"];
    [buyButton setImage:buyImg forState:UIControlStateNormal];
    [buyButton setImage:[UIImage imageNamed:@"buymapdown"] forState:UIControlStateHighlighted];
    [buyButton setShowsTouchWhenHighlighted:YES];
    [buyButton setFrame:CGRectMake(230, 100, buyImg.size.width, buyImg.size.height)];
    UITextView *despOffMap=[[UITextView alloc]initWithFrame:CGRectMake(15, 130, 300, 100)];
    [despOffMap setEditable:NO];
    [despOffMap setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [despOffMap setBackgroundColor:[UIColor clearColor]];
    [despOffMap setText:@"离线地图和地铁换乘查询功能需要付费购买，价格25元。付费完成以后会自动下载离线数据包共22.5M，根据不同的网络状况下载需要3到5分钟。"];
    [despOffMap setTextColor:RGBACOLOR(90, 86, 67, 1)];
    [buyButton addTarget:self action:@selector(buyMapData) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *title =[[UILabel alloc] initWithFrame:CGRectMake(90, 55, 200, 40)];
    [title setText:@"香港离线数据购买"];
    UILabel *jiage =[[UILabel alloc] initWithFrame:CGRectMake(90, 88, 100, 25)];
    [jiage setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [jiage setText:@"价格： "];
    UILabel *price =[[UILabel alloc] initWithFrame:CGRectMake(140, 88, 100, 25)];
    [price setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    price.textColor=RGBACOLOR(227, 74, 8, 1);
    [price setText:@"25元"];
    [title setBackgroundColor:[UIColor clearColor]];
    [jiage setBackgroundColor:[UIColor clearColor]];
    [price setBackgroundColor:[UIColor clearColor]];
    
    UIImage *mapDesImage1=[UIImage imageNamed:@"buymapimage1"];
    UIImageView *mapDesImageView1=[[UIImageView alloc] initWithImage:mapDesImage1];
    [mapDesImageView1 setFrame:CGRectMake(20, 230, mapDesImage1.size.width, mapDesImage1.size.height)];

    UIImage *mapDesImage2=[UIImage imageNamed:@"buymapimage2"];
    UIImageView *mapDesImageView2=[[UIImageView alloc] initWithImage:mapDesImage2];
    [mapDesImageView2 setFrame:CGRectMake(140, 230, mapDesImage2.size.width, mapDesImage2.size.height)];
    
    mapDesImageView1.layer.borderWidth  = 3;
    mapDesImageView1.layer.borderColor= [[UIColor whiteColor] CGColor];
    mapDesImageView2.layer.borderWidth  = 3;
    mapDesImageView2.layer.borderColor= [[UIColor whiteColor] CGColor];
  
    mapDesImageView1.layer.shadowColor = [UIColor blackColor].CGColor;
    mapDesImageView1.layer.shadowOffset = CGSizeMake(1, 1);
    mapDesImageView1.layer.shadowOpacity = 0.25;
    mapDesImageView1.layer.shadowRadius = 3.0;
    
    mapDesImageView2.layer.shadowColor = [UIColor blackColor].CGColor;
    mapDesImageView2.layer.shadowOffset = CGSizeMake(3, 3);
    mapDesImageView2.layer.shadowOpacity = 0.25;
    mapDesImageView2.layer.shadowRadius = 3.0;
    
    mapDesImageView2.layer.cornerRadius = 3.0;
    mapDesImageView1.layer.cornerRadius = 3.0;
    mapDesImageView2.layer.masksToBounds = YES;
    mapDesImageView1.layer.masksToBounds = YES;
    
    [self.view addSubview:mapDesImageView1];
    [self.view addSubview:mapDesImageView2];
    [self.view addSubview:mapiocnView];
    [self.view addSubview:title];
    [self.view addSubview:jiage];
    [self.view addSubview:price];
    [self.view addSubview:buyButton];
    [self.view addSubview:despOffMap];
}
-(void)buyMapData{
    [buyButton setEnabled:NO];
    if([self canMakePurchases]){
        [self loadStore];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//获得商店信息
- (void)requestProUpgradeProductData
{
    [ViewController showWaiting:self.view];
    NSSet *productIdentifiers = [NSSet setWithObject:kInAppPurchaseProUpgradeProductId];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    [productsRequest setDelegate:self];
    [productsRequest start];
}


#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    proUpgradeProduct = [products count] == 1 ? [products objectAtIndex:0] : nil;
    if (proUpgradeProduct)
    {
        NSLog(@"Product title: %@" , proUpgradeProduct.localizedTitle);
        NSLog(@"Product description: %@" , proUpgradeProduct.localizedDescription);
        NSLog(@"Product price: %@" , proUpgradeProduct.price);
        NSLog(@"Product id: %@" , proUpgradeProduct.productIdentifier);
    }
    //
    //    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    //    {
    //        NSLog(@"Invalid product id: %@" , invalidProductId);
    //    }
    [self purchaseProUpgrade];
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"erro%@",[error debugDescription]);
    [ViewController hideWaiting:self.view];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                       message:@"购买失败！"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
    [alertView show];
}
//
// call this method once on startup
//
- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestProUpgradeProductData];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)purchaseProUpgrade
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:kInAppPurchaseProUpgradeProductId];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseProUpgradeProductId])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
    if ([productId isEqualToString:kInAppPurchaseProUpgradeProductId])
    {
        // enable the pro features
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isProUpgradePurchased" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)clickBack{
    
     [self dismissModalViewControllerAnimated:YES];
    if([backID isEqualToString:@"MapBoxViewController"]){
        RXCustomTabBar *rb =(RXCustomTabBar *)[self presentingViewController];
        [rb setSelectedIndex:1];//地图
        [rb.btn1 setSelected:NO];
        [rb.btn2 setSelected:YES];
    }
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
    [ViewController hideWaiting:self.view];
    
    
    UIStoryboard *sb = [ViewController getStoryboard];
    MapDownViewController *rb = [sb instantiateViewControllerWithIdentifier:@"MapDown"];
    rb.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
    if([backID isEqualToString:@"MapBoxViewController"]){
         rb.backIdentifier = @"MapBoxViewController";
    }else{
        rb.backIdentifier = @"PayMapViewController";
    }
    [rb setBackpoimongoid:[self backpoimongoid]];
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];
}

//
// called when a transaction has been restored and and successfully completed 如果购买成功
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
        [ViewController hideWaiting:self.view];
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:@"购买失败！"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    [ViewController hideWaiting:self.view];
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://购买成功
                NSLog(@"购买成功");
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://购买失败
                NSLog(@"购买失败");
                [self failedTransaction:transaction];
                [buyButton setEnabled:YES];
                break;
            case SKPaymentTransactionStateRestored://恢复商品
                NSLog(@"恢复商品");
                [self restoreTransaction:transaction];
                [buyButton setEnabled:YES];
                break;
            case SKPaymentTransactionStatePurchasing://购买中
                NSLog(@"购买中");
                [ViewController showWaiting:self.view];
                //[self setDepView:self.view];
                break;
            default:
                break;
        }
    }
}
@end
