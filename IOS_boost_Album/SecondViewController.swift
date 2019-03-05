//
//  SecondViewController.swift
//  IOS_boost_Album
//
//  Created by 남수김 on 04/03/2019.
//  Copyright © 2019 남수김. All rights reserved.
//

import UIKit
import Photos

class SecondViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, PHPhotoLibraryChangeObserver
 {
    
    @IBOutlet weak var sortToolbarItem: UIBarButtonItem!
    @IBOutlet weak var actionToolbarItem: UIBarButtonItem!
    @IBOutlet weak var trashToolbarItem: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    

    var buttonstatus = false
    var pictures: PHFetchResult<PHAsset>!
    var albumName: String!
    var albumindex: Int!
    
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    let half: Double = Double(UIScreen.main.bounds.width/3-15)
    
    //navigation right button
    var myrightBarButtonItem: UIBarButtonItem!
   
    //삭제할 이미지인덱스저장
    var delete = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //layout 설정
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.itemSize = CGSize(width: half, height: half)
        flowlayout.sectionInset = UIEdgeInsets.zero //margin zero
        flowlayout.minimumLineSpacing = 20
        flowlayout.minimumInteritemSpacing = 20 //같은행끼리 간격
        self.collectionView.collectionViewLayout = flowlayout
       
       //큰 타이틀기능 끄기
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        //타이틀이름 바꾸기
        self.navigationItem.title = albumName
        
        //포토라이브러리 변화시 딜리게이트 호출
        PHPhotoLibrary.shared().register(self)
        
        //오른쪽 네비게이션바 아이템만들기
        myrightBarButtonItem = UIBarButtonItem(title: "선택", style: .plain , target: self, action: #selector(selectbtAction(_:)))
        
        self.navigationItem.rightBarButtonItem = myrightBarButtonItem
        
        
    }
    
    
    
    //MARK: - Navigation 선택버튼
    //네비게이션바 선택버튼
    @objc func selectbtAction(_ sender: UIBarButtonItem) -> Void {
        self.actionToolbarItem.isEnabled = true // 툴바버튼 활성화
        self.trashToolbarItem.isEnabled = true
        self.navigationItem.title = "항목선택"
        self.navigationItem.hidesBackButton = true //백버튼숨김
        //취소기능 네비게이션아이템추가
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", style: .plain , target: self, action: #selector(cancelbtAction(_:)))
        
        //다중선택활성화
        self.collectionView.allowsMultipleSelection = true
        

    }
    
    //네비게이션바 취소버튼
    @objc func cancelbtAction(_ sender: UIBarButtonItem) -> Void {
        self.actionToolbarItem.isEnabled = false // 툴바버튼 비활성화
        self.trashToolbarItem.isEnabled = false
        self.navigationItem.title = "선택"
        self.navigationItem.hidesBackButton = false //백버튼비활성화
        self.navigationItem.rightBarButtonItem = myrightBarButtonItem
        
        //저장배열 초기화
        self.delete = [Int]()
        //다중선택비활성
        self.collectionView.allowsMultipleSelection = false
        //선택값 삭제위한 리로드
        self.collectionView.reloadData()
        
    }
    

    //MARK: - Toolbaraction
    //toolbar item중 정렬버튼클릭시
    @IBAction func sortToolbarbt(_ sender: Any)  {
        
        buttonstatus = !buttonstatus
        
        if buttonstatus { //최신순클릭시
            sortToolbarItem.title = "과거순"  //툴바 타이틀변경
            let reversecreationDateFet = PHFetchOptions()
            reversecreationDateFet.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            /***********************/
            //카메라롤일경우
            if albumName! == "Camera Roll" {
                let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum , subtype: .smartAlbumUserLibrary , options: nil)
                guard let userAlbum:PHAssetCollection = cameraRoll.firstObject else {
                    return
                }
                pictures = PHAsset.fetchAssets(in: userAlbum, options: reversecreationDateFet)
                
            } else {
                /* 사용자 생성앨범 정렬구현*/
                
                let listfet = PHFetchOptions()
                listfet.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: false)]
                
                //생성날짜 최근거부터 정렬(내림차순)
                let userAlbumList: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album , subtype: .any , options: listfet)
                
                
                let userAlbum:PHAssetCollection = userAlbumList.object(at: albumindex-1)
                pictures = PHAsset.fetchAssets(in: userAlbum, options: reversecreationDateFet)
                
            }
            /***************/
            
            collectionView.reloadData()
            
        } else { //과거순일때 클릭시
            sortToolbarItem.title = "최신순"
            
            let creationDateFet = PHFetchOptions()
            creationDateFet.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            
            /*************/
            //생성날짜 늦은거부터 정렬 (오름차순)
            //카메라롤일경우
            if albumName! == "Camera Roll" {
                let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum , subtype: .smartAlbumUserLibrary , options: nil)
                guard let userAlbum:PHAssetCollection = cameraRoll.firstObject else {
                    return
                }
                pictures = PHAsset.fetchAssets(in: userAlbum, options: creationDateFet)
                
            } else {
                /* 사용자 생성앨범 정렬구현*/
                
                let listfet = PHFetchOptions()
                listfet.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: false)]
                
                //생성날짜 최근거부터 정렬(내림차순)
                let userAlbumList: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album , subtype: .any , options: listfet)
                
                let userAlbum:PHAssetCollection = userAlbumList.object(at: albumindex-1)
                pictures = PHAsset.fetchAssets(in: userAlbum, options: creationDateFet)
                
            }
            /****************/
            collectionView.reloadData()
        }
    }
    
    //toolbar actionitem 클릭시
    @IBAction func actionItemClick(_ sender: Any) {
        
    }
    
    //toolbar trash 클릭시
    @IBAction func trashItemClick(_ sender: Any) {
        
        var asset = [PHAsset]()
        for i in delete {
            asset.append(pictures[i])
        }
        PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets(asset as NSFastEnumeration)}, completionHandler: nil)


    }
    
    //MARK: - collectionView
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
        cell.backgroundColor = UIColor.white //선택초기화
        
        return cell
    }
    
    //선택시 흐리게보이기
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.alpha = 0.7
        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.black
        
        //선택된 배열인덱스 저장 중복시 저장안함
        if !delete.contains(indexPath.item) {
            delete.append(indexPath.item)
        }
        print(delete)
    }
    
    //미선택시 원래색으로
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.alpha = 1
        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.white
        
        //선택을 취소한 배열 삭제
        let index: Int! = delete.firstIndex(of: indexPath.item)
        delete.remove(at: index)
        print("delete: \(delete)")
    }

    //MARK: - PHPhotoLibraryChangeObserver
    // 포토라이브러리 변화시
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: pictures)
            else { return }
        
        pictures = changes.fetchResultAfterChanges  //바뀐값 다시 저장
        
        //바꼇으면 컬렉션뷰 다시 리로드
        OperationQueue.main.addOperation {
            self.collectionView.reloadData()
        }
    }

    
}
