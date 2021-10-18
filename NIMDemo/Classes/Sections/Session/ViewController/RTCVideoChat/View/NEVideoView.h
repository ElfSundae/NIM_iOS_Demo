//
//  NEVideoView.h
//  NLiteAVDemo
//
//  Created by I am Groot on 2020/8/26.
//  Copyright © 2020 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NEVideoView;

@protocol NEVideoViewDelegate
- (void)didTapVideoView:(NEVideoView *)videoView;
@end

@interface NEVideoView : UIView
@property(strong,nonatomic)NSString *userID;
@property(strong,nonatomic)UIView *videoView;
@property(strong,nonatomic)UILabel *titleLabel;

@property(assign,nonatomic)BOOL isSmall;
@property(nonatomic) CGRect            fowardFrame;
@property(weak,nonatomic)id delegate;
- (void)becomeBig;
- (void)becomeSmall;
@end

NS_ASSUME_NONNULL_END
