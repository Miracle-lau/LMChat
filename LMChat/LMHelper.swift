//
//  LMHelper.swift
//  LMChat
//
//  Created by 刘明 on 16/2/26.
//  Copyright © 2016年 Ming. All rights reserved.
//

import UIKit
import Foundation

/// 提供 | 操作支持
func |<T : OptionSetType>(lhs: T, rhs: T) -> T {
    return lhs.union(rhs)
}

/// 为时间提供 - 操作支持
func -(lhs: NSDate, rhs: NSDate) -> NSTimeInterval {
    return lhs.timeIntervalSince1970 - rhs.timeIntervalSince1970
}

/// 让枚举支持 allZeros
extension OptionSetType where RawValue : BitwiseOperationsType {
    static var allZeros: Self {
        return self.init()
    }
}

/// 添加 build
class LMView : UIView {
    /// 序列化
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.build()
    }
    /// 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.build()
    }
    /// 构建
    func build() {
        // ...
    }
}

/// 添加build
class LMControl : UIControl {
    /// 序列化
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.build()
    }
    /// 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.build()
    }
    /// 构建
    func build() {
        // ...
    }
}

/// 添加build
class LMImageView : UIImageView {
    /// 序列化
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.build()
    }
    /// 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.build()
    }
    /// 初始化
    override init(image: UIImage?) {
        super.init(image: image)
        self.build()
    }
    /// 初始化
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        self.build()
    }
    /// 构建
    func build() {
        // ...
    }
}

/// 添加build
class LMTableViewCell : UITableViewCell {
    /// 序列化
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.build()
    }
    /// 初始化
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.build()
    }
    /// 构建
    func build() {
        // ...
    }
}

/// 添加build
class LMViewController : UIViewController {
    /// 序列化
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.build()
    }
    /// 初始化
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.build()
    }
    /// 构建
    func build() {
        // ...
    }
}

extension NSDate {
    /// 零
    class var zero: NSDate {
        return NSDate(timeIntervalSince1970: 0)
    }
    /// 现在
    class var now: NSDate {
        return NSDate()
    }
}
