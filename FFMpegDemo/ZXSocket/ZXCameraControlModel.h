//
//  ZXCameraControlModel.h
//  FFMpegDemo
//
//  Created by 陈林 on 2016/11/4.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UUC_MONITOR_CTL         -6001 //"云台控制指令"

// 3、云台镜头与转动控制命令
typedef enum {
    // 【镜头控制】
    kPTZCtrl_ZOOM_IN         = 11,  //焦距变大(倍率变大)，即放大、特写。
    kPTZCtrl_ZOOM_OUT        = 12,  //焦距变小(倍率变小)，即缩小、全景
    kPTZCtrl_FOCUS_NEAR      = 13,  //焦点前调，即近景
    kPTZCtrl_FOCUS_FAR       = 14,  //焦点后调，即远景
    kPTZCtrl_IRIS_OPEN       = 15,  //光圈扩大，即光亮
    kPTZCtrl_IRIS_CLOSE      = 16,  //光圈缩小，即光暗
    
    // 【云台转动】
    kPTZCtrl_TILT_UP         = 21,  //云台以指定的速度上仰
    kPTZCtrl_TILT_DOWN       = 22,  //云台以指定的速度下俯
    kPTZCtrl_PAN_LEFT        = 23,  //云台以指定的速度左转
    kPTZCtrl_PAN_RIGHT       = 24,  //云台以指定的速度右转
    kPTZCtrl_UP_LEFT         = 25,  //云台以指定的速度上仰和左转
    kPTZCtrl_UP_RIGHT        = 26,  //云台以指定的速度上仰和右转
    kPTZCtrl_DOWN_LEFT       = 27,  //云台以指定的速度下俯和左转
    kPTZCtrl_DOWN_RIGHT      = 28,  //云台以指定的速度下俯和右转
    kPTZCtrl_PAN_AUTO        = 29,  //云台以指定的速度左右自动扫描
} PTZCtrlCmd;

@interface ZXCameraControlModel : NSObject


/**
 云台控制命令，对应PTZCtrlCmd。无符号char类型。
 */
@property (assign, nonatomic) unichar command;


/**
 保留字段，值为0。
 */
@property (assign, nonatomic) Byte reserve;


/**
 摄像头ID字段“camera ID”的长度。无符号char类型。
 */
@property (assign, nonatomic) uint16_t cameraIDLength;


/**
 // 【“云台控制命令数据包”格式的参数取值】
 para1：云台速度，0-7,0表示默认速度,1-7表示速度级别。
 para2：指示云台控制是开始还是停止，0开始，1停止。
 para3：0。
 para4：0。
 */
/**
 命令参数1。无符号2字节整型。
 */
@property (assign, nonatomic) uint16_t para1;


/**
 命令参数2。无符号2字节整型。
 */
@property (assign, nonatomic) uint16_t para2;


/**
 命令参数3。无符号2字节整型。
 */
@property (assign, nonatomic) uint16_t para3;


/**
 命令参数4。无符号2字节整型。
 */
@property (assign, nonatomic) uint16_t para4;


/**
 摄像头ID。char字符串，不带结束字符\0。
 */
@property (copy, nonatomic) NSString *cameraID;


+ (NSData *)controlDataWithCommand:(unichar)command cameraID:(NSString *)cameraID para1:(uint16_t)para1 para2:(uint16_t)para2;

@end
