//
//  Firebase+Utils.swift
//  Artable
//
//  Created by Egehan Karaköse on 1.09.2019.
//  Copyright © 2019 Egehan Karaköse. All rights reserved.
//

import Firebase


extension Firestore{
    var categories: Query{
        return collection("categories").order(by: "timeStamp", descending: true)
    }
    
    func products(category: String) -> Query{
        return collection("products").whereField("category", isEqualTo: category).order(by:"timeStamp", descending: true)
    }
}

extension Auth{
    
    func handleFireAuthError(error: Error, vc: UIViewController){
        
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            vc.present(alert,animated: true,completion: nil)
        }
        
    }
    
    
    
    
}
extension AuthErrorCode {
    var errorMessage: String{
        switch self {
        case .emailAlreadyInUse:
            return  "The email is already in use with another account."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Invalid email address."
        case .userNotFound:
            return "Account not found"
        case .userDisabled:
            return "Your account has been disabled"
        case .networkError:
            return "Network Error"
        case .wrongPassword:
            return "Your password is incorrect!"
        case .weakPassword:
            return "Your password is too weak, It must be 6 characters long or more"
            
        default:
            return "Sorry, Something Went Wrong!"
            
        }
        
    }
}
