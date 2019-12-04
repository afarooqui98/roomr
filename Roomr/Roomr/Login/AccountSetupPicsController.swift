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
import CoreLocation
import SideMenuSwift
import PushNotifications

class AccountSetupPicsController: UIViewController, CLLocationManagerDelegate{
    @IBOutlet weak var picsCollection: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    var ref: DatabaseReference!
    var storageRef: StorageReference!
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    var roomrBlue = UIColor(red:0.00, green:0.60, blue:1.00, alpha:1.0)
    let maxPics = 12
    var profile : UserSetupProfile!
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        
        picsCollection.backgroundColor = .white
        picsCollection.dragInteractionEnabled = true
        picsCollection.dataSource = self
        picsCollection.delegate = self
        self.setupCollectionViewItemSize()
        
        cameraButton.layer.cornerRadius = 4
        nextButton.layer.cornerRadius = 4
        nextButton.layer.borderColor = roomrBlue.cgColor
        nextButton.layer.borderWidth = 1
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
    
    @IBAction func takePicture(_ sender: Any) {
        //clear current array
        self.profile.pics.removeAll()
        self.picsCollection.reloadData()
        
        //ask for permissions
        askCameraPermission(self)
        askPhotoLibraryPermission(self)
        //open camera
        let vc = BSImagePickerViewController()
        vc.takePhotos = true
        var arr: [UIImage] = []
        bs_presentImagePickerController(vc, animated: true, select: nil, deselect: nil, cancel: nil, finish: {(assets: [PHAsset]) -> Void in
            let assets = self.getAssetThumbnail(assets: assets) //only add the pictures youve uploaded
            for i in 0...assets.count-1{
                arr.append(assets[i])
            }
            self.profile.pics = arr
            self.picsCollection.reloadData()
            print(self.profile.pics.count)
        }, completion: nil)
        //save to array
    }
    
    @IBAction func goHome(_ sender: Any) {
        //load home view
//        askLocationPermissions()
        storeFirebaseRealtimeData()
        storeFirebasePictureData()
        pushData()
        let storyBoard = UIStoryboard(name: "HomeViewsStoryboard", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "sideMenuController")
        let home = vc as! SideMenuController
        vc.modalPresentationStyle = .fullScreen
        self.present(home, animated: true, completion: {})
    }
    
    func pushData(){
        let userId = Auth.auth().currentUser?.uid ?? "invalid_user"
        let pushManager = PushNotificationManager(userID: userId)
        pushManager.registerForPushNotifications()
    }
    
    func storeFirebaseRealtimeData(){
        //store firebase data
        let key = ref.child("user").child(Auth.auth().currentUser?.uid ?? "invalid_user")
        let df = DateFormatter()
        df.dateFormat = "mm-dd-yyyy"
        let post = [
            "firstName" : profile.firstName,
            "dob" : df.string(from: profile.DOB),
            "gender" : profile.gender,
            "genderpref" : profile.genderPref,
            "housingpref" : profile.housingPref,
            "cleanliness" : profile.cleanliness,
            "volume" : profile.volume
            ] as [String : Any]
        key.setValue(post)
        print("saved user \(String(describing: Auth.auth().currentUser?.uid))")
    }
    
    func storeFirebasePictureData(){
        let storage = Storage.storage()
        var i = 0
        for image in profile.pics{
            if let data = image.pngData(){
                let storageRef = storage.reference()
                let key = Auth.auth().currentUser?.uid ?? "invalid_user"
                let imageRef = storageRef.child("\(key)/image\(i).png")
                _ = imageRef.putData(data, metadata: nil){ metadata, error in
                    guard let _ = metadata else{
                        print(error.debugDescription)
                        return
                    }
                }
                i += 1
            }
        }
    }
    
    func askLocationPermissions(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
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
    
    //MARK: reorders the collection view as well as the array of pictures
    func reorder(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates({
                //MARK: reorder array
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
                
            }, completion: nil)
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }
    
    //MARK: location manager protocol
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                }
            }
        }
    }
}
