//
//  LMChatTextField.swift
//  LMChat
//
//  Created by 刘明 on 16/3/2.
//  Copyright © 2016年 Ming. All rights reserved.
//

import UIKit

/// 聊天输入栏
class LMChatTextField: LMView {
    
    /// 构建
    override func build() {
        super.build()
        
        let line = LMChatLine()
        let items = ()
        
        
    }
    
    
    
    
    private lazy var textView = UITextView()
    private lazy var backgroundView = UIImageView()
    
    private lazy var leftItems: [LMChatTextFieldItem] = [
        LMChatTextFieldItem(style: .Voice)
    ]
    private lazy var rightItems: [LMChatTextFieldItem] = [
        LMChatTextFieldItem(style: .Emoji),
        LMChatTextFieldItem(style: .Tool)
    ]
    
}

// MARK: - Type
extension LMChatTextField {

    /// 输入输的选项
    class LMChatTextFieldItem: UIButton {
        
        /// 初始化
        required init?(coder aDecoder: NSCoder) {
            self.style = .Keyboard
            super.init(coder: aDecoder)
            self.update(self.style)
            self.tag = self.style.rawValue
        }
        
        init(style: LMChatTextFieldItemStyle) {
            self.style = style
            super.init(frame: CGRectZero)
            self.update(self.style)
            self.tag = style.rawValue
        }
        
        /// 按钮类型
        var style: LMChatTextFieldItemStyle {
            willSet {
                update(actived ? .Keyboard : newValue)
            }
        }
        
        /// 激活的
        var actived: Bool = false {
            willSet {
                update(newValue ? .Keyboard : style)
            }
        }
        
        /// 更新
        private func update(style: LMChatTextFieldItemStyle) {
            if let item = LMChatImageManager.inputItemImages[style] {
                setImage(item.n, forState: .Normal)
                setImage(item.h, forState: .Highlighted)
                
                // duang ???
                let ani = CATransition()
                
                ani.duration = 0.25
                ani.fillMode = kCAFillModeBackwards
                ani.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                ani.type = kCATransitionFade
                ani.subtype = kCATransitionFromTop
                
                layer.addAnimation(ani, forKey: "s")
            }
        }
    }
}

extension LMChatTextField: UITextViewDelegate {
    // 将要编辑文本
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return true
    }
}

enum LMChatTextFieldItemStyle: Int {
    case None       = 0x0000
    case Keyboard   = 0x0100
    case Voice      = 0x0101
    case Emoji      = 0x0102
    case Tool       = 0x0103
}



