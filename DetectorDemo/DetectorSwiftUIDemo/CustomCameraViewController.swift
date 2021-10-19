//
//  CustomCameraViewController.swift
//  DetectorSwiftUIDemo
//
//  Created by  YNET on 2021/10/19.
//

import Foundation
import UIKit
import Vision
import VisionKit
import SwiftUI

struct CameraViewController : UIViewControllerRepresentable {
    
    let cameraVC = CuCameraViewController.init()
    
    func makeCoordinator() -> Coordinator {
        CustomCameraViewController(self)
    }
    
    func makeUIViewController(context: Context) -> some CuCameraViewController {
        return cameraVC 
    }
    
    class Coordinator {
        
    }
    
    public class CuCameraViewController : UIViewController, VNDocumentCameraViewControllerDelegate {
        
        public override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            cameraScanDocument()
        }
        
        func cameraScanDocument() -> Void{
            
            if !VNDocumentCameraViewController.isSupported {
                let alertVC = UIAlertController.init(title: "温馨提示", message: "当前设备不支持", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: "我知道了", style: .default, handler: { action in
                    
                }))
                alertVC.present(UIViewController.init(), animated: true) { 
                    
                }
            }else{
                let dcVC = VNDocumentCameraViewController.init()
                dcVC.delegate = self
                UIViewController.init().present(dcVC, animated: true) { 
                    
                } 
            }
        }
        
        public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            var imageMtbAry : [UIImage] = []
            for i in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: i)
                imageMtbAry.append(image)
            }
            if imageMtbAry.count > 0 {
                imageDetectionManager(imgAry: imageMtbAry)
                controller.dismiss(animated: true) { 
                    
                }
            }
        }
        
        public func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true) { 
                
            }
        }
        
        public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("fail error : \(error)")
        }
        
        func imageDetectionManager(imgAry:[UIImage]) -> Void {
            if #available(iOS 13.0, *) {
                
                if #available(iOS 14.0, *) {
                    var possibleLanguages : Array<String> = []
                    do{
                        possibleLanguages = try VNRecognizeTextRequest.supportedRecognitionLanguages(for: .accurate, revision: VNRecognizeTextRequestRevision2)
                    } catch {
                        print("error getting the supported languages.")
                    }
                    print("languages: \(possibleLanguages)")
                } else {

                }
                
                let completionHandle : VNRequestCompletionHandler = { (request, error) in 
                    let obser : [Any] = request.results ?? []
                    
                    for ob in obser {
                        if ob is VNRecognizedTextObservation {
                            let obs : VNRecognizedTextObservation = ob as! VNRecognizedTextObservation
                            let textAry : [VNRecognizedText] = obs.topCandidates(2)
                            for reText in textAry {
                                print("string = \(reText.string)")
                            }
                        }
                    }
                }
                
                var img:UIImage?
                if imgAry.count > 0 {
                    img = imgAry[0]
                }
                if (img != nil) {
                    guard let cgImage = img?.cgImage else {
                        print("UIImage 转换 cgImage 失败")
                        return
                    }
                    
                    let textRequest = VNRecognizeTextRequest.init(completionHandler: completionHandle)
                    textRequest.recognitionLevel = .accurate
                    textRequest.minimumTextHeight = 0.001
                    textRequest.recognitionLanguages = ["zh-Hans", "zh-Hant"]
                    textRequest.usesLanguageCorrection = false
                    textRequest.customWords = ["姓名", "性别", "民族", "出生", "住址", "公民身份号码", "签发机关", "有效期限", "姓", "名", "性", "别", "民", "族", "出", "生", "住", "址", "公", "身", "份", "号", "码", "签", "发", "机", "关", "有", "效", "期", "限"]
                    
                    let handel = VNImageRequestHandler.init(cgImage: cgImage, options: [:])
                    do {
                        try handel.perform([textRequest])
                    } catch  {
                        print("请求失败")
                    }

                }else{
                    print("image is nil")
                }

            }
        }
        
    }

}

