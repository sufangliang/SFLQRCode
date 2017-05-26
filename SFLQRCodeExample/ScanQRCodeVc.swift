//
//  ScanQRCodeVc.swift
//  SFLQRCodeExample
//
//  Created by sufangliang on 2017/5/25.
//  Copyright © 2017年 sufangliang. All rights reserved.
//

import UIKit
import AVFoundation

class ScanQRCodeVc: UIViewController {
    
    @IBOutlet weak var scanPan: UIImageView!
    
    var scanSession :  AVCaptureSession?
    lazy var scanLine : UIImageView =
        {
            let scanLine = UIImageView()
            scanLine.frame = CGRect(x: 0, y: 0, width: self.scanPan.bounds.width, height: 3)
            scanLine.image = UIImage(named: "QRCode_ScanLine")
            return scanLine
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "扫描二维码"
        scanPan.addSubview(scanLine)
        setupScanSession()    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        startScan()
        
    }

    //开始扫描
    fileprivate func startScan()
    {
        
        scanLine.layer.add(scanAnimation(), forKey: "scan")
        
        guard let scanSession = scanSession else { return }
        
        if !scanSession.isRunning
        {
            scanSession.startRunning()
        }
        
        
    }
    
    //扫描动画
    private func scanAnimation() -> CABasicAnimation
    {
        //让横线在扫描的区域内
        let startPoint = CGPoint(x: scanLine .center.x  , y: 1)
        let endPoint = CGPoint(x: scanLine.center.x, y: scanPan.bounds.size.height - 2)
        let translation = CABasicAnimation(keyPath: "position")
        translation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        translation.fromValue = NSValue(cgPoint: startPoint)
        translation.toValue = NSValue(cgPoint: endPoint)
        translation.duration = 4.0
        translation.repeatCount = MAXFLOAT
        translation.autoreverses = true
        
        return translation
    }
    func setupScanSession()
    {
        
        do
        {
            //设置捕捉设备
            let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            //设置设备输入输出
            let input = try AVCaptureDeviceInput(device: device)
            
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            //设置会话
            let  scanSession = AVCaptureSession()
            scanSession.canSetSessionPreset(AVCaptureSessionPresetHigh)
            
            if scanSession.canAddInput(input)
            {
                scanSession.addInput(input)
            }
            
            if scanSession.canAddOutput(output)
            {
                scanSession.addOutput(output)
            }
            
            //设置扫描类型(二维码和条形码)
            output.metadataObjectTypes = [
                AVMetadataObjectTypeQRCode,
                AVMetadataObjectTypeCode39Code,
                AVMetadataObjectTypeCode128Code,
                AVMetadataObjectTypeCode39Mod43Code,
                AVMetadataObjectTypeEAN13Code,
                AVMetadataObjectTypeEAN8Code,
                AVMetadataObjectTypeCode93Code]
            
            //预览图层
            let scanPreviewLayer = AVCaptureVideoPreviewLayer(session:scanSession)
            scanPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            scanPreviewLayer!.frame = view.layer.bounds
            
            view.layer.insertSublayer(scanPreviewLayer!, at: 0)
            
            //设置扫描区域
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: nil, using: { (noti) in
                output.rectOfInterest = (scanPreviewLayer?.metadataOutputRectOfInterest(for: self.scanPan.frame))!
            })
            
            
            
            //保存会话
            self.scanSession = scanSession
            
        }
        catch
        {
            //摄像头不可用
            let alertVC = UIAlertController(title: "温馨提示", message: "摄像头不可用", preferredStyle: .alert)
            let entureAction = UIAlertAction(title: "确定", style: .destructive, handler: nil)
            alertVC.addAction(entureAction)
            self.present(alertVC, animated: true, completion: nil)
            
            return
        }
        
    }

}


//扫描 -- 代理方法
extension ScanQRCodeVc : AVCaptureMetadataOutputObjectsDelegate
{
    // 扫描完成代理方法
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
    {
        
        //停止扫描
        self.scanLine.layer.removeAllAnimations()
        self.scanSession!.stopRunning()
        
        //播放声音
        guard let soundPath = Bundle.main.path(forResource: "noticeMusic.caf", ofType: nil)  else { return }
        guard let soundUrl = NSURL(string: soundPath) else { return }
        var soundID:SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundUrl, &soundID)
        AudioServicesPlaySystemSound(soundID)
        
        //扫完完成
        if metadataObjects.count > 0
        {
            
            if let resultObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject
            {
                
              // 展示扫描的结果或者其他处理
                
            }
            
        }
        
    }
    
    ///3.确认弹出框
    
     func confirm(title:String?,message:String?,controller:UIViewController,handler: ( (UIAlertAction) -> Swift.Void)? = nil)
    {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let entureAction = UIAlertAction(title: "确定", style: .destructive, handler: handler)
        alertVC.addAction(entureAction)
        controller.present(alertVC, animated: true, completion: nil)
        
    }

    
}
