//
//  ThridViewController.swift
//  IOS_boost_Album
//
//  Created by 남수김 on 06/03/2019.
//  Copyright © 2019 남수김. All rights reserved.
//

import UIKit
import Photos

class ThridViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    var picture: UIImage!
    var asset: PHAsset!
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        imageView.image = picture
        // Do any additional setup after loading the view.
    }
    
    //삭제버튼누를시
    @IBAction func trashbtClick(_ sender: Any) {
       //삭제 다이얼로그
        PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets([self.asset] as NSArray)}, completionHandler: nil)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //줌할 뷰지정
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    //줌시작씨 배경 검은색으로 변경
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.backgroundColor = UIColor.black
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.toolbar.isHidden = true
        
    }
    
    //줌끝날때 원래사이즈로 돌아왔으면 다시배경 흰색으로바꿔줌
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scale == 1.0 {
            scrollView.backgroundColor = UIColor.white
        }
         self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.toolbar.isHidden = false
    }
}
