#import <Cordova/CDV.h>

@interface HoloView_Cordova_plugin : CDVPlugin

- (void)init:(CDVInvokedUrlCommand*)command;
- (void)login:(CDVInvokedUrlCommand*)command;
- (void)joinroom:(CDVInvokedUrlCommand*)command;
- (void)startConversation:(CDVInvokedUrlCommand*)command;
- (void)getConversations:(CDVInvokedUrlCommand*)command;
- (void)getConversationsWitTargetIds:(CDVInvokedUrlCommand*)command;
- (void)logout:(CDVInvokedUrlCommand*)command;
- (void)setReceiveMessageCallback:(CDVInvokedUrlCommand*)command;
- (void)setVideoProfile:(CDVInvokedUrlCommand*)command;
- (void)startChatRoomCall:(CDVInvokedUrlCommand*)command;
- (void)startChatRoomCallWithInviteIds:(CDVInvokedUrlCommand*)command;
- (void)autologin:(CDVInvokedUrlCommand*)command;
- (void)setOnConnectStatusChangeCallback:(CDVInvokedUrlCommand*)command;
- (void)closeBroswer:(CDVInvokedUrlCommand*)command;
- (void)setServerAddr:(CDVInvokedUrlCommand*)command;
- (void)setUseWss:(CDVInvokedUrlCommand*)command;
- (void)requestFloatWindowPermission:(CDVInvokedUrlCommand*)command;
- (void)queryCallState:(CDVInvokedUrlCommand*)command;
- (void)setMqttPingInterval:(CDVInvokedUrlCommand*)command;


@end
