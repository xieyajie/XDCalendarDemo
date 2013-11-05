//
//  XDCalendarDefine.h
//  Lianxi
//
//  Created by xieyajie on 13-7-24.
//  Copyright (c) 2013年 TIXA. All rights reserved.
//

#ifndef Lianxi_XDCalendarDefine_h
#define Lianxi_XDCalendarDefine_h

#if !defined __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
# define KTextAlignmentLeft UITextAlignmentLeft
# define KTextAlignmentCenter UITextAlignmentCenter
# define KTextAlignmentRight UITextAlignmentRight

#define KLineBreakModeClip UILineBreakModeClip

#else
# define KTextAlignmentLeft NSTextAlignmentLeft
# define KTextAlignmentCenter NSTextAlignmentCenter
# define KTextAlignmentRight NSTextAlignmentRight

#define KLineBreakModeClip NSLineBreakByClipping
#endif

#define KToolbarHeight 44
#define KScreenWidth 320
#define KHeightWithoutStatusBar [[UIScreen mainScreen] bounds].size.height - 20
#define KTimerViewHeight 372

#define kSignViewHeight 25
#define kCalendarPickerOneWeekHeight 69
#define kCalendarPickerDaysMaxHeight 245
#define kCalendarDayBlockWidth 46
#define kCalendarDayBlockHeight 44

#define kColorDValue 20.0
#define kColorBase 255.0

#define KCalendarViewWeekSymbolFontName @"HelveticaNeue-Bold"
#define KCalendarViewWeekSymbolFontSize 12

#define KCalendarViewGridBackgroudColor @"0xf9f9f9"
#define KCalendarViewGridLineColor @"0xcfd4d8"
#define KCalendarViewOtherDayColor @"0xaaaaaa"
#define KCalendarViewSelectedColor @"0x4ec4ff"
#define KCalendarViewNormalTextColorHex @"0x383838"

#define KCalendarViewMonthFormatter @"yyyy - MM"
#define KShowViewDateFormatter @"yyyy年MM月dd日"
#define KPostViewDateFormatter @"yyyy-MM-dd"
#define KPostViewTimeFormatter @"HH:mm"

#define KDayBlockDateFontName @"HelveticaNeue-Bold"
#define KDayBlockDateFontSize 22

#define KEachRowCount 4
#define KContentLabelTag 99

//头像展示页面相关
#define kInviteTopMarge 10
#define kInviteViewWidth 80
#define kInviteViewHeight 95
#define kInviteImgSize 65

//服务器获取数据常量参数
#define kCalendarAppType @"5"
#define kPageMaxRows 20
#define kCommentMaxRows 10

#define kEventJoinStatus 1
#define kEventExitStatus 0


#pragma mark - NSNotification name

#define kNotificationDateSelectedFromBlock @"SelectedFromBlock"
#define kNotificationDateSelectedFromExterior @"SelectedFromExterior"
#define kNotificationDeleteEvent @"deleteEvent"
#define kNotificationExitEvent @"exitEvent"
#define kNotificationRefreshData @"refreshData"
#define kNotificationUpdateEvent @"updateEvent"

#pragma mark - kvo
#define kKVODotsDataChange @"dotsDictionary"
#define kKVOSelectedDateChange @"selectedDate"

#pragma mark - syn
#define kSynKey @"synAccount"
#define kSynShareType @"ShareType"

#pragma mark - auto syn
#define kAutoSynLocal @"localSyn"
#define kAutoSynGoogle @"googleSyn"
#define kAutoSynLocalInterval @"synLocalInterval"
#define kAutoSynGoogleInterval @"synGoogleInterval"


#pragma mark - 服务器接口字段名

#define kSelfEventCountAddress @"event/getSEventListCount.jsp?"//自己的事件数量
#define kFriendEventCountAddress @"event/getREventListCount.jsp?"//朋友的事件数量

//服务器返回
//获取“自己的”页面数据
//json字段
#define kCalendarData @"data"
#define kCalendarErrorCode @"s"
#define kCalendarResultCount @"n"
#define kCalendarNextFlag @"nextFlag"
#define kCalendarCount @"count"
//google日历同步相关
#define kCalendarGoogleSynFinishCount @"finishCount"
#define kCalendarGoogleSynTotalCount @"totalCount"
#define kCalendarToGoogleSynCount @"snsToGoogleCount"
#define kCalendarGoogleToSynCount @"googleToSnsCount"

//返回内容字段
#define kCalendarAccountId @"accountId"
#define kCalendarSpaceId @"spaceId"
#define kCalendarEventId @"id"
#define kCalendarHeadPortrait @"senderLogo"
#define kCalendarName @"senderName"
#define kCalendarTitle @"title"
#define kCalendarContent @"content"
#define kCalendarCommentCount @"commentCount"
#define kCalendarVisiterCount @"vc"
#define kCalendarVisiter @"visitor"
#define kCalendarMemberCount @"partnerNum"
#define kCalendarCreateTime @"createTime"
#define kCalendarStartTime @"startTime"
#define kCalendarEndTime @"endTime"
#define kCalendarRemindTime @"remindTime"
#define kCalendarRemindMobile @"remindMobile"
#define kCalendarRemindType @"remindType"
#define kCalendarRemindFlag @"remindFlag"
#define kCalendarLat @"lat"
#define kCalendarLng @"lng"
#define kCalendarLocation @"location"
#define kCalendarJoinFlag @"joinFlag"
#define kCalendarNotificationFlag @"atFlag"
#define kCalendarShare @"privacy"
#define kCalendarShareGroupId @"groupId"
#define kCalendarNotificationIds @"rIds"
#define kCalendarNotification @"relativeAccountList"

//评论
#define kCalendarCommentId @"id"
#define kCalendarCommentContent @"content"
#define kCalendarCommentSenderAccId @"senderAccid"
//#define kCalendarCommentSenderId @"senderId"
#define kCalendarCommentHeadPortrait @"senderLogo"
#define kCalendarCommentName @"senderName"
#define kCalendarCommentCreateTime @"createTime"
#define kCalendarCommentEventId @"appId"
#define kCalendarCommentReceiverAccid @"receiverAccid"
#define kCalendarCommentReceiverId @"receiverId"

//邀请的成员列表
#define kCalendarPartnerId @"aid"
#define kCalendarPartnerName @"name"
#define kCalendarPartnerLogo @"logo"
#define kCalendarPartnerFlag @"joinFlag"

//每天的事件数量
#define kCalendarEventCount @"count"
#define kCalendarEventDate @"date" //格式：20130410


#endif
