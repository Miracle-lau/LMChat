//
//  LMChatViewController.swift
//  LMChat
//
//  Created by 刘明 on 16/3/2.
//  Copyright © 2016年 Ming. All rights reserved.
//

import UIKit

class LMChatViewController: LMViewController {
    
    /// 初始化
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }
    
    // TODO: 初始化会话
    
    /// 释放
    deinit {
        LMLog.trace()
        // TODO: 移除通知
        
    }
    
    /// 构建
    override func build() {
        LMLog.trace()
        
        super.build()
        
        // TODO: 构建消息
        // self.buildOfMessage
    }
    
    /// 加载完成
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置背景
        view.backgroundColor = UIColor.clearColor()
        // view.layer.contents =
        // view.layer.contentsGravity = 
        view.layer.masksToBounds = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    
    // private(set) lazy var textField =
    
    
    
    
}
