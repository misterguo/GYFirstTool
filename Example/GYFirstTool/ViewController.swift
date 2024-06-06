//
//  ViewController.swift
//  GYFirstTool
//
//  Created by 18332122278 on 06/06/2024.
//  Copyright (c) 2024 18332122278. All rights reserved.
//

import UIKit
import GYFirstTool

class ViewController: GYBaseVc {

    let v = UIView(backgroundColor: .orange, cornerRadius: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        v.drawCircularProgressBar(nomalColor: .red, selectColor: .green, lineWidth: 2, maxValue: 1, selectValue: 0.3)
    }
    
    func createUI() {
        view.addSubview(v)
        v.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

