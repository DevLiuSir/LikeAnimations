//
//  ViewController.swift
//  LikeAnimations
//
//  Created by Liu Chuan on 2020/3/16.
//  Copyright © 2020 Liu Chuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var likeView: LikeAnimationView = {
        let likeView = LikeAnimationView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        likeView.center = view.center
        likeView.animationDurtion = 0.4
        likeView.shapeFillColor = UIColor.red
        likeView.completion = { isLike in
            print("\(isLike ? "点赞" : "取消赞")")
        }
        return likeView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        view.addSubview(likeView)
    }

}

//MARK: - 双击屏幕点赞
extension ViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        /// 处理触摸事件 冲突问题
        guard let touch = (touches as NSSet).anyObject() as? UITouch else {return}
        if touch.tapCount <= 1 {
            super.touchesBegan(touches, with: event)
        } else {
            print("双击点赞.........")
            LikeAnimationTools.startWithTouch(touches)
        }
    }
}
