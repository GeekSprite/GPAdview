//
//  GPAdview.swift
//  GPAdviewDemo
//
//  Created by liuxj on 2017/1/6.
//  Copyright © 2017年 XRA. All rights reserved.
//

import UIKit


/// 页面启动广告页
class GPAdview: UIView{
    
    public  var showDuration = 3
    private var countBtn: UIButton?
    private var complete: (() -> Void)?
    private var GP_WindowBounds = UIScreen.main.bounds

    /// 转场动画时间
    
    private var TY_TransitionDuration = 0.7
    private lazy var KMainWindow: UIWindow = {
        return  (UIApplication.shared.delegate?.window)!
    }()!
    
    private lazy var countTimer: Timer = {
        let t = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        return t
    }()
    
    
    init(imgUrl: URL?, imgClick:@escaping () -> Void, complete:@escaping () -> Void) {
        super.init(frame: GP_WindowBounds)
        self.complete = complete
        self.backgroundColor = UIColor.white
        let adView = UIImageView.init(frame: self.bounds)
        adView.isUserInteractionEnabled = true
        adView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismiss)))
    
        
        if let url = imgUrl {
            var imgData: Data?
            adView.image = UIImage.init(named: getLaunchImage())
            DispatchQueue.global().async {
               try? imgData = Data.init(contentsOf: url)
                if imgData != nil {
                    let img = UIImage.init(data: imgData!)
                    DispatchQueue.main.async {
                        adView.image = img
                    }
                }
            }
        }

        self.addSubview(adView)
        
        let btnW: CGFloat = 60.0
        let btnH: CGFloat = 30.0
        countBtn = UIButton.init(frame: CGRect.init(x: GP_WindowBounds.width - btnW - 24, y: btnH, width: btnW, height: btnH))
        countBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        countBtn?.setTitleColor(UIColor.white, for: .normal)
        countBtn?.backgroundColor = UIColor.init(red: 38.0/255.0, green: 38.0/255.0, blue: 38.0/255.0, alpha: 0.6)
        countBtn?.layer.cornerRadius = 4.0
        self.addSubview(countBtn!)
        countBtn?.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    /// 显示广告页
    func show() {
        countBtn?.setTitle("跳过 \(showDuration)S", for: .normal)
        startTimer()
        KMainWindow.addSubview(self)
    }
    
    private func startTimer(){
        let _ = countTimer
    }
    
    @objc func countDown()  {
        showDuration -= 1
        countBtn?.setTitle("跳过 \(showDuration)S", for: .normal)
        if showDuration < 1 {
            dismiss()
        }
    }
    
    @objc private func dismiss(){
        showDuration = 0
        countTimer.invalidate()
        let transition = CATransition()
        transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = "oglFlip"
        transition.subtype = kCATransitionFromLeft
        transition.duration = TY_TransitionDuration
        self.removeFromSuperview()
        if (complete != nil) {
            complete!()
        }
        KMainWindow.layer.add(transition, forKey: "dismiss")
    }
    
    
    /// 获取启动图
    ///
    /// - Returns: 获得到当前启动图的名字
    private func getLaunchImage() -> String{
        let viewOrientation = "Portrait"
        let imagesDict = Bundle.main.infoDictionary?["UILaunchImages"] as! [[String:Any]]
        for  dic in imagesDict{
            let imgSize = CGSizeFromString(dic["UILaunchImageSize"] as! String)
            if GP_WindowBounds.size.equalTo(imgSize) && viewOrientation == (dic["UILaunchImageOrientation"] as! String){
                return  dic["UILaunchImageName"] as! String
            }
        }
        return ""
    }
    
   
    
}
