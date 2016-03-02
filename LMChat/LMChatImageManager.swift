//
//  LMChatImageManager.swift
//  LMChat
//
//  Created by 刘明 on 16/3/2.
//  Copyright © 2016年 Ming. All rights reserved.
//

import UIKit

class LMChatImageManager: NSObject {
    
    static var messageFail = UIImage(named: "lmchat_message_fail")
    static var messageSuccess = UIImage(named: "lmchat_message_succ")
    
    static var images_emoji_delete_nor = UIImage(named: "lmchat_button_delete_nor")
    static var images_emoji_delete_press = UIImage(named: "lmchat_button_delete_press")
    
    static var imageDownloadFail = UIImage(named: "lmchat_images_fail")
    static var defaultImage = UIImage(named: "lmchat_images_default")
    
    static var images_emoji_preview = UIImage(named: "lmchat_images_emoji_preview")
    
    /// 默认聊天背景
    static var defaultBackground = UIImage(named: "lmchat_background_default")
    /// 默认头像
    static var defaultPortrait1 = UIImage(named: "lmchat_portrait_default1")
    static var defaultPortrait2 = UIImage(named: "lmchat_portrait_default2")
    
    static var defaultBubbleRecive = UIImage(named: "lmchat_bubble_recive")
    static var defaultBubbleSend = UIImage(named: "lmchat_bubble_send")
    
    static var defaultInputBackground = UIImage(named: "chat_bottom_textfield")
    
    static var inputItemImages: [LMChatTextFieldItemStyle: (n: UIImage?, h: UIImage?)] = [
        .Keyboard   : (n: UIImage(named: "chat_bottom_keyboard_nor"),   h: UIImage(named: "chat_bottom_keyboard_press")),
        .Voice      : (n: UIImage(named: "chat_bottom_voice_nor"),   h: UIImage(named: "chat_bottom_voice_press")),
        .Emoji      : (n: UIImage(named: "chat_bottom_smile_nor"),   h: UIImage(named: "chat_bottom_smile_press")),
        .Tool       : (n: UIImage(named: "chat_bottom_up_nor"),   h: UIImage(named: "chat_bottom_up_press"))
    ]

}
