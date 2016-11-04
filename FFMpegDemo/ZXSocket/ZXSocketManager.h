//
//  ZXSocketManager.h
//  SocketDemo
//
//  Created by 陈林 on 2016/11/2.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
@class ZXSocketDataModel;

@interface ZXSocketManager : NSObject

@property (strong, nonatomic) GCDAsyncSocket *socket;

@property (copy, nonatomic) void (^loginBlock)(ZXSocketDataModel *socketData);
@property (copy, nonatomic) void (^cameraBlock)(NSArray *cameraList);

/**
 *  获取单例
 *
 *  @return 单例对象
 */

+(instancetype)getInstance;

+ (NSData *)requestSpliceAttribute:(id)obj;

+ (NSString *)dataToString:(NSData *)data;

- (void)logIn;

- (void)requestForCamareList;

- (void)cameraDirectionControlWithData:(NSData *)data;

- (void)connect;


@end
