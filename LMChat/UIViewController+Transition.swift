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
        
        
//        let src = self
//        let dest = viewControllerToPresent
//        let window = TransitionContext.window
//        let context = src.modalTransitionContext
//        let mask = UIView()
        
    
    
    }




    var modalTransitionContext: TransitionContext! {
        set {
            self.willChangeValueForKey("modalTransitionContext")
            objc_setAssociatedObject(self, modalTransitionContextKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.didChangeValueForKey("modalTransitionContext")
        
        }
        get {
            return objc_getAssociatedObject(self, modalTransitionContextKey) as? TransitionContext
        }
    }

}


class TransitionContext: NSObject {

    var duration: NSTimeInterval = 0.25
    
    weak var fromView: UIView?
    weak var toView: UIView?
    
    var fromViewSnapshoot: UIImage! {
        // 如果本来就是 imageview, 无需生成
        if let v = fromView as? UIImageView {
            if let img = v.image ?? toViewSnapshoot {
                return img
            }
        }
        // 打个快照
        return fromView?.snapShot()
    }
    
    var toViewSnapshoot: UIImage! {
        // 如果本来就是 imageview, 无需生成
        if let v = toView as? UIImageView {
            if let img = v.image {
                return img
            }
        }
        return toView?.snapShot()
    }
    
    // TODO: 因为是直接使用addSubview到window, 所以转屏有问题. 有时间再处理
    static var window: UIWindow = {
        let w = UIWindow(frame: UIScreen.mainScreen().bounds)
        w.windowLevel = UIWindowLevelStatusBar + 10
        return w
    }()

}

let modalTransitionContextKey = unsafeAddressOf("modalTransitionContextKey")