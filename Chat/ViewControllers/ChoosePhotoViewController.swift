//
//  CropPhotoViewController.swift
//  Chat
//
//  Created by Eduardo Fornari on 27/04/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class ChoosePhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    static let goToChoosePhotoFromCreateProfileSegue = "goToChoosePhotoFromCreateProfile"
    
    public var profile: Profile!

    let picker = UIImagePickerController()

    @IBOutlet weak var cropPhoto: CropPhotoUIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        cropPhoto.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction(recognizer:)))
        cropPhoto.addGestureRecognizer(tapGestureRecognizer)

        picker.delegate = self
    }

    @objc private func tapAction(recognizer: UITapGestureRecognizer) {
        let optionMenu = UIAlertController(title: nil, message: "Image Source", preferredStyle: .actionSheet)

        let galery = UIAlertAction(title: "Gallery", style: .default) { _ -> Void in
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = ["public.image"]
            self.present(self.picker, animated: true, completion: nil)
        }
        let camera = UIAlertAction(title: "Camera", style: .default) { _ -> Void in
            self.picker.allowsEditing = false
            self.picker.sourceType = .camera
            self.picker.mediaTypes = ["public.image"]//UIImagePickerController.availableMediaTypes(for: .camera)!
            self.present(self.picker, animated: true, completion: nil)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        optionMenu.addAction(galery)
        optionMenu.addAction(camera)
        optionMenu.addAction(cancel)

        self.present(optionMenu, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true) {}
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String: Any]) {

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            cropPhoto.image = image
        }

        dismiss(animated: true) { }
    }

    @IBAction func cropButton(_ sender: UIButton) {
        let image = cropPhoto.getCropedImage()
        profile.profilePicture = image
        view.lock()
        view.endEditing(true)
        DataAccess.sharedInstance.save(with: profile) { error in
            if error == nil {
                DataAccess.sharedInstance.currentProfile = self.profile
                self.performSegue(withIdentifier: UsersViewController.goToUsersFromCreateProfileSegue, sender: nil)
            } else {
                self.present(Alerts.simpleAlert(with: "Error Creating Profile"), animated: true)
            }
            self.view.unlock()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
