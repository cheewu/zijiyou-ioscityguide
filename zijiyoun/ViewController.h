//
//  ViewController.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-18.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define downMapFileName @"Library/User/osm.mbtiles"

#import <UIKit/UIKit.h>
#import "PCustButtonController.h"
#import "HotPoiHomeViewController.h"
#import "FMDatabase.h"
#import "NSDataDES.h"

@interface ViewController : UIViewController
{
    PCustButtonController *pcb1;
    PCustButtonController *pcb2;
    PCustButtonController *pcb3;
    PCustButtonController *pcb4;
    UIView *homeView;
    CLLocationManager *locationManager;
}
@property (strong, nonatomic) IBOutlet UIView *homeView;
//@property (nonatomic, retain) NSMutableArray* entries;//所有数据
- (IBAction)btnPressHide:(id)sender;
- (IBAction)btnPressShow:(id)sender;
+(FMDatabase *)getDataBase;
+(FMDatabase *)getUserDataBase;
+(FMResultSet *)getDataBase:(NSString *)sql db:(FMDatabase *)db;
+(UIStoryboard *) getStoryboard;
+(void)setPoiArray:(FMResultSet *)resultSet isNeedDist:(bool)isNeedDist coord:(CLLocationCoordinate2D) clocation setEntries:(NSMutableArray *)entries setAllData:(NSMutableArray *)allData;
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;
+(void)showWaiting:(UIView *)parent;
+(void)hideWaiting:(UIView *)parent;
+(void)getAllSubway:(NSMutableArray *)entries;
+(void)getAllSubwayDic:(NSMutableDictionary *)entriesDic;
+(RMMapView *)getMap:(short)zoom center:(CLLocationCoordinate2D)center frame:(CGRect)frame;
+(FMDatabase *)getTransferDataBase;
+(void)getPoiBaseData:(NSString*)sql data:(NSMutableArray *)setData;
+(void) initializeDB;
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
@end
