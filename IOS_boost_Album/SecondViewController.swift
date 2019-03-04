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
    
    @IBOutlet weak var sortButton: UIButton!
    var buttonstatus = false
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
    
    @IBAction func sortbtAction(_ sender: Any) {
        
         buttonstatus = !buttonstatus
        
        if buttonstatus { //최신순클릭시
            sortButton.setTitle("과거순", for: UIControl.State.normal)
            let reversecreationDateFet = PHFetchOptions()
            reversecreationDateFet.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            //생성날짜 최근거부터 정렬(내림차순)
            pictures = PHAsset.fetchAssets(with: reversecreationDateFet)
            collectionView.reloadData()
            
        } else { //과거순일때 클릭시
             sortButton.setTitle("최신순", for: UIControl.State.normal)
            
            let creationDateFet = PHFetchOptions()
            creationDateFet.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            //생성날짜 늦은거부터 정렬 (오름차순)
            pictures = PHAsset.fetchAssets(with: creationDateFet)
            collectionView.reloadData()
        }
       
        
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

    

}
