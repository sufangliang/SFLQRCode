//
//  UIImage+QRCode.swift
//  SFLQRCodeExample
//
//  Created by sufangliang on 2017/5/25.
//  Copyright © 2017年 sufangliang. All rights reserved.
//

import UIKit

extension  UIImage{
    //3.获取圆角图片(带边框)
    func getRoundRectImage(size:CGFloat,radius:CGFloat,borderWidth:CGFloat?,borderColor:UIColor?) -> UIImage
    {
        let scale = self.size.width / size ;
        
        //初始值
        var defaultBorderWidth : CGFloat = 0
        var defaultBorderColor = UIColor.clear
        
        if let borderWidth = borderWidth { defaultBorderWidth = borderWidth * scale }
        if let borderColor = borderColor { defaultBorderColor = borderColor }
        
        let radius = radius * scale
        let react = CGRect(x: defaultBorderWidth, y: defaultBorderWidth, width: self.size.width - 2 * defaultBorderWidth, height: self.size.height - 2 * defaultBorderWidth)
        
        //绘制图片设置
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        
        let path = UIBezierPath(roundedRect:react , cornerRadius: radius)
        
        //绘制边框
        path.lineWidth = defaultBorderWidth
        defaultBorderColor.setStroke()
        path.stroke()
        
        path.addClip()
        
        //画图片
        draw(in: react)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!;
        
    }
    
}
