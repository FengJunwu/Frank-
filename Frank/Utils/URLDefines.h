//
//  URLDefines.h
//  Frank
//
//  Created by fengjunwu on 2019/6/1.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#ifndef URLDefines_h
#define URLDefines_h

#if DEBUG

#define EMAPNSFileNmae @"aps_dev"

#define URL_DOMAIN @"http://39.104.28.75:8080/"
#define URL_WEB @"https://huke.tv/app/"

#else

#define EMAPNSFileNmae @"aps"
#define URL_DOMAIN @"http://39.104.28.75:8080/"
#define URL_WEB @"https://huke.tv/app/"

#endif

/**
 获取角色列表信息

 @return <#return value description#>
 */
#define URL_character_list @"character/list"


/**
 音频资源列表

 @return
 */
#define URL_audio_list @"audio/list"


/**
 语音识别配置文件

 @return <#return value description#>
 */
#define URL_config_voice @"config/voice"


/**
 获取视频列表

 @return <#return value description#>
 */
#define URL_video_list @"video/list"


/**
 获取系统通知（拉取服务器）

 @return <#return value description#>
 */
#define URL_notification_list @"notification/list"



#endif /* URLDefines_h */
