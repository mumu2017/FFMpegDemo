//
//  ZXSocketManager.h
//  SocketDemo
//
//  Created by 陈林 on 2016/11/2.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@interface ZXSocketManager : NSObject

@property (strong, nonatomic) GCDAsyncSocket *socket;

/**
 *  获取单例
 *
 *  @return 单例对象
 */

+(instancetype)getInstance;

@end
