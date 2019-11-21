//
//  AccountSetupPicsController.swift
//  Roomr
//
//  Created by Ahmed Farooqui on 11/14/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import Photos
import BSImagePicker

class AccountSetupPicsController: UIViewController{
    @IBOutlet weak var picsCollection: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    var ref: DatabaseReference!
    var storageRef: StorageReference!
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    var roomrBlue = UIColor(red:0.00, green:0.60, blue:1.00, alpha:1.0)
    let maxPics = 12
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var photoLibraryButton: UIButton!
    
    var profile : UserSetupProfile!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        self.populateImages(profile.pics)
        
        picsCollection.backgroundColor = .white
        picsCollection.dragInteractionEnabled = true
        picsCollection.dataSource = self
        picsCollection.delegate = self
        picsCollection.dragDelegate = self
        picsCollection.dropDelegate = self
        self.setupCollectionViewItemSize()
        
        nextButton.layer.cornerRadius = 10
        nextButton.layer.borderColor = roomrBlue.cgColor
        nextButton.layer.borderWidth = 1
        cameraButton.layer.cornerRadius = 10
        photoLibraryButton.layer.cornerRadius = 10
    }
    
    private func setupCollectionViewItemSize() {
        if collectionViewFlowLayout == nil {
            let numberOfItemsPerRow: CGFloat = 3
            let lineSpacing: CGFloat = 5
            let interItemSpacing: CGFloat = 2
            
            let width = (self.picsCollection.frame.width - (numberOfItemsPerRow - 1) * interItemSpacing) / numberOfItemsPerRow
            let height = width
            
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
            collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
            collectionViewFlowLayout.scrollDirection = .vertical
            collectionViewFlowLayout.minimumLineSpacing = lineSpacing
            collectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
            self.picsCollection.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        }
    }
    
    func populateImages(_ pics: [UIImage]){
        for _ in 0...maxPics{
            let defaultPic = UIImage(named: "example")
            profile.pics.append(defaultPic!)
        }
    }
    
    @IBAction func takePicture(_ sender: Any) {
        //ask for permissions
        print("arrived here")
        askCameraPermission(self)
        askPhotoLibraryPermission(self)
        //open camera
        let vc = BSImagePickerViewController()
        vc.takePhotos = true
        bs_presentImagePickerController(vc, animated: true, select: nil, deselect: nil, cancel: nil, finish: {(assets: [PHAsset]) -> Void in
            let assets = self.getAssetThumbnail(assets: assets) //only add the pictures youve uploaded
            for i in 0...assets.count-1{
                self.profile.pics[i] = assets[i]
            }
            self.picsCollection.reloadData()
            print(self.profile.pics.count)
        }, completion: nil)
        //save to array
    }
    
    @IBAction func goHome(_ sender: Any) {
        //load home view
        let storyBoard = UIStoryboard(name: "HomeViewsStoryboard", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "homeViewController")
        let home = vc as! HomeViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(home, animated: true, completion: {})
        
        //store user data
        let key = ref.child("user").child(Auth.auth().currentUser?.uid ?? "invalid_user")
        let df = DateFormatter()
        df.dateFormat = "mm-dd-yyyy"
        let post = [
            "firstName" : profile.firstName,
            "dob" : df.string(from: profile.DOB),
            "gender" : profile.gender,
            "genderpref" : profile.genderPref
        ]
        key.setValue(post)
        
        //store picture datas
    }
    
    //MARK: Convert array of PHAsset to UIImages
    func getAssetThumbnail(assets: [PHAsset]) -> [UIImage] {
        var arrayOfImages = [UIImage]()
        for asset in assets {
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var image = UIImage()
            option.isSynchronous = true
            manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                image = result!
                arrayOfImages.append(image)
            })
        }
        return arrayOfImages
    }
}
