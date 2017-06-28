//
//  SignUpViewController.swift
//  final_application
//
//  Created by Cheng Enzo on 2017/6/4.
//  Copyright © 2017年 Cheng Enzo. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var conPwField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var addProfileBtn: UIButton!
    
    @IBAction func textDone(_ sender: UITextField) {
        self.resignFirstResponder()
    }
    @IBAction func bgTouchDown(_ sender: UIControl) {
        nameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        conPwField.resignFirstResponder()
    }
    
    
    
    var userUid: String!
    let picker = UIImagePickerController()
    var userStorage:StorageReference!
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        let storage = Storage.storage().reference(forURL: "gs://petagram-d5a8a.appspot.com")
        userStorage = storage.child("users")
        ref = Database.database().reference()
        nextBtn.isHidden = true
    }
    
    
    
    
    @IBAction func selectImagePressed(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    @IBAction func nextPressed(_ sender: Any) {
        guard nameField.text != "", emailField.text != "", passwordField.text != "", conPwField.text != "" else{ return }
        if passwordField.text == conPwField.text{
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!, completion:{
                (user, error) in
                if let error = error{
                    print(error.localizedDescription)
                    let alert = UIAlertController(title: "Error", message: "this email address has already existed", preferredStyle:.alert)
                    let okAction = UIAlertAction(title: "Try Again", style:.cancel){
                        (action) in
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
                if let user = user{
                    let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                    
                    changeRequest.displayName = self.nameField.text!
                    
                    changeRequest.commitChanges(completion: nil)
                    
                    let imageRef = self.userStorage.child("\(user.uid).jpg")
                    
                    let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
                    
                    let uploadTask = imageRef.putData(data!, metadata: nil, completion: {
                        (metadata, err) in
                        if err != nil{
                            print(err!.localizedDescription)
                        }
                        imageRef.downloadURL(completion: { (url, er) in
                            if er != nil{
                                print(er!.localizedDescription)
                            }
                            if let url = url{
                                let userInfo:[String: Any] = ["uid": user.uid,
                                                              "username": self.nameField.text!,
                                                              "urlToImage": url.absoluteString]
                                self.ref.child("users").child(user.uid).setValue(userInfo)
                                let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVC")
                                self.present(vc, animated: true, completion: nil)
                            }
                        })
                    })
                    uploadTask.resume()
                }
            })
        }
        else{
            print("password does not match")
            let alert = UIAlertController(title: "Error", message: "the confirm password doesn't match the password", preferredStyle:.alert)
            let okAction = UIAlertAction(title: "Try Again", style:.cancel){
                (action) in
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.imageView.image = image
            nextBtn.isHidden = false
            cancelBtn.isHidden = false
            addProfileBtn.isHidden = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    

}
