//
//  UIViewController+ImagePicker.swift
//  mio-group
//
//  Created by Vladimir Yevdokimov on 1/11/17.
//  Copyright © 2017 magnet. All rights reserved.
//

import Foundation
import UIKit


import AVFoundation
import Photos

/// MediType can be MediaType:
/// - .video - for Camera
/// - .audio - for Microphone
public enum MediaType:String {
    case video
    case audio

    func rawType()->String {
        switch self {
        case .video:
            return AVMediaTypeVideo
        case .audio:
            return AVMediaTypeAudio
        }
    }
}

class ServicePermissionsManager: NSObject {

    class func checkAccessPermissionToMediaType(_ type:MediaType) -> AVAuthorizationStatus {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: type.rawType())
        return status
    }

    class func requestAccessToMediaType(_ type:MediaType, callback:((_ gd:Bool)->())?) {
        AVCaptureDevice.requestAccess(forMediaType: type.rawType()) { (granted) in
            callback?(granted)
        }
    }

    /// Request access to Photo Library assets
    class func requestAccessToPhotoLibrary(_ callback:((_ status:PHAuthorizationStatus)->())?) {
        PHPhotoLibrary.requestAuthorization { (status) in
            callback?(status)
        }
    }
}

internal var pickerPontroller: UIImagePickerController?

let kStr_Warning = "Warning"

extension UIViewController : UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    //MARK: - Public call

    func openPhotoLibraryPicker() {
        ServicePermissionsManager.requestAccessToPhotoLibrary { (status) in
            switch(status) {
            case .authorized, .notDetermined:
                pickerPontroller = UIImagePickerController()
                pickerPontroller?.delegate = self
                pickerPontroller?.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.present(pickerPontroller!, animated: true, completion: nil)
            case .denied:
                AppUtils.showAlert(title: kStr_Warning, message: "Access to Photo Library denied. You should switch on acessibility in Settings", actions: nil)
            default: break
            }
        }
    }

    func openCameraPhotoPicker() {
        let status = ServicePermissionsManager.checkAccessPermissionToMediaType(MediaType.video)

        switch(status) {
        case .authorized, .notDetermined :
            pickerPontroller = UIImagePickerController()
            pickerPontroller?.delegate = self
            pickerPontroller?.sourceType = UIImagePickerControllerSourceType.camera
            self.present(pickerPontroller!, animated: true, completion: nil)
        case .denied:
            AppUtils.showAlert(title: kStr_Warning, message: "Access to Camera denied. You should switch on acessibility in Settings", actions: nil)
        default: break
        }
    }

    //MARK: - Public callback

    func didPickImagePickerImage(_ image:UIImage) {
        print("image ready to be picked! Override didPickImagePickerImage to get image data")
    }

    //MARK: - UIImagePickerControllerDelegate

    final public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerPontroller?.dismiss(animated: true, completion: nil)
    }

    final public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.didPickImagePickerImage(image)
        }
        pickerPontroller?.dismiss(animated: true, completion: nil)
    }

}
