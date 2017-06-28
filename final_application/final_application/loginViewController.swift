//
//  loginViewController.swift
//  final_application
//
//  Created by Cheng Enzo on 2017/6/4.
//  Copyright © 2017年 Cheng Enzo. All rights reserved.
//

import UIKit
import Firebase

class loginViewController: UIViewController {
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func bgTouchDown(_ sender: UIControl) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    @IBAction func textDone(_ sender: UITextField) {
        self.resignFirstResponder()
    }
    @IBAction func loginPressed(_ sender: Any) {
        
        guard emailField.text != "", passwordField.text != "" else {
            let alert = UIAlertController(title:"Error!", message:"email field or password shuldn't be empty", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel){
                (action) in
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return }
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if let error = error{
                let alert = UIAlertController(title:"Error!", message:"invalid email address or wrong password", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel){
                    (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                print(error.localizedDescription)
            }
            if let user = user{
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "feedVC")
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    

}
