#import "HoloView_Cordova_plugin.h"
#import <Cordova/CDV.h>
#import "HoloCordovaApi.h"

@interface HoloView_Cordova_plugin()
@property(nonatomic,strong) NSString* receiveMessageCallbackId;
@property(nonatomic,strong) NSString* connectStatusCallbackId;
@property(nonatomic,strong) NSString* vcLifeCycleCallbackId;

@end
@implementation HoloView_Cordova_plugin
- (void)pluginInitialize{
    NSLog(@"HoloView_Cordova_plugin#pluginInitialize");

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPause) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResume) name:UIApplicationWillEnterForegroundNotification object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidAppear:) name:@"HoloOnCallVcDidDisappear" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidDisappear:) name:@"HoloOnCallVcDidAppear" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidAppear:) name:@"HoloOnCallFloatWindowShow" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidDisappear:) name:@"HoloOnCallFloatWindowHide" object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidAppear:) name:CDVViewDidAppearNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidDisappear:) name:CDVViewDidDisappearNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"viewDidAppear"];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.vcLifeCycleCallbackId];
}

-(void)viewDidDisappear:(BOOL)animated
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"viewDidDisappear"];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.vcLifeCycleCallbackId];
}

- (void)setVCLifecycleCallback:(CDVInvokedUrlCommand*)command{
    self.vcLifeCycleCallbackId = [NSString stringWithString:command.callbackId];
}

- (void)init:(CDVInvokedUrlCommand*)command{
    NSString* str = [command.arguments objectAtIndex:0];
    NSString* appkey = [command.arguments objectAtIndex:1];
    NSString* appsecret = [command.arguments objectAtIndex:2];
    BOOL autoReconnect = YES;
    if (str!= nil && [str isEqualToString:@"NO"]) {
        autoReconnect = NO;
    }
    [HoloCordovaApi.getInstance setAppKey:appkey andAppSecret:appsecret];
    [HoloCordovaApi.getInstance initializeWithAutoReconnect:autoReconnect];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"init done"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}
- (void)login:(CDVInvokedUrlCommand*)command{
    NSString* token = [command.arguments objectAtIndex:0];
    NSString* appid = [command.arguments objectAtIndex:1];
    
    [HoloCordovaApi.getInstance loginWithToken:token andAppid:appid andCallback:^(BOOL result, int64_t userid, NSString *msg) {
        CDVPluginResult* pluginResult = nil;

        if (result) {
            NSString* strId = [NSString stringWithFormat:@"%lld", userid];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:strId];
        }else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:msg];

        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];


}
- (void)autologin:(CDVInvokedUrlCommand*)command{
    [HoloCordovaApi.getInstance autoLoginWithCallback:^(BOOL result, int64_t userid, NSString *msg) {
        CDVPluginResult* pluginResult = nil;
        
        if (result) {
            NSString* strId = [NSString stringWithFormat:@"%lld", userid];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:strId];
        }else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:msg];
            
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)joinroom:(CDVInvokedUrlCommand*)command{
    NSString* roomCode = [command.arguments objectAtIndex:0];
    [HoloCordovaApi.getInstance joinRoomWithRoomCode:roomCode andCallback:^(BOOL result, NSString *msg) {
        CDVPluginResult* pluginResult = nil;

        if (result) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
        }else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:msg];
            
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];
}

- (void)startConversation:(CDVInvokedUrlCommand*)command{
    NSString* roomid = [command.arguments objectAtIndex:0];
    NSString* roomName = [command.arguments objectAtIndex:1];
    NSNumber* isFinish =[command.arguments objectAtIndex:2];
    NSNumber* needCall =[command.arguments objectAtIndex:3];

    dispatch_async(dispatch_get_main_queue(), ^{
        [HoloCordovaApi.getInstance startConversationWindowWithRoomId:roomid.longLongValue andTitle:roomName andViewController:self.viewController andIsFinish:isFinish.boolValue andNeedCall:needCall.boolValue];
        
    });
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void)getConversations:(CDVInvokedUrlCommand*)command{
    NSString* conversationType = [command.arguments objectAtIndex:0];
    [HoloCordovaApi.getInstance getConversationListWithType1:conversationType.intValue andCallback:^(BOOL result, NSString *msg) {
        CDVPluginResult* pluginResult = nil;
        if (result) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:msg];
        }else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:msg];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
    }];
    
}
- (void)getConversationsWitTargetIds:(CDVInvokedUrlCommand*)command{
    NSNumber* conversationType = [command.arguments objectAtIndex:0];
    NSArray<NSNumber*>* targetIds = [command.arguments objectAtIndex:1];
    [HoloCordovaApi.getInstance getConversationListWithType2:conversationType.intValue andTargetIds:targetIds andCallback:^(BOOL result, NSString *msg) {
        CDVPluginResult* pluginResult = nil;
        if (result) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:msg];
        }else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:msg];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}
- (void)setReceiveMessageCallback:(CDVInvokedUrlCommand*)command{
    self.receiveMessageCallbackId = [NSString stringWithString:command.callbackId];
    
    [HoloCordovaApi.getInstance setReceiveMessageCallback:^(NSString *msg) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:msg];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.receiveMessageCallbackId];
    }];
    

}
- (void)setOnConnectStatusChangeCallback:(CDVInvokedUrlCommand*)command{
    self.connectStatusCallbackId = [NSString stringWithString:command.callbackId];
    
    [HoloCordovaApi.getInstance setConnectStatusChangeCallback:^(int status) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:status];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.connectStatusCallbackId];
    }];
}
- (void)logout:(CDVInvokedUrlCommand*)command{
    
    [HoloCordovaApi.getInstance logout];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"logout done"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void)setVideoProfile:(CDVInvokedUrlCommand*)command{
    NSString* resolution = [command.arguments objectAtIndex:0];
    NSString* fps = [command.arguments objectAtIndex:1];
    NSString* quality = [command.arguments objectAtIndex:2];
    NSString* codec = [command.arguments objectAtIndex:3];

    [HoloCordovaApi.getInstance setVideoProfileWithResolution:resolution andFps:fps.intValue andQuality:quality andCodec:codec];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"setVideoProfile done"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getCurrentVideoProfile:(CDVInvokedUrlCommand*)command{
    [HoloCordovaApi.getInstance getCurrentVideoProfileWithCallback:^(NSString *msg) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:msg];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}
- (void)startChatRoomCall:(CDVInvokedUrlCommand*)command{
    NSString* roomid = [command.arguments objectAtIndex:0];

    [HoloCordovaApi.getInstance startChatRoomCallWithTargetId:roomid.longLongValue andCallMediaType:1 andCallback:^(BOOL result, NSString *msg) {
        CDVPluginResult* pluginResult = nil;
        if (result) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:msg];
        }else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:msg];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];
}
- (void)startChatRoomCallWithInviteIds:(CDVInvokedUrlCommand*)command{
    NSNumber* roomid = [command.arguments objectAtIndex:0];
    NSArray<NSNumber*>* inviteIds = [command.arguments objectAtIndex:1];
    [HoloCordovaApi.getInstance startChatRoomCallWithTargetId:roomid.longLongValue andCallMediaType:1 andInviteIds:inviteIds andCallback:^(BOOL result, NSString *msg) {
        CDVPluginResult* pluginResult = nil;
        if (result) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:msg];
        }else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:msg];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)queryCallState:(CDVInvokedUrlCommand*)command{
    BOOL onCall = [HoloCordovaApi.getInstance isOnVideoCall];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:onCall?1:0];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)closeBroswer:(CDVInvokedUrlCommand*)command{
    NSLog(@"HoloView_Cordova_plugin#closeBroswer");
    __block CDVPluginResult* pluginResult = nil;
    @try {
        if (self.viewController) {
            [self.viewController dismissViewControllerAnimated:YES completion:^{
                   
            }];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"close_success"];
        }else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"close_failure"];
        }
    } @catch (NSException *exception) {
       pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"not_presented_vc"];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    
    
    
}

- (void)setServerAddr:(CDVInvokedUrlCommand*)command{
    NSLog(@"HoloView_Cordova_plugin#setServerAddr");
    NSString* addr =[command.arguments objectAtIndex:0];
    NSNumber* env =[command.arguments objectAtIndex:1];
    CDVPluginResult* pluginResult = nil;
    if (addr == nil || env == nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"param_error"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    [HoloCordovaApi.getInstance setServerWithAddress:addr andEnvironmentId:env.intValue];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"set_addr_successs"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setUseWss:(CDVInvokedUrlCommand*)command{
    NSLog(@"HoloView_Cordova_plugin#setUseWss");
    NSString* userWss = [command.arguments objectAtIndex:0];
    CDVPluginResult* pluginResult = nil;

    BOOL uw = YES;
    if (userWss!= nil && [userWss isEqualToString:@"NO"]) {
        uw = NO;
    }
    [HoloCordovaApi.getInstance setUseWss:uw];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"set_wss_successs"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void)requestFloatWindowPermission:(CDVInvokedUrlCommand*)command{
    NSLog(@"HoloView_Cordova_plugin#requestFloatWindowPermission");
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"already_had_permission"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}
- (void)setMaxSizeOfSentFile:(CDVInvokedUrlCommand*)command{
    NSLog(@"HoloView_Cordova_plugin#setMaxSizeOfSentFile");
    NSNumber* maxSize = [command.arguments objectAtIndex:0];;
    [HoloCordovaApi.getInstance setMaxSizeOfSentFile:maxSize.intValue];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"set_success"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void)setMqttPingInterval:(CDVInvokedUrlCommand*)command{
    NSLog(@"HoloView_Cordova_plugin#setMqttPingInterval");
    NSNumber* pingInterval = [command.arguments objectAtIndex:0];
    if(pingInterval){
        [HoloCordovaApi.getInstance setMqttPingInterval:pingInterval.intValue];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"set_mqtt_ping_success"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }else{
        CDVPluginResult*pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"param_error"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }

}

- (void)hangupCall:(CDVInvokedUrlCommand*)command{
    NSLog(@"HoloView_Cordova_plugin#hangupCall");
    
    [HoloCordovaApi.getInstance hangupCall];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"hangup_call_success"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void)onAppTerminate
{
    NSLog(@"HoloView_Cordova_plugin#pluginInitialize");
}
- (void)onReset
{
    NSLog(@"HoloView_Cordova_plugin#onReset");
}

- (void)onPause
{
    NSLog(@"HoloView_Cordova_plugin#onPause");
}
- (void)onResume
{
    NSLog(@"HoloView_Cordova_plugin#onResume");
 
}
@end
