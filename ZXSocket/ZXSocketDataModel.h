//
//  ZXSocketDataModel.h
//  SocketDemo
//
//  Created by 陈林 on 2016/10/28.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kAccountCheckTargetType_UNUSED = 0,	// 0 未分配
    kAccountCheckTargetType_USER = 1,	// 1 用户平台登录账号
    kAccountCheckTargetType_SIP = 2,	// 2 SIP账号
    kAccountCheckTargetType_ORG = 3,	// 3 机构账号
    kAccountCheckTargetType_PERSON = 4	// 4 机构成员账号
} AccountCheckTargetType ;


@interface ZXSocketDataModel : NSObject

//@property (nonatomic, assign) short code;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) Byte targetType;

@property (nonatomic, assign) Byte optResult;
@property (nonatomic, copy) NSString *optInfo;

+ (NSData *)requestDataWithUserName:(NSString *)userName password:(NSString *)password protocalType:(int16_t)protocalType;

+ (ZXSocketDataModel *)socketDataModelFromData:(NSData *)data;

@end
