//
//  UploadViewController.swift
//  final_application
//
//  Created by Cheng Enzo on 2017/6/4.
//  Copyright © 2017年 Cheng Enzo. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var picker = UIImagePickerController()
    let num = Int(arc4random()%5)
    var img : [String?] = ["1.jpg", "2.jpg", "3.jpg", "4.jpg", "5.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        cancelBtn.isHidden = true
        let string = img[num]!
        imageView.image = UIImage(named:string)
        label.isHidden = false
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.previewImage.contentMode = .scaleAspectFit
            self.previewImage.image = image
            selectBtn.isHidden = true
            postBtn.isHidden = false
            cancelBtn.isHidden = false
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.previewImage.image = UIImage(named:"noimage.gif")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "feedVC")
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func selectPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Action",
                                      message: "choose picture from...",
                                      preferredStyle:.actionSheet)
        let cameraAction = UIAlertAction(title:"Camera", style: .default){
            (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                self.picker.delegate = self
                self.picker.sourceType = UIImagePickerControllerSourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.picker.allowsEditing = false
                self.present(self.picker, animated: true, completion: nil)
                self.label.isHidden = true
            }
        }
        let libraryAction = UIAlertAction(title:"Library", style:.default){
            (action) in
            self.picker.allowsEditing = true
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
            self.label.isHidden = true
        }
        let cancelAction = UIAlertAction(title:"cancel", style:.cancel){
            (action) in
        }
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func postPressed(_ sender: Any) {
        AppDelegate.instance().showActivityIndicator()
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        let storage = Storage.storage().reference(forURL: "gs://petagram-d5a8a.appspot.com")
        
        
        let key = ref.child("posts").childByAutoId().key
        let imageRef = storage.child("posts").child(uid).child("\(key).jpg")
        
        let data = UIImageJPEGRepresentation(self.previewImage.image!, 0.6)
        
        let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
            if error != nil{
                print(error!.localizedDescription)
                AppDelegate.instance().dismissActivityIndicatos()
                return
            }
            imageRef.downloadURL(completion: { (url, error) in
                if let url = url{
                    let feed = ["userID": uid,
                                "pathToImage": url.absoluteString,
                                "likes": 0,
                                "author": Auth.auth().currentUser!.displayName!,
                    "postID": key] as [String: Any]
                    
                    let postFeed = ["\(key)": feed]
                    ref.child("posts").updateChildValues(postFeed)
                    AppDelegate.instance().dismissActivityIndicatos()
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
        }
        
        uploadTask.resume()
        
    }

}
