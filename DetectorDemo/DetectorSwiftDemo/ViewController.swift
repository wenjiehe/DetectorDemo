//
//  ViewController.swift
//  DetectorSwiftDemo
//
//  Created by  YNET on 2021/10/18.
//

import UIKit
import VisionKit

class ViewController: UIViewController, VNDocumentCameraViewControllerDelegate {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("进来了")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        cameraScanDocument()
    }
    
    func cameraScanDocument() -> Void {
        if #available(iOS 13.0, *) {
            if !VNDocumentCameraViewController.isSupported {
                let alertVC = UIAlertController.init(title: "温馨提示", message: "当前设备不支持", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: "我知道了", style: .default, handler: { action in
                    
                }))
                alertVC.present(self, animated: true) { 
                    
                }
            }else{
                let dcVC = VNDocumentCameraViewController.init()
                dcVC.delegate = self
                self.present(dcVC, animated: true) { 
                    
                } 
            }
        } else {
        }
    }
    
    @available(iOS 13.0, *)
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        var imageMtbAry : [UIImage] = []
        for i in 0..<scan.pageCount {
            let image = scan.imageOfPage(at: i)
            imageMtbAry.append(image)
        }
        if imageMtbAry.count > 0 {
            VisionManager .imageDetectionManager(imgAry: imageMtbAry)
            controller .dismiss(animated: true) { 
                
            }
        }
    }
    
    @available(iOS 13.0, *)
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true) { 
            
        }
    }

    @available(iOS 13.0, *)
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print("fail error = \(error)")
    }

}

