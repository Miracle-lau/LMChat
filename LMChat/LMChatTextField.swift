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
    
    /// 内容
    var text: String! {
        set {
            self.textView.text = newValue
            self.textViewDidChange(textView)
        }
        get {
            return self.textView.text
        }
    }
    
    /// 是否开启
    var enabled: Bool = true {
        willSet {
            // 关闭输入
            self.backgroundView.highlighted = newValue
            self.textView.userInteractionEnabled = newValue
            
            for view in self.subviews {
                if let btn = view as? UIButton {
                    btn.enabled = newValue
                }
            }
        }
    }
    
    /// 当前选中的
    var selectedStyle: LMChatTextFieldItemStyle = .None {
        didSet {
            self.delegate?.chatTextField?(self, didSelectedItem: selectedStyle.rawValue)
        }
    }
    
    var contentSize: CGSize {
        return self.textView.contentSize
    }
    
    var contentOffset: CGPoint {
        return self.textView.contentOffset
    }
    
    /// 最大高度
    var maxHeight: CGFloat = 80
    /// 代理
    weak var delegate: LMChatTextFieldDelegate?
    
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
    /// 将要编辑文本
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if delegate?.chatTextFieldShouldBeginEditing?(self) ?? true {
            // 取消选中
            self.selectedItem = nil
            self.selectedStyle = .Keyboard
            // ok
            return true
        }
        return false
    }
    /// 已经开始编辑
    func textViewDidBeginEditing(textView: UITextView) {
        delegate?.chatTextFieldDidBeginEditing?(self)
    }
    /// 将要结束
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if delegate?.chatTextFieldShouldEndEditing?(self) ?? true {
            return true
        }
        return false
    }
    /// 文本将要改变
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if delegate?.chatTextField?(self, shouldChangeCharactersInRange: range, replacementString: text) ?? true {
            // 换行
            if text == "\n" {
                return self.delegate?.chatTextFieldShouldReturn?(self) ?? true
            }
            // clear
            if text.isEmpty {
                return self.delegate?.chatTextFieldShouldClear?(self) ?? true
            }
            // 其他
            return true
        }
        return false
    }
    /// 文本已经改变
    func textViewDidChange(textView: UITextView) {
        // 必须要先更新一下, 否则高度计算不准确
        self.textView.layoutIfNeeded()
        let src = textView.bounds.height
        let dst = textView.contentSize.height
        // 只有不同才会调整
        if src != dst {
            if textView.contentSize.height < maxHeight {
                LMLog.trace("src: \(src), dst: \(dst)")
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    // 重新计算内置尺寸
                    self.invalidateIntrinsicContentSize()
                    self.layoutIfNeeded()
                    self.superview?.layoutIfNeeded()
                })
                // 更新 offset
                textView.setContentOffset(CGPointZero, animated: true)
                // 大小发生了改变, 通知
                delegate?.chatTextFieldContentSizeDidChange?(self)
            }
        }
        // 通知
        delegate?.chatTextFieldDidChange?(self)
    }
    /// 滚动到最后
    func scrollViewToBottom() {
        LMLog.trace()
        let ch = textView.contentSize.height
        let bh = textView.bounds.height
        let py = textView.contentOffset.y
        if ch - bh > py {
            textView.setContentOffset(CGPointMake(0, ch - bh), animated: true)
        }
    }
}

// MARK: - Event
extension LMChatTextField {
    /// 选项
    func onItem(sender: LMChatTextFieldItem) {
        if sender.actived {
            self.selectedItem = nil
            self.selectedStyle = .Keyboard
            self.textView.becomeFirstResponder()
        } else {
            self.selectedItem = sender
            self.selectedStyle = sender.style
            self.textView.resignFirstResponder()
        }
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
    
    optional func chatTextFieldShouldBeginEditing(chatTextField: LMChatTextField) -> Bool
    optional func chatTextFieldDidBeginEditing(chatTextField: LMChatTextField)
    
    optional func chatTextFieldShouldEndEditing(chatTextField: LMChatTextField) -> Bool
    optional func chatTextFieldDidEndEditing(chatTextField: LMChatTextField)
    
    optional func chatTextFieldDidChange(chatTextField: LMChatTextField)
    optional func chatTextField(chatTextField: LMChatTextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    
    optional func chatTextFieldContentSizeDidChange(chatTextField: LMChatTextField)
    
    optional func chatTextFieldShouldClear(chatTextField: LMChatTextField) -> Bool
    optional func chatTextFieldShouldReturn(chatTextField: LMChatTextField) -> Bool
    
}
