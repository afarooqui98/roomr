//
//  AccountSetupUtils.swift
//  Roomr
//
//  Created by Ahmed Farooqui on 11/21/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import Foundation
import Firebase
import AVFoundation
import Photos
import BSImagePicker

//MARK: add functionality for images to be loaded from the profile data structure
extension AccountSetupPicsController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width - 8) / 3), height: ((collectionView.frame.width - 8) / 3))
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxPics
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picsCollectionCell", for: indexPath)
        cell.backgroundColor = .white
        
        let img = UIImageView(image: profile.pics[indexPath.row])
        img.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(img)
        img.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 4).isActive = true
        img.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 4).isActive = true
        img.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -4).isActive = true
        img.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -4).isActive = true
        img.contentMode = .scaleToFill
        img.layer.masksToBounds = true
        
        return cell
    }
}

//MARK: collectionview delegates
extension AccountSetupPicsController: UICollectionViewDragDelegate, UICollectionViewDropDelegate{
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag{
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath{
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
        
        if coordinator.proposal.operation == .move {
            reorder(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.encodedPicsArray[indexPath.row]
//        let img = "example"
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}

//MARK: Asking User Permission for camera
func askCameraPermission(_ controller: AccountSetupPicsController) {
    // Ask user for camera access:
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
        return
    case .notDetermined:
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted { return
            } else {
                repeatCameraAccessRequest(controller)
            }
        }
    case .denied:
        repeatCameraAccessRequest(controller)
        return
    case .restricted:
        let alert = UIAlertController(title: "Restricted",
                                      message: "You've been restricted from using the camera on this device. Without camera access this feature won't work. Please contact the device owner so they can give you access.",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        controller.present(alert, animated: true, completion: nil)
        return
    default:
        print("Trouble asking for camera permissions")
        return
    } // check status of camera access permissions
} /* askCameraPermission() */

func repeatCameraAccessRequest(_ controller: AccountSetupPicsController) {
    DispatchQueue.main.async {
        // Create alert to give user option to change camera permissions in settings
        let alertText = "It looks like you have denied camera access to this app. To allow access, go to \"Settings\" --> \"Privacy\" --> \"Camera\" and turn on the toggle next to \"Roomr\""
            
        let alert = UIAlertController(title: "Roomr wants access to your camera", message: alertText, preferredStyle: .alert)
            
        let goToSettingsAction = UIAlertAction(title: "Go to settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        } // if user pressed Go, redirect them to settings
            
        alert.addAction(goToSettingsAction)
        controller.present(alert, animated: true, completion: nil)
    }
} /* repeatCameraAccessRequest(): Give user opportunity to grant camera access */

func askPhotoLibraryPermission(_ controller: AccountSetupPicsController) {
    switch PHPhotoLibrary.authorizationStatus() {
    case .authorized:
        return
    case .notDetermined:
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
        }
    case .denied:
        repeatPhotoLibraryAccessRequest(controller)
        return
    case .restricted:
        let alert = UIAlertController(title: "Restricted",
                                      message: "You've been restricted from saving photos to the photo library. Please contact the device owner so they can give you access.",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        controller.present(alert, animated: true, completion: nil)
        return
    default:
        print("Trouble asking for photo library permissions")
        return
    } // check status of photo library access
} /* askPhotoLibraryPermission(): ask for permission to save to photo library */

func repeatPhotoLibraryAccessRequest(_ controller: AccountSetupPicsController) {
    DispatchQueue.main.async {
        // Create alert to give user option to change photo library permissions in settings
        let alertText = "It looks like you have denied Roomr permission to save photos to your photo library. To allow access, click \"Go\" to make changes in settings"
        
        let alert = UIAlertController(title: "Roomr wants access to your photo library", message: alertText, preferredStyle: .alert)
        
        let goToSettingsAction = UIAlertAction(title: "Go to settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        } // if user pressed Go, redirect to settings
        
        alert.addAction(goToSettingsAction)
        controller.present(alert, animated: true, completion: nil)
    }
} /* repeatPhotoLibraryAccessRequest(): Give user opportunity to grant photo library access */
