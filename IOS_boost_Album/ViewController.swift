//
//  ViewController.swift
//  IOS_boost_Album
//
//  Created by 남수김 on 23/02/2019.
//  Copyright © 2019 남수김. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
   
    
    var fetchResult: PHFetchResult<PHAsset>!
    let imageManager: PHCachingImageManager = PHCachingImageManager()

    let half: Double = Double(UIScreen.main.bounds.width/2 - 20)
   

    override func viewDidLoad() {
        super.viewDidLoad()
         let heightsize: Double = half + 40
        //큰글씨에서 스크롤시 작은글씨로 타이틀바 표시
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "앨범"
        
        //layout 설정
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.itemSize = CGSize(width: half, height: heightsize)
        
        flowlayout.sectionInset = UIEdgeInsets.zero //margin zero
        flowlayout.minimumLineSpacing = 40
        flowlayout.minimumInteritemSpacing = 20 //같은행끼리 간격
        self.collectionView.collectionViewLayout = flowlayout
        
        
        //사진 접근허가상태
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("접근 허가")
            self.requestCollection()
            self.collectionView.reloadData()
        case .denied:
            print("접근 불허")
        case .notDetermined:
            print("아직 응답하지않음")
            PHPhotoLibrary.requestAuthorization({ (status) in
                switch status {
                case .authorized:
                    print("사용자가 허가함")
                    self.requestCollection()
                    
                    OperationQueue.main.addOperation {  // reload는 메인스레드에서만 작동할수있다오류 해결
                        self.collectionView.reloadData()
                    }
                    
                case .denied:
                    print("사용자가 불허함")
                default: break
                }
            })
        case .restricted:
            print("접근 제한")
        }
        
        //PHPhotoLibrary.shared().register(self) //포토라이브러리 변화시 딜리게이트 호출
    }


    //cell 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchResult?.count ?? 0
    }
    
    //cell 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell:ListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as? ListCollectionViewCell else {
            print("cell error")
            return UICollectionViewCell()
        }
        
        let asset: PHAsset = fetchResult.object(at: indexPath.item)
        
        //cell.setting(self.half) //imgview크기 설정
        imageManager.requestImage(for: asset, targetSize: CGSize(width: half, height: half) , contentMode: .aspectFit , options: nil, resultHandler: {img, _ in
            cell.imgView?.image = img
        })
        
        return cell
    }
    
    
    //사진가져오기
    func requestCollection(){
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        
        guard let cameraRollCollection = cameraRoll.firstObject else {
            return
        }
        
        let fetchOptions = PHFetchOptions()
        //최신순 정렬
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        //결과를 변수에 저장
        self.fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
    }
}

