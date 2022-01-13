//
//  CordovaApi.h
//  ImKit
//
//  Created by zhenhui yang on 2018/9/26.
//  Copyright © 2018年 holoview. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^HoloReceiveMessageCallback)(NSString* msg);
typedef void (^HoloConnectStatusChangeCallback)(int status);

@interface HoloCordovaApi : NSObject
+ (instancetype) getInstance;

/// 设置视频通话使用wss还是ws（通话前调用）
/// @param useWss 是否使用wss
- (void) setUseWss:(BOOL) useWss;

/// 设置服务地址（登录前调用）
/// @param address 地址
/// @param environmentId 环境ID
- (void) setServerWithAddress:(NSString*) address andEnvironmentId:(int) environmentId;

/// 设置应用key和secret（登录前调用）
/// @param appkey key
/// @param appSecret secret
- (void) setAppKey:(NSString*) appkey andAppSecret:(NSString*) appSecret;

/// 设置发送文件的最大大小 单位：KB
/// @param maxSizeOfSentFile 最大大小
- (void) setMaxSizeOfSentFile:(int64_t) maxSizeOfSentFile;


/// 设置MQTT PING时间间隔
/// @param mqttPingInterval MQTT PING时间间隔
- (void) setMqttPingInterval:(int) mqttPingInterval;

/// 初始化
/// @param autoReconnect 是否开启自动重连
- (BOOL) initializeWithAutoReconnect:(BOOL) autoReconnect ;

/// 设置消息回调
/// @param callback 回调
- (void) setReceiveMessageCallback:(HoloReceiveMessageCallback) callback;

/// 设置连接状态回调
/// @param callback 回调
- (void) setConnectStatusChangeCallback:(HoloConnectStatusChangeCallback) callback;

/// 获取当前连接状态
- (int) getCurrentConnectStatus;

/// 使用token和appid登录
/// @param token 用户token
/// @param appid appid
/// @param callback 结果回调 异常结果msg内容：
///                    token_error ： token失效
///                    nav_error：导航失败
///                    server_error：服务器异常（访问不到、返回未知错误、返回应答格式错误）
- (void) loginWithToken:(NSString*) token andAppid:(NSString*) appid andCallback:(void(^)(BOOL result, int64_t userid, NSString* msg)) callback;

/// 自动登录
/// @param callback 结果回调  异常结果msg内容：
///                     already_logout：未登录或已登出
///                     not_init：未初始化
///                     token_error：缓存的token错误
- (void) autoLoginWithCallback:(void(^)(BOOL result, int64_t userid, NSString* msg)) callback;
- (void) joinRoomWithRoomCode:(NSString*) roomCode andCallback:(void(^)(BOOL result, NSString* msg)) callback;
/// 启动房间会话
- (void) startConversationWithRoomId:(uint64_t)  roomId andViewController:(UIViewController*) vc;
- (void) startConversationWithRoomId:(uint64_t)  roomId andViewController:(UIViewController*) vc andIsFinish:(BOOL) isFinish;
- (void) startConversationWithRoomId:(uint64_t)  roomId andTitle:(NSString*) title andViewController:(UIViewController*) vc andIsFinish:(BOOL) isFinish;
- (void) startConversationWithRoomId:(uint64_t)  roomId andTitle:(NSString*) title andViewController:(UIViewController*) vc andIsFinish:(BOOL) isFinish andNeedCall:(BOOL) needCall;
/// 使用Window启动房间会话
- (void) startConversationWindowWithRoomId:(uint64_t)  roomId andTitle:(NSString*) title andViewController:(UIViewController*) vc andIsFinish:(BOOL) isFinish andNeedCall:(BOOL) needCall;

/// 启动二人会话
- (void) startPrivateConversationWithTargetId:(uint64_t)  targetId andViewController:(UIViewController*) vc;
- (void) startPrivateConversationWithTargetId:(uint64_t)  targetId andTitle:(NSString*) title andViewController:(UIViewController*) vc;
- (void) startPrivateConversationWithTargetId:(uint64_t)  targetId andTitle:(NSString*) title andViewController:(UIViewController*) vc andIsFinish:(BOOL) isFinish andNeedCall:(BOOL) needCall;

- (void) startPrivateConversationWindowWithTargetId:(uint64_t)  targetId andTitle:(NSString*) title andViewController:(UIViewController*) vc andIsFinish:(BOOL) isFinish andNeedCall:(BOOL) needCall;
/// 使用会话类型获取会话列表（旧版本返回结合和android端不同）
/// @param type 会话类型
/// @param callback 结果回调
/// no_conversation：没有找到对应会话
- (void) getConversationListWithType:(int) type andCallback:(void(^)(BOOL result, NSString* msg)) callback;
/// 使用会话类型获取会话列表
/// @param type 会话类型
/// @param callback 结果回调
/// no_conversation：没有找到对应会话
- (void) getConversationListWithType1:(int) type andCallback:(void(^)(BOOL result, NSString* msg)) callback;

/// 使用会话类型和会话ID列表获取会话列表
/// @param type 会话类型
/// @param targetIds 会话ID列表
/// @param callback 结果回调
/// param_err : 参数错误
/// no_conversation：没有找到对应会话
- (void) getConversationListWithType2:(int) type andTargetIds:(NSArray<NSNumber*>*) targetIds andCallback:(void(^)(BOOL result, NSString* msg)) callback;

/// 开始房间通话
/// @param targetId 目标id
/// @param callMediaType 媒体类型
/// @param callback 结果回调 异常结果msg内容：
///                     no_permission：没有权限
///                     already_calling：通话中
///                     get_member_fail：获取房间成员失败
- (void) startChatRoomCallWithTargetId:(uint64_t) targetId andCallMediaType:(int) callMediaType
                           andCallback:(void(^)(BOOL result, NSString* msg)) callback;

/// 开始房间通话
/// @param targetId 目标id
/// @param callMediaType 媒体类型
/// @param inviteIds 邀请的成员列表
/// @param callback 结果回调 异常结果msg内容：
///                     param_err: 参数异常
///                     member_size_over: 邀请成员超过上限 最多4人
///                     no_permission：没有权限
///                     already_calling：通话中
- (void) startChatRoomCallWithTargetId:(uint64_t) targetId andCallMediaType:(int) callMediaType
                           andInviteIds:(NSArray<NSNumber*>*) inviteIds andCallback:(void(^)(BOOL result, NSString* msg)) callback;
/// 开始一对一通话
/// @param targetId 目标id
/// @param callMediaType 媒体类型
/// @param callback 结果回调 异常结果msg内容：
///                     no_permission：没有权限
///                     already_calling：通话中
- (void) startP2PCallWithTargetId:(uint64_t) targetId andCallMediaType:(int) callMediaType
                      andCallback:(void(^)(BOOL result, NSString* msg)) callback;
- (BOOL) isOnVideoCall;
- (BOOL) logout;

/**
 设置视频属性

 @param resolution 分辨率 @"360P" @"480P" @"720P" 默认值:@"720P"
 @param fps 帧率 15 20 25 30 默认值:30
 @param quality 视频码率 @"High" @"Middle" @"Low" 默认值:@"Middle"
 @param codec 编码方式 @"VP8" @"H264" 默认值:@"H264"
 */
- (void) setVideoProfileWithResolution:(NSString*) resolution andFps:(int) fps andQuality:(NSString*) quality andCodec:(NSString*) codec;


/**
 get current video profile

 @param callback profile callback msg:json format
 */
- (void) getCurrentVideoProfileWithCallback:(void(^)( NSString* msg)) callback;

/// 发送文本消息
/// @param conversationType 会话类型
/// @param targetId 目标id
/// @param content 文本消息内容
/// @param callback 结果回调
- (void) sendTextMessageWithConversationType:(int) conversationType andTargetId:(uint64_t) targetId andContent:(NSString*) content andCallback:(void(^)( BOOL result, NSString* msg)) callback;

/// 发送命令消息
/// @param conversationType 会话类型
/// @param targetId 目标ID
/// @param cmd 命令内容
/// @param extra 扩展字段
/// @param callback 结果回调
- (void) sendCmdMessageWithConversationType:(int) conversationType andTargetId:(uint64_t) targetId andCmd:(NSString*) cmd andExtra:(NSString*) extra andCallback:(void(^)( BOOL result, NSString* msg)) callback;

/// 获取历史消息
/// @param conversationType 会话类型
/// @param targetId 目标id
/// @param oldestMessageId 旧消息id（获取本消息前的n条）
/// @param count 消息条数n
/// @param callback 结果回调
- (void) getHistoryMessageWithConversationType:(int) conversationType andTargetId:(uint64_t) targetId andOldestMessageId:(NSString*) oldestMessageId andCount:(int) count andCallback:(void(^)( BOOL result, NSString* msg)) callback;


/// 生成专家二维码
/// @param targetId 房间号
/// @param uids 邀请的专家列表
/// @param callback 结果回调
- (void) generateExpertQrcodeWithTargetId:(uint64_t) targetId andInviteUids:(NSMutableArray<NSNumber*>*) uids andCallback:(void(^)( BOOL result, NSString* msg)) callback;


/// 生成二维码
/// @param content 二维码内容
/// @param filename 文件名
/// @param callback 结果回调
- (void) generateQrcodeWithContent:(NSString*) content andFilename:(NSString*) filename andCallback:(void(^)( BOOL result, NSString* msg)) callback;


/// 改变语言
/// @param language  en:英语  zh:简体中文
- (void) changeLanguage:(NSString*) language;


/// 查询会议状态
/// @param targetId 房间ID
/// @param callback 结果回调
- (void) queryConfStatus:(uint64_t) targetId andCallback:(void(^)( BOOL result, uint64_t rid, NSString* msg)) callback;

/// 加入会议
/// @param targetId 房间ID
/// @param callback 结果回调
- (void) joinConf:(uint64_t) targetId andCallback:(void(^)( BOOL result, uint64_t rid, NSString* msg)) callback;


/// 是否正在会议中
/// @param callback 结果回调 YES：在会议中并返回会议房间ID  NO：不在会议中
- (void) isInConferenceWithCallback:(void(^)( BOOL result, uint64_t rid, NSString* msg)) callback;


/// 邀请进入通话
/// @param rid 房间ID
/// @param participatIds 成员id列表
/// @param callback 结果
- (void) addParticipantToConfWithRid:(uint64_t) rid andParticipatIds:(NSMutableArray<NSNumber*>*) participatIds andCallback:(void(^)( BOOL result, NSString* msg)) callback;


/// APP被杀时的处理 调用方法
/// - (void)applicationDidEnterBackground:(UIApplication *)application {
///     [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
/// }
/// - (void)applicationWillTerminate:(UIApplication *)application {
///     [HoloCordovaApi.getInstance applicationWillTerminate];
/// }
- (void) applicationWillTerminate;

/// 返回支持的方向 调用方法
/// - (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
///{
///    return [HoloCordovaApi.getInstance application:application supportedInterfaceOrientationsForWindow:window];
///}
/// @param application application description
/// @param window window description
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window;

- (void)hangupCall;
- (void) test;
@end
