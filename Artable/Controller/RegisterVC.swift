 //
//  RegisterVC.swift
//  Artable
//
//  Created by Egehan Karaköse on 29.08.2019.
//  Copyright © 2019 Egehan Karaköse. All rights reserved.
//

import UIKit
 import Firebase

class RegisterVC: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var confirmPassTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordCheck: UIImageView!
    
    @IBOutlet weak var confirmPassCheck: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTxt.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: UIControl.Event.editingChanged)
        confirmPassTxt.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChanged(_ textField:UITextField){
        guard let passTxt = passwordTxt.text else { return }
        
        if (textField == confirmPassTxt){
            passwordCheck.isHidden = false
            confirmPassCheck.isHidden = false
        }else {
            if passTxt.isEmpty{
                passwordCheck.isHidden = true
                confirmPassCheck.isHidden = true
                confirmPassTxt.text = ""
            }
            
        }
        
        
        
        if passwordTxt.text == confirmPassTxt.text{
            
            passwordCheck.image = UIImage(named: AppImages.GreenCheck)
            confirmPassCheck.image = UIImage(named: AppImages.GreenCheck)
        }else{
            passwordCheck.image = UIImage(named: AppImages.RedCheck)
            confirmPassCheck.image = UIImage(named: AppImages.RedCheck)
        }
        
    }

 
    @IBAction func registerClicked(_ sender: Any) {
        
        
        guard let email = emailTxt.text , email.isNotEmpty,
            let username = usernameTxt.text , username.isNotEmpty,
            let password = passwordTxt.text , password.isNotEmpty else {
                self.simpleAlert(title: "Erroe", msg: "Please fill out all fields")
                return }
        
        guard let confirmPass = confirmPassTxt.text, confirmPass == password else {
            self.simpleAlert(title: "Error", msg: "Passwords do not match")
            return
        }
        
        activityIndicator.startAnimating()
        
        guard let authUser = Auth.auth().currentUser else { return }
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        
        authUser.link(with: credential) { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                Auth.auth().handleFireAuthError(error: error , vc: self)
                return
            }
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
    
        }
    }
    
}
