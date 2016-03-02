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

    /// 弹出时候显示的视图
    var presentingView: UIView? {
        return nil
    }
    
    /// 显示
    func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, fromView: UIView?, completion: (() -> Void)?) {
        
        LMLog.trace()
        
        let src = self
        let dest = viewControllerToPresent
        let window = TransitionContext.window
        let context = TransitionContext()
        let mask = UIView()
        let tp = UIImageView()
        
        // 预加载
        dest.view.frame = src.view.bounds
        dest.modalTransitionContext = context
        
        // 配置
        context.toView = dest.presentingView
        context.fromView = fromView
        
        mask.frame = window.bounds
        mask.backgroundColor = dest.view.backgroundColor
        mask.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        tp.image = context.fromViewSnapshoot
        tp.backgroundColor = UIColor.clearColor()
        
        window.rootViewController = nil
        window.addSubview(mask)
        window.addSubview(tp)
        window.makeKeyAndVisible()
        
        // 计算位置 eg: (from: (119, 117.5, 135, 91) - to: (0, 177.2, 320, 213))
        let from = context.fromView!.convertRect(context.fromView!.bounds, toView: context.fromView?.window)
        let to = context.toView!.convertRect(context.toView!.bounds, toView: dest.view)
        
        LMLog.debug("will present view controller, from:\(from) to:\(to)")
        
        // 先不要显示遮罩层, 通过动画慢慢显示
        tp.frame = from
        mask.alpha = 0
        
        UIView.animateWithDuration(context.duration, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            
            tp.frame = to
            mask.alpha = 1
            
        }, completion: { s in
            // 不能在这里弹出, 会导致动画栈失衡
            dispatch_async(dispatch_get_main_queue()) {
                
                self.presentViewController(dest, animated: false, completion: {
                    
                    tp.removeFromSuperview()
                    mask.removeFromSuperview()
                    window.hidden = true
                    
                    completion?()
                    
                })
            }
        })
    }
    
    /// 消失
    func dismissViewControllerAnimated(flag: Bool, fromView: UIView?, completion: (() -> Void)?) {
    
        LMLog.trace()
        
        // TODO: 还有一个未处理的情况
        
        let src = self
        let window = TransitionContext.window
        let context = src.modalTransitionContext
        let mask = UIView()
        let tp = UIImageView()
        
        mask.frame = window.bounds
        mask.backgroundColor = src.view.backgroundColor
        mask.autoresizingMask = UIViewAutoresizing
        .FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        tp.image = context.toViewSnapshoot
        tp.backgroundColor = UIColor.clearColor()
        
        window.addSubview(mask)
        window.addSubview(tp)
        window.makeKeyAndVisible()
        
        // 计算位置
        let to = context.toView!.convertRect(context.toView!.bounds, toView: context.toView?.window)
        // 显示遮罩层
        tp.frame = to
        mask.alpha = 1
        // 关闭
        self.dismissViewControllerAnimated(false, completion: {
            
            dispatch_async(dispatch_get_main_queue()) {
                
                let from = context.fromView!.convertRect(context.fromView!.bounds, toView: context.fromView?.window)
            
                // 动画淡出
                UIView.animateWithDuration(context.duration, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                    
                        tp.frame = from
                        mask.alpha = 0
                    
                    }, completion: { s in
                        
                        tp.removeFromSuperview()
                        mask.removeFromSuperview()
                        window.hidden = true
                
                        completion?()
                })
            }
        })
    }

    // 转场环境
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
        w.windowLevel = UIWindowLevelAlert
        return w
    }()

}

let modalTransitionContextKey = unsafeAddressOf("modalTransitionContextKey")