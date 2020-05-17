//
//  EditProfiloViewController.swift
//  5teps
//
//  Created by Fabio Palladino on 17/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit

class EditProfiloViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    var imagePicker = UIImagePickerController()
    public var parentVC: OnCloseChildView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = User.userData
        nameTextField.text = user.name
        
        self.imageView.image = user.getProfiloImage()
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2
        self.imageView.clipsToBounds = true
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onClickSave(_ sender: UIButton) {
        let user = User.userData
        user.name = nameTextField.text ?? ""
        user.profiloImage = imageView.image?.pngData()
        user.save()
        
        self.dismiss(animated: true) {
            self.parentVC?.onReloadDati()
        }
    }
    @IBAction func onClickCancel(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }
    }
    @IBAction func onClickEdit(_ sender: UIButton) {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let azione1 = UIAlertAction(title: "Take a picture", style: .default,
            handler: {(paramAction:UIAlertAction!) in
                self.takePhoto()
        })
        let azione2 = UIAlertAction(title: "Choose a photo", style: .default,
            handler: {(paramAction:UIAlertAction!) in
                DispatchQueue.main.async {
                  self.choosePhoto()
                }
        })
        let azioneDestructive = UIAlertAction(title: "Cancel", style: .cancel,
            handler: {(paramAction:UIAlertAction!) in

        })
        
        controller.addAction(azione1)
        controller.addAction(azione2)
        controller.addAction(azioneDestructive)
        self.present(controller, animated: true) {
            
        }
    }
    func choosePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            print("choosePhoto")

            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: {
                print("choosePhoto complete")

            })
        }
    }
    
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            print("takePhoto")

            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: {
                print("takePhoto complete")

            })
        }
    }
    
    
}

extension EditProfiloViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("imagePickerController \(info)")
        guard let image = info[.originalImage] as? UIImage else {
            print("Expected a dictionary containing an image")
            return
        }
        
        imagePicker.dismiss(animated: true) {
            self.imageView.image = image
        }
        
    }
}
