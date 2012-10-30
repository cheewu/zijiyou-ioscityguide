//
//  NSDataDES.m
//  自己游
//
//  Created by piaochunzhi on 12-10-4.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "NSDataDES.h"

@implementation NSDataDES


static Byte iv[] = {1,2,3,4,5,6,7,8};

+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    const char *textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          textBytes, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [NSDataDES base64Encoding:data];
    }
    return ciphertext;
}


static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
+(NSString *)base64Encoding :(NSData *)data
{
    if (data.length == 0)
        return @"";
    
    char *characters = malloc(data.length*3/2);
    
    if (characters == NULL)
        return @"";
    
    int end = data.length - 3;
    int index = 0;
    int charCount = 0;
    int n = 0;
    
    while (index <= end) {
        int d = (((int)(((char *)[data bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[data bytes])[index + 1]) & 0x0ff) << 8)
        | ((int)(((char *)[data bytes])[index + 2]) & 0x0ff);
        
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = encodingTable[d & 63];
        
        index += 3;
        
        if(n++ >= 14)
        {
            n = 0;
            characters[charCount++] = ' ';
        }
    }
    
    if(index == data.length - 2)
    {
        int d = (((int)(((char *)[data bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[data bytes])[index + 1]) & 255) << 8);
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = '=';
    }
    else if(index == data.length - 1)
    {
        int d = ((int)(((char *)[data bytes])[index]) & 0x0ff) << 16;
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = '=';
        characters[charCount++] = '=';
    }
    NSString * rtnStr = [[NSString alloc] initWithBytesNoCopy:characters length:charCount encoding:NSUTF8StringEncoding freeWhenDone:YES];
    return rtnStr;
}


+(NSString *) parseByte2HexString:(Byte *) bytes
{
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes)
    {
        while (bytes[i] != '\0')
        {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
            
            i++;
        }
    }
    NSLog(@"bytes 的16进制数为:%@",hexStr);
    return hexStr;
}

+(NSString *) parseByteArray2HexString:(Byte[]) bytes
{
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes)
    {
        while (bytes[i] != '\0')
        {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
            
            i++;
        }
    }
    NSLog(@"bytes 的16进制数为:%@",hexStr);
    return hexStr;
}



#pragma 解密内容
+(NSString *)getContentByHexAndDes:(NSString *)content key:(NSString*)key
{
    NSMutableString *str=[NSMutableString stringWithCapacity:0];
    const char *opcontentchar = [content cStringUsingEncoding:NSASCIIStringEncoding];
    
    NSData *contentdata = [NSData dataWithBytes:opcontentchar length:strlen(opcontentchar)];
    
    NSData *dec =[NSDataDES DESOperationWithKey:key CCOperation:kCCDecrypt data:[NSDataDES hex2byte:contentdata] ];
    
    if (dec)
    {
        str = [NSString stringWithCString:[dec bytes] encoding:NSUTF8StringEncoding];
    }
    return str;
}
+ (NSData *)DESOperationWithKey:(NSString *)keyString data:(NSData *)data
{
    return [NSDataDES DESOperationWithKey:keyString CCOperation:kCCDecrypt data:data];
}
+ (NSData *)DESOperationWithKey:(NSString *)keyString
                    CCOperation:(CCOperation)op data:(NSData *)data
{
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeDES;
    void *buffer = malloc(bufferSize);
    memset(buffer, 0, bufferSize);
    
    size_t bufferNumBytes;
    CCCryptorStatus cryptStatus = CCCrypt(op,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [keyString UTF8String],
                                          kCCKeySizeDES,
                                          NULL,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &bufferNumBytes);
    
    if(cryptStatus == kCCSuccess)
    {
        NSData *ret = [NSData dataWithBytes:buffer length:bufferNumBytes];
        free(buffer);
        return ret;
    }
    
    free(buffer);
    
    return nil;
}

+(int8_t)hex2Int:(const char *)aData
{
    int r1 = aData[0] >= 'a' ? aData[0] - 'a' + 10 : aData[0] - '0';
    int r2 = aData[1] >= 'a' ? aData[1] - 'a' + 10 : aData[1] - '0';
    return r1*16+r2;
}

+(NSData *)hex2byte:(NSData *)aData
{
    int8_t *buffer = (int8_t *)malloc(sizeof(int8_t)*aData.length/2);
    memset(buffer, 0, sizeof(int8_t)*aData.length/2);
    
    for (int n = 0; n < aData.length; n+=2)
    {
        NSRange range;
        range.length = 2;
        range.location = n;
        NSData *subData = [aData subdataWithRange:range];
        NSString *str = [[NSString stringWithCString:[subData bytes] encoding:NSUTF8StringEncoding] lowercaseString];
        buffer[n/2] = [self hex2Int:[str UTF8String]];
    }
    
    return [NSData dataWithBytesNoCopy:buffer length:sizeof(int8_t)*aData.length/2];
}
@end
