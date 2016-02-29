//
//  UIViewController+Transition.swift
//  LMChat
//
//  Created by 刘明 on 16/2/26.
//  Copyright © 2016年 Ming. All rights reserved.
//

import UIKit
import Foundation

extension UIView {

    func snapShot() -> UIImage! {
    
        // 开启上下文
        UIGraphicsBeginImageContext(bounds.size)
        // layer 渲染
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        // 获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        
        return image
    }
    
}

// MARK: - 自定义弹出
extension UIViewController {

    var presentingView: UIView? {
        return nil
    }
    
    func presentViewController(viewControllerToPresent:UIViewController, animated flag: Bool, fromView: UIView?, completion: (() -> Void)?) {
    
        SIMLog.trace()
        
        
        let src = self
        let dest = viewControllerToPresent
        let window = transi
    
    
    }






}


class TransitionContext: NSObject {

    var duration: NSTimeInterval = 0.25
    
    weak var fromView: UIView?
    weak var toView: UIView?
    
    var fromViewSnapshoot: UIImage! {
        
    }


}

