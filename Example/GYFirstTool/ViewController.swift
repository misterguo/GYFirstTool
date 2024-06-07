//
//  ViewController.swift
//  GYFirstTool
//
//  Created by 18332122278 on 06/06/2024.
//  Copyright (c) 2024 18332122278. All rights reserved.
//

import UIKit
import GYFirstTool
import QMUIKit

class ViewController: GYBaseVc {

    let v = UIView(backgroundColor: .orange, cornerRadius: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        v.drawCircularProgressBar(nomalColor: .red, selectColor: .green, lineWidth: 2, maxValue: 1, selectValue: 0.3)
//    }
    
    func createUI() {
        view.addSubview(v)
        v.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        }
        
        let slider = GradientsSlider()
        slider.trackHeight = 25
        slider.startColor = .green
        slider.endColor = .blue
        v.addSubview(slider)
        slider.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(UIEdgeInsets(top: 50, left: 20, bottom: 0, right: 20))
            make.height.equalTo(30)
        }
        let b = timeButton(title: "time", titleFont: FontMedium(14), titleColor: .black, cornerRadius: 12, backgroundColor:.blue)
        b.getCodeSuccess(second: 20, display: "agree", block: nil)
        b.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        v.addSubview(b)
        b.snp.makeConstraints { make in
            make.top.equalTo(slider.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 120, height: 35))
        }
    }
    
    @objc func btnAction(_ sender:UIButton) {
        rateApp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

