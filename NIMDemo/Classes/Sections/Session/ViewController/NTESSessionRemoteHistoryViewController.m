//
//  NTESSessionHistoryViewController.m
//  NIM
//
//  Created by chris on 15/4/22.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESSessionRemoteHistoryViewController.h"
#import "UIView+Toast.h"
#import "SVProgressHUD.h"
#import "NIMCellLayoutConfig.h"
#import "NTESBundleSetting.h"
#import "NTESCellLayoutConfig.h"

#pragma mark - Remote View Controller
@interface NTESSessionRemoteHistoryViewController ()<NTESRemoteSessionDelegate>


@end

@implementation NTESSessionRemoteHistoryViewController

- (instancetype) initWithSession:(NIMSession *)session{
    NTESRemoteSessionConfig *config = [[NTESRemoteSessionConfig alloc] initWithSession:session];

    return [self initWithSession:session config:config];
}

- (instancetype)initWithSession:(NIMSession *)session config:(NTESRemoteSessionConfig *)config
{
    self = [super initWithSession:session];
    if (self) {
        self.config = [[NTESRemoteSessionConfig alloc] initWithSession:session];
        self.config.delegate = self;
        self.disableCommandTyping = YES;
        self.disableOnlineState = YES;
    }
    return self;
}

- (void)dealloc{
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xe4e7ec);
    self.navigationItem.rightBarButtonItems = @[];
    self.navigationItem.leftBarButtonItems = @[];
    [SVProgressHUD show];
}


- (NSString *)sessionTitle{
    return @"云消息记录".ntes_localized;
}

- (NSString *)sessionSubTitle
{
    return @"";
}

- (BOOL)disableAudioPlayedStatusIcon:(NIMMessage *)message
{
    return YES;
}

- (void)sendMessage:(NIMMessage *)message{};

- (id<NIMSessionConfig>)sessionConfig{
    return self.config;
}

- (NSArray *)menusItems:(NIMMessage *)message{
    return nil;
}

#pragma mark - NIMMessageCellDelegate

- (BOOL)onLongPressCell:(NIMMessage *)message
                 inView:(UIView *)view
{
    return YES;
}

- (void)onClickEmoticon:(NIMMessage *)message
                comment:(NIMQuickComment *)comment
               selected:(BOOL)isSelected
{
    
}


- (void)uiAddMessages:(NSArray *)messages{}

#pragma mark - NTESRemoteSessionDelegate
- (void)fetchRemoteDataError:(NSError *)error{
    if (error) {
        [self.view makeToast:@"获取消息失败".ntes_localized duration:2.0 position:CSToastPositionCenter];
    }
}

#pragma mark - NIMSessionConfiguratorDelegate
- (void)didFetchMessageData{
    [super didFetchMessageData];
    [SVProgressHUD dismiss];
}

@end



#pragma mark - Remote Session Config
@interface NTESRemoteSessionConfig()

@property (nonatomic,strong) NIMRemoteMessageDataProvider *provider;



@end

@implementation NTESRemoteSessionConfig

- (instancetype)initWithSession:(NIMSession *)session{
    self = [super init];
    if (self) {
        NSInteger limit = 20;
        self.provider = [[NIMRemoteMessageDataProvider alloc] initWithSession:session limit:limit];
    }
    return self;
}

- (void)setDelegate:(id<NTESRemoteSessionDelegate>)delegate{
    self.provider.delegate = delegate;
}

- (id<NIMKitMessageProvider>)messageDataProvider{
    return self.provider;
}

- (BOOL)disableProximityMonitor{
    return [[NTESBundleSetting sharedConfig] disableProximityMonitor];
}

- (BOOL)autoFetchAttachment {
    return [[NTESBundleSetting sharedConfig] autoFetchAttachment];
}

- (BOOL)disableInputView{
    return YES;
}

//云消息不支持音频轮播
- (BOOL)disableAutoPlayAudio
{
    return YES;
}

//云消息不显示已读
- (BOOL)shouldHandleReceipt{
    return NO;
}

- (BOOL)disableReceiveNewMessages
{
    return YES;
}

- (NSArray<NIMMediaItem *> *)mediaItems
{
    return nil;
}

- (NSArray<NIMMediaItem *> *)menuItemsWithMessage:(NIMMessage *)message
{
    return nil;
}


- (NSArray*)emotionItems
{
    return nil;
}

@end




#pragma mark - Provider
@interface NIMRemoteMessageDataProvider(){
    NSMutableArray *_msgArray; //消息数组
    NSTimeInterval _lastTime;
}
@end


@implementation NIMRemoteMessageDataProvider

- (instancetype)initWithSession:(NIMSession *)session limit:(NSInteger)limit{
    self = [super init];
    if (self) {
        _limit = limit;
        _session = session;
    }
    return self;
}

- (void)pullDown:(NIMMessage *)firstMessage handler:(NIMKitDataProvideHandler)handler{
    [self remoteFetchMessage:firstMessage handler:handler];
}


- (void)remoteFetchMessage:(NIMMessage *)message
                   handler:(NIMKitDataProvideHandler)handler
{
    NIMHistoryMessageSearchOption *searchOpt = [[NIMHistoryMessageSearchOption alloc] init];
    searchOpt.startTime  = 0;
    searchOpt.endTime    = message.timestamp;
    searchOpt.currentMessage = message;
    searchOpt.limit      = self.limit;
    searchOpt.sync       =  [NTESBundleSetting sharedConfig].enableSyncWhenFetchRemoteMessages;
    [[NIMSDK sharedSDK].conversationManager fetchMessageHistory:self.session option:searchOpt result:^(NSError *error, NSArray *messages) {
        if (handler) {
            handler(error,messages.reverseObjectEnumerator.allObjects);
            if ([self.delegate respondsToSelector:@selector(fetchRemoteDataError:)]) {
                [self.delegate fetchRemoteDataError:error];
            }
        };
    }];
}

@end
