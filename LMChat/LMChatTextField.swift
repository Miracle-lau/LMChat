//
//  LMChatTextField.swift
//  LMChat
//
//  Created by 刘明 on 16/3/2.
//  Copyright © 2016年 Ming. All rights reserved.
//

import UIKit
import SnapKit

/// 聊天输入栏 (将输入栏整体作为 TextField 构建, 因此方法实现参考 UITextField 命名)
class LMChatTextField: LMView {
    
    /// 构建
    override func build() {
        super.build()
        
        let line = LMChatLine()
        let items = (leftItems as [UIView]) + [textView] + (rightItems as [UIView])
        
        // configs
        textView.font = UIFont.systemFontOfSize(16)
        textView.backgroundColor = UIColor.clearColor()
        textView.scrollIndicatorInsets = UIEdgeInsetsMake(2, 0, 2, 0)
        textView.returnKeyType = .Send
        textView.delegate = self
        
        backgroundView.image = LMChatImageManager.defaultInputBackground
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        // line使用am
        line.frame = CGRectMake(0, 0, bounds.width, 1)
        line.contentMode = .Top
        line.autoresizingMask = .FlexibleWidth | .FlexibleBottomMargin
        line.tintColor = UIColor(hex: 0xBDBDBD)
        
        // add view
        addSubview(backgroundView)
        for item in items {
            // disable translates
            item.translatesAutoresizingMaskIntoConstraints = false
            // add
            addSubview(item)
            // add tag, if need
            if let btn = item as? LMChatTextFieldItem {
                btn.addTarget(self, action: "OnItem:", forControlEvents: .TouchUpInside)
            }
        }
        addSubview(line)
        
        // 添加约束
        backgroundView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(textView).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
        for idx in 0 ..< items.count {
            let item = items[idx]
            // top
            if item is UITextView { // is textView
                item.snp_makeConstraints(closure: { (make) -> Void in
                    make.top.equalTo(self.snp_top).offset(5)
                })
            } else {
                item.snp_makeConstraints(closure: { (make) -> Void in
                    make.top.equalTo(self.snp_top).offset(6)
                })
            }
            // left
            if idx == 0 { // is First
                item.snp_makeConstraints(closure: { (make) -> Void in
                    make.left.equalTo(self.snp_left).offset(5)
                })
            } else {
                let pt = items[idx - 1]
                let fix = item.isKindOfClass(pt.dynamicType) ? 0 : 5
                item.snp_makeConstraints(closure: { (make) -> Void in
                    make.left.equalTo(pt.snp_right).offset(fix)
                })
            }
            // right
            if idx == items.count - 1 { // is end
                item.snp_makeConstraints(closure: { (make) -> Void in
                    make.right.equalTo(self.snp_right).offset(-5)
                })
            }
            // bottom
            if item is UITextView { // is textView
                item.snp_makeConstraints(closure: { (make) -> Void in
                    make.bottom.equalTo(self.snp_bottom).offset(-5)
                })
            } else {
                item.snp_makeConstraints(closure: { (make) -> Void in
                    make.width.equalTo(34)
                    make.height.equalTo(34)
                })
            }
        }
    }
    
    /// 当前焦点
    override func isFirstResponder() -> Bool {
        return super.isFirstResponder() || self.textView.isFirstResponder()
    }
    
    /// 放弃焦点
    override func resignFirstResponder() -> Bool {
        if self.selectedItem != nil {
            self.selectedItem = nil
            self.selectedStyle = .None
        }
        if self.isFirstResponder() {
            return super.resignFirstResponder() || self.textView.resignFirstResponder()
        }
        return false
    }
    
    /// 重新取得焦点
    override func becomeFirstResponder() -> Bool {
        return self.textView.becomeFirstResponder()
    }
    
    /// 内置大小 (重要属性, 默认无内置大小, 界面上不会显示任何东西)
    override func intrinsicContentSize() -> CGSize {
        if textView.contentSize.height > maxHeight {
            return CGSizeMake(bounds.width, bounds.height)
        }
        return CGSizeMake(bounds.width, max(textView.contentSize.height, 36) + 10)
    }
    
    /// 最大高度
    var maxHeight: CGFloat = 80
    /// 代理
    weak var delegate: LMChatTextFieldDelegate?
    
    
    
    
    var selectedStyle: LMChatTextFieldItemStyle = .None {
        didSet {
            self.delegate?.chatTextField?(self, didSelectedItem: selectedStyle.rawValue)
        }
    }

    private var selectedItem: LMChatTextFieldItem? {
        willSet {
            self.selectedItem?.actived = false
        }
        didSet {
            self.selectedItem?.actived = true
        }
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


/// 代理
@objc protocol LMChatTextFieldDelegate: NSObjectProtocol {
    
    optional func chatTextField(chatTextField: LMChatTextField, didSelectedItem item: Int)
    
    
}
