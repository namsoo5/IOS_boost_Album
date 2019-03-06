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
   
    var userAsset = [PHFetchResult<PHAsset>]()  //앨범별 분류된 사진저장
    var albumName = [String]()  //앨범별 이름
    var assetCount = [Int]()    //앨범별 개수
    
    //var fetchResult: PHFetchResult<PHAsset>!
    let imageManager: PHCachingImageManager = PHCachingImageManager()

    let half: Double = Double(UIScreen.main.bounds.width/2 - 20)

    override func viewWillAppear(_ animated: Bool) {
        //돌아올때마다 적용시키기위함
        //큰글씨에서 스크롤시 작은글씨로 타이틀바 표시
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         let heightsize: Double = half + 40
     
        
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
        
//        PHPhotoLibrary.shared().register(self) //포토라이브러리 변화시 딜리게이트 호출
    }


    //cell 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // return self.fetchResult?.count ?? 0
        
        return self.userAsset.count
    }
    
    //cell 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell:ListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as? ListCollectionViewCell else {
            print("cell error")
            return UICollectionViewCell()
        }
        
        //MARK: - 앨범리스트별 셀만들기
        //let asset: PHAsset = fetchResult.object(at: indexPath.item)
        
        let img: PHAsset = userAsset[indexPath.item].object(at: 0)  //앨범별 처음사진가져오기
        
        cell.titleLabel.text = albumName[indexPath.item]
        cell.numLabel.text = "\(assetCount[indexPath.item])"
        
        imageManager.requestImage(for: img, targetSize: CGSize(width: half, height: half) , contentMode: .aspectFill , options: nil, resultHandler: {img, _ in
            cell.imgView?.image = img
        })
        
        return cell
    }
    
    
    //사진가져오기
    func requestCollection(){
        let fetchOptions = PHFetchOptions()
        //최신순 정렬
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let listfet = PHFetchOptions()
        listfet.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: false)]
        
        //MARK: - 전체앨범
        // Camera Roll 목록
        
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum , subtype: .smartAlbumUserLibrary , options: nil)
    
        guard let cameraRollCollection = cameraRoll.firstObject else {
            return
        }
        userAsset.append(PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)) //cameraroll 저장
        albumName.append("Camera Roll")
        assetCount.append(userAsset[0].count)
        //MARK: - 앨범리스트
        //0:favorite, 1: paranomal 2: camera roll
        //앨범리스트받기
        let userAlbumList: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album , subtype: .any , options: listfet)
        let albumCount = userAlbumList.count
        let userAlbum: [PHAssetCollection] = userAlbumList.objects(at: IndexSet(0..<albumCount))
        
        
        
        
        
        
        //var userAsset = [PHFetchResult<PHAsset>]() 앨범별 분류해서 사진저장
        // 인덱스 0에는 카메라롤 저장
        for i in 0..<albumCount {
            userAsset.append(PHAsset.fetchAssets(in: userAlbum[i], options: fetchOptions))  // 앨범마다 사진저장
            print("\(i)번째 배열 \(userAlbum[i].localizedTitle!)의 사진개수 \(userAsset[i+1].count)")
            assetCount.append(userAsset[i+1].count)  // 앨범마다 사진개수저장
            albumName.append(userAlbum[i].localizedTitle!)  //앨범마다 이름저장
        }
        
        //결과를 변수에 저장
//        self.fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "picture" {
            
            guard let nextView : SecondViewController = segue.destination as? SecondViewController else {
                return
            }
            
            //해당(눌린)셀불러오기
            guard let cell: ListCollectionViewCell = sender as? ListCollectionViewCell else {
                return
            }
            
            //선택된 셀의 index
            guard let index: IndexPath = self.collectionView.indexPath(for: cell) else {
                return
            }
            
            //선택된 앨범의 사진을 다음 뷰컨트롤러에 넘겨줌
            nextView.pictures = userAsset[index.item]
            nextView.albumName = self.albumName[index.item]
            nextView.albumindex = index.item
            print(index.item)
            
        }
    }
}

