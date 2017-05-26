//
//  GeneorQRCodeVC.swift
//  SFLQRCodeExample
//
//  Created by sufangliang on 2017/5/25.
//  Copyright © 2017年 sufangliang. All rights reserved.
//

import UIKit

class GeneorQRCodeVC: UIViewController {

    @IBOutlet weak var qrImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 一行代码调用生成二维码
      qrImg.image = FlQRCodeTool.generateWithDefaultQRCode(formdata: "www.baidu.com", imageWidth: 100, logo: UIImage.init(named: "yaoming"))
    }

 
}
