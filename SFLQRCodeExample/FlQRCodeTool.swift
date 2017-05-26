//
//  FlQRCodeTool.swift
//  SFLQRCodeExample
//
//  Created by sufangliang on 2017/5/25.
//  Copyright © 2017年 sufangliang. All rights reserved.
//

import UIKit

class FlQRCodeTool: NSObject {
    
    /**
     *  生成二维码
     *
     *  @param formdata    需要生成二维码的数据
     *  @param imageWidth    图片的宽度
     *  @param logo   二维码中心logo(为nil时无logo)
     */
    static func generateWithDefaultQRCode(formdata : String , imageWidth : CGFloat ,logo:UIImage?) -> UIImage{
        
        //创建一个二维码的滤镜
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        
        // 恢复滤镜的默认属性
        qrFilter?.setDefaults()
        
        // 将字符串转换成
        let infoData =  formdata.data(using: .utf8)
        
        // 通过KVC设置滤镜inputMessage数据
        qrFilter?.setValue(infoData, forKey: "inputMessage")
        
        // 获得滤镜输出的图像
        let  outputImage = qrFilter?.outputImage
        
        // 设置缩放比例
        let scale = imageWidth / outputImage!.extent.size.width;
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let transformImage = qrFilter!.outputImage!.applying(transform)
        
        // 获取Image
        let image = UIImage(ciImage: transformImage)

        // 无logo时  返回普通二维码image
        guard let QRCodeLogo = logo else { return image }
        
        // logo尺寸与frame
        let logoWidth = image.size.width/4
        let logoFrame = CGRect(x: (image.size.width - logoWidth) /  2, y: (image.size.width - logoWidth) / 2, width: logoWidth, height: logoWidth)
        
        // 绘制二维码
        UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.main.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        // 绘制中间logo
        QRCodeLogo.draw(in: logoFrame)
        
        //返回带有logo的二维码
        let QRCodeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return QRCodeImage!

    }

}


