//
//  LikeAnimationTools.swift
//  LikeAnimation
//
//  Created by Liu Chuan on 2019/3/15.
//  Copyright © 2019 LC. All rights reserved.
//

import UIKit

/// 点赞动画工具类
struct LikeAnimationTools {
    
    /// 自定义图片的名字
    static private let imageNanme = "icon_home_biglike"
    /// 自定义图片的宽度
    static private let width = 80
    /// 自定义图片的高度
    static private let height = 80
    
    /// 系统的触摸事件 touch
    ///
    /// - Parameter touches:
    static func startWithTouch(_ touches: Set<UITouch>) {
        guard let touch = (touches as NSSet).anyObject() as? UITouch else {return}
        guard touch .tapCount > 0 else {return}
        let point = touch.location(in: touch.view)
        let image = UIImage(named: imageNanme)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.center = point
        touch.view?.addSubview(imageView)
        
        imageView.touchLikeAnimation()
    }
    
    /// 点击触发动画
    ///
    /// - Parameter tap:
    static func startAnimationWithTap(_ tap: UITapGestureRecognizer) {
        guard let tapView = tap.view else {return}
        
        let point = tap.location(in: tapView)
        let image = UIImage(named: imageNanme)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.center = point
        tapView.addSubview(imageView)

        imageView.touchLikeAnimation()
    }
}
//MARK: - 触摸点赞动画 (双击点击效果)
extension UIView {
    
    /// 触摸点赞动画
    func touchLikeAnimation() {
           
        // 左右随机显示
        var leftOrRight = Int(arc4random() % 2)
        leftOrRight = leftOrRight == 1 ? leftOrRight : -1
        transform = transform.rotated(by: CGFloat(Double.pi/9.00  * Double(leftOrRight)))
           
        // 出现的时候回弹一下
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = self.transform.scaledBy(x: 1.2, y: 1.2)
        }) { (finished) in
            self.transform = self.transform.scaledBy(x: 0.8, y: 0.8)
            self.topAnimation()      // 放大漂移
        }
    }
 
    /// 向上动画 ( 放大、漂移、透明 )
    func topAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0.3, options: .allowUserInteraction, animations: {
            var viewRect = self.frame
            viewRect.origin.y -= 100
            self.frame = viewRect
            self.transform = self.transform.scaledBy(x: 1.8, y: 1.8)
            self.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
}

