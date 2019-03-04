//
//  SecondViewController.swift
//  IOS_boost_Album
//
//  Created by 남수김 on 04/03/2019.
//  Copyright © 2019 남수김. All rights reserved.
//

import UIKit
import Photos

class SecondViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var pictures: PHFetchResult<PHAsset>!
    
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    let half: Double = Double(UIScreen.main.bounds.width/3-15)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //layout 설정
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.itemSize = CGSize(width: half, height: half)
        flowlayout.sectionInset = UIEdgeInsets.zero //margin zero
        flowlayout.minimumLineSpacing = 20
        flowlayout.minimumInteritemSpacing = 20 //같은행끼리 간격
        self.collectionView.collectionViewLayout = flowlayout
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell:PictureCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? PictureCollectionViewCell else {
            print("cell error")
            return UICollectionViewCell()
        }
        
        let picture: PHAsset = pictures.object(at: indexPath.item)
        
        imageManager.requestImage(for: picture, targetSize: CGSize(width: half, height: half), contentMode: .aspectFill, options: nil, resultHandler: {img, _ in
            cell.imageView?.image = img
        })
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
