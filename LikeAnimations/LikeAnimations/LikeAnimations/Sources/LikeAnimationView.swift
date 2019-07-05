//
//  LikeAnimationView.swift
//  DouYinLikeAnimation
//
//  Created by Liu Chuan on 2019/3/15.
//  Copyright © 2019 LC. All rights reserved.
//

import UIKit

/// 喜欢类型
enum LikeType : Int {
    /// 点赞
    case GiveLikeType
    /// 取消赞
    case CancelLikeType
}

/// 点赞动画视图
class LikeAnimationView: UIView {
    
    /// 点赞完成回调闭包
    /// isLike: 是否点赞
    var completion: ((_ isLike: Bool) -> ())?
    
    /// 图片视图的宽度
    private let imagWidth = 40.0
       
    /// 是否喜欢
    var isLike : Bool = false
    
    /// 动画持续时间 (默认为: 0.5)
    var animationDurtion: TimeInterval = 0.5 {
        didSet {
            
        }
    }
    
    /// 三角形 圆圈颜色 (默认为: 红色)
    var shapeFillColor: UIColor = UIColor.red {
        didSet {
            
        }
    }
    
    /// 三角形半径 (默认为: 30)
    var triangleRadius: CGFloat = 30 {
        didSet {
            
        }
    }
    
    
    /// 取消点赞图片
    private lazy var cancelLikeImgView : UIImageView = {
        let imageView = UIImageView(image: UIImage(named:"ic_home_like_before"))
        imageView.frame = CGRect(x: 0, y: 0, width: imagWidth, height: imagWidth)
        imageView.tag = LikeType.CancelLikeType.rawValue
        imageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeAction(_:)))
        imageView.addGestureRecognizer(tap)
        
        return imageView
    }()
    
    /// 点赞图片
    private lazy var giveLikeImgView : UIImageView = {
        let imageView = UIImageView(image: UIImage(named:"ic_home_like_after"))
        imageView.frame = CGRect(x: 0, y: 0, width: imagWidth, height: imagWidth)
        imageView.tag = LikeType.GiveLikeType.rawValue
        imageView.isHidden = true                   // 默认隐藏: 未点赞状态
        imageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeAction(_:)))
        imageView.addGestureRecognizer(tap)
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 配置
    private func configure() {
        addSubview(giveLikeImgView)
        addSubview(cancelLikeImgView)
//        let tap = UITapGestureRecognizer(target: self, action: #selector(likeAction(_:)))
//        addGestureRecognizer(tap)
        
        animationDurtion = 0.5
        triangleRadius = 30
        shapeFillColor = UIColor.red
    }
    
}


//MARK: - 点赞具体处理
extension LikeAnimationView {
    
    /// 点赞动作处理
    /// - Parameter tapGestureRecognizer: 单击手势
    @objc private func likeAction(_ tapGestureRecognizer: UITapGestureRecognizer?) {
        isUserInteractionEnabled = false
        if tapGestureRecognizer?.view?.tag == LikeType.GiveLikeType.rawValue {
            cancelLikeAction()  //取消赞
        }else {
            giveLikeAction()  //点赞
        }
        if let callback = completion {
            callback(tapGestureRecognizer?.view?.tag == LikeType.CancelLikeType.rawValue)
        }
       
    }
    
    
    /// 取消
    func cancelLikeAction() {
         /* 取消点赞动画分解
         *  点赞图片由外向内慢慢消失
         */
        self.animationChangeLikeType(LikeType.CancelLikeType)
    }
    
    
    /// 点赞
    func giveLikeAction() {
        
        /* 点赞动画分解
        * 1. 6个倒三角形从中心向外扩散
        * 2. 三角全部展开之后由内向外消失
        * 3. 心形点赞图片 从小扩大在收缩动画
        * 4. 波纹慢慢扩大至心型图片圆周，再慢慢消失
        */
        
        // 1.创建三角形
        createTrigonsAnimtion()
        
        // 2.圆圈扩大消失
        createCircleAnimation()
        
        // 3.改变状态
        animationChangeLikeType(LikeType.GiveLikeType)
    }
    
    
    /// 改变状态
    func animationChangeLikeType(_ type: LikeType) {
        
        if type == LikeType.GiveLikeType {
            
            // 三角形动画之后 进行缩放 抖动效果 置为点赞效果
            cancelLikeImgView.isHidden = true
            giveLikeImgView.isHidden = false
            
            UIView.animateKeyframes(withDuration: animationDurtion, delay: 0.0, options: .layoutSubviews, animations: {
                /*  参数1:关键帧开始时间
                    参数2:关键帧占用时间比例
                    参数3:到达该关键帧时的属性值
                 */
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5 * self.animationDurtion, animations: {
                    self.giveLikeImgView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.5 * self.animationDurtion, relativeDuration: 0.5 * self.animationDurtion, animations: {
                    self.giveLikeImgView.transform = .identity
                })
            }) { finished in
                self.isUserInteractionEnabled = true
            }
        }else {
            //取消点赞
            cancelLikeImgView.isHidden = false
            bringSubviewToFront(giveLikeImgView)
            giveLikeImgView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: {
                self.giveLikeImgView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }) { finished in
                self.giveLikeImgView.isHidden = true
                self.giveLikeImgView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.isUserInteractionEnabled = true
            }
        }
    }
    
    
    /// 创建三角形动画
    func createTrigonsAnimtion() {
        
        /// 三角形的个数
        let TriangleCount = 6
        
        // 三角形大小
        
        for i in 0 ..< TriangleCount {
            
            // 绘制三角形的图层
            let shapeLayer = CAShapeLayer()
            shapeLayer.position = giveLikeImgView.center
            shapeLayer.fillColor = shapeFillColor.cgColor
            
            //三角形
            let startPath = UIBezierPath()
            startPath.move(to: CGPoint(x: -2, y: triangleRadius))
            startPath.addLine(to: CGPoint(x: 2, y: triangleRadius))
            startPath.addLine(to: CGPoint(x: 0, y: 0))
            shapeLayer.path = startPath.cgPath
            
            //旋转图层，形成圆形
            //因为一共是6个，均等应该是反转60度 所以是.pi/3 ,围绕Z轴旋转
            shapeLayer.transform = CATransform3DMakeRotation(CGFloat(Double.pi / 3.0 * Double(i)), 0, 0, 1.0)
            layer.addSublayer(shapeLayer)
            
            //使用动画组来解决三角形 出现跟消失】
            let groupAnimation = CAAnimationGroup()
            groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
            groupAnimation.duration = animationDurtion
            groupAnimation.fillMode = .forwards
            groupAnimation.isRemovedOnCompletion = false

            
            let scaleAnimtion = CABasicAnimation(keyPath: "transform.scale")
            //缩放时间占20%
            scaleAnimtion.duration = animationDurtion * 0.2
            scaleAnimtion.fromValue = 0
            scaleAnimtion.toValue = 1

            //绘制三角形结束  一条直线
            let endPath = UIBezierPath()
            endPath.move(to: CGPoint(x: -2, y: triangleRadius))
            endPath.addLine(to: CGPoint(x: 2, y: triangleRadius))
            endPath.addLine(to: CGPoint(x: 0, y: triangleRadius))

            
            let pathAnimtion = CABasicAnimation(keyPath: "path")
            pathAnimtion.beginTime = animationDurtion * 0.2
            pathAnimtion.duration = animationDurtion * 0.8
            pathAnimtion.fromValue = startPath.cgPath
            pathAnimtion.toValue = endPath.cgPath

            groupAnimation.animations = [scaleAnimtion, pathAnimtion]
            shapeLayer.add(groupAnimation, forKey: nil)
        }
    }
    
    
    /// 创建圆圈扩大消失动画
    func createCircleAnimation() {
        
        //创建背景圆环
        let circleLayer = CAShapeLayer()
        circleLayer.frame = bounds
        //清空填充色
        circleLayer.fillColor = UIColor.clear.cgColor
        //设置画笔颜色 即圆环背景色
        circleLayer.strokeColor = shapeFillColor.cgColor
        circleLayer.lineWidth = 1
        //设置画笔路径
        let path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: triangleRadius, startAngle: -.pi/2, endAngle: -.pi/2 + .pi * 2, clockwise: true)
        
        // path 决定layer将被渲染成何种形状
        circleLayer.path = path.cgPath
        layer.addSublayer(circleLayer)

        
        //使用动画组来解决圆圈从小到大 -->消失
        let groupAnimation = CAAnimationGroup()
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        let groupDurtion: TimeInterval = animationDurtion * 0.8
        groupAnimation.duration = CFTimeInterval(groupDurtion)
        groupAnimation.fillMode = .forwards
        groupAnimation.isRemovedOnCompletion = false

        let scaleAnimtion = CABasicAnimation(keyPath: "transform.scale")
        
        //放大时间占80%
        scaleAnimtion.duration = groupDurtion * 0.8
        scaleAnimtion.fromValue = 0
        scaleAnimtion.toValue = 1

        
        let widthStartAnimtion = CABasicAnimation(keyPath: "lineWidth")
        widthStartAnimtion.beginTime = 0
        widthStartAnimtion.duration = groupDurtion * 0.8
        widthStartAnimtion.fromValue = 1
        widthStartAnimtion.toValue = 3

        let widthEndAnimtion = CABasicAnimation(keyPath: "lineWidth")
        widthEndAnimtion.beginTime = groupDurtion * 0.8
        widthEndAnimtion.duration = groupDurtion * 0.2
        widthEndAnimtion.fromValue = 3
        widthEndAnimtion.toValue = 0

      
        groupAnimation.animations = [scaleAnimtion, widthStartAnimtion, widthEndAnimtion]
        circleLayer.add(groupAnimation, forKey: "circleLayerAnimtion")

        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(groupDurtion * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            circleLayer.removeAnimation(forKey: "circleLayerAnimtion")
            circleLayer.removeFromSuperlayer()
        })
    }
    
}
