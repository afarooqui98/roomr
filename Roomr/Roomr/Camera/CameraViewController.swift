//
//  CameraViewController.swift
//  Roomr
//
//  Created by Katie Kwak on 11/18/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var imagePicker : UIImagePickerController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // ask for camera permissions:
        askCameraPermission()
        askPhotoLibraryPermission()
    } /* viewDidLoad() */
    
    
    
    
    /* Asking User Permission */
    func askCameraPermission() {
        // Ask user for camera access:
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted { return
                } else {
                    self.repeatCameraAccessRequest()
                }
            }
        case .denied:
            self.repeatCameraAccessRequest()
            return
        case .restricted:
            let alert = UIAlertController(title: "Restricted",
                                          message: "You've been restricted from using the camera on this device. Without camera access this feature won't work. Please contact the device owner so they can give you access.",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        default:
            print("Trouble asking for camera permissions")
            return
        } // check status of camera access permissions
    } /* askCameraPermission() */
    
    
    
    
    func askPhotoLibraryPermission() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            return
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized else { return }
            }
        case .denied:
            repeatPhotoLibraryAccessRequest()
            return
        case .restricted:
            let alert = UIAlertController(title: "Restricted",
                                          message: "You've been restricted from saving photos to the photo library. Please contact the device owner so they can give you access.",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        default:
            print("Trouble asking for photo library permissions")
            return
        } // check status of photo library access
    } /* askPhotoLibraryPermission(): ask for permission to save to photo library */
    
    
    
    /* Taking the picture */
    @IBAction func takePhoto(_ sender: UIButton) {
        imagePicker = UIImagePickerController()
        guard let picker = imagePicker else { return }

        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    } /* takePhoto(): displays image picker (camera to take picture) */
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        guard let picker = imagePicker else { return }
        guard let image = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }

        picker.dismiss(animated: true, completion: nil)
        savePhotoToLibrary(imageToSave: image)
    } /* imagePickerController(): called when user chose to use picture */
    
    
    
    
    /* Saving the picture */
    func savePhotoToLibrary(imageToSave: UIImage) {
        // Create alert to ask if user wants to save photo
        let alertText = "Roomr can save this to your library"
            
        let alert = UIAlertController(title: "Save this picture?", message: alertText, preferredStyle: .alert)
            
        let savePicAction = UIAlertAction(title: "Save", style: .default) { (_) -> Void in
            UIImageWriteToSavedPhotosAlbum(imageToSave, self, #selector( self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        } // add picture to photo library
        
        let denyAction = UIAlertAction(title: "Don't Save", style: .default)
            
        alert.addAction(savePicAction)
        alert.addAction(denyAction)
        self.present(alert, animated: true, completion: nil)
    } /* savePhotoLibrary(): Give user option to save photo through an alert */
    
    
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            // we got back an error!
            displayAlert(title: "Problem saving the picture", message: "There was an issue saving your image, please try again")
        } else {
            displayAlert(title: "Image was saved", message: "Check your library, the image has been saved.")
        }
    } /* image(): called when trying to save image in 'savePhotoToLibrary' */
    
    
    
    
    /* Alert Creation-related functions */
    func displayAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    } /* displayAlert() */
    
    
    
    
    func repeatCameraAccessRequest() {
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
            self.present(alert, animated: true, completion: nil)
        }
    } /* repeatCameraAccessRequest(): Give user opportunity to grant camera access */
    
    
    
    
    func repeatPhotoLibraryAccessRequest() {
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
            self.present(alert, animated: true, completion: nil)
        }
    } /* repeatPhotoLibraryAccessRequest(): Give user opportunity to grant photo library access */
    

} /* CameraViewController */
