//
//  NSDataDES.h
//  自己游
//
//  Created by piaochunzhi on 12-10-4.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//
#define deskey @"ZJYHK520"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSDataDES : NSObject
//+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;
+(NSString *)getContentByHexAndDes:(NSString *)content key:(NSString*)key;
+ (NSData *)DESOperationWithKey:(NSString *)keyString data:(NSData *)data;
@end
