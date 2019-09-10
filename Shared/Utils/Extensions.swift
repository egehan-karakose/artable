//
//  Extensions.swift
//  Artable
//
//  Created by Egehan Karaköse on 29.08.2019.
//  Copyright © 2019 Egehan Karaköse. All rights reserved.
//

import UIKit
import Firebase


extension String{
    
    var isNotEmpty:Bool{
        return !isEmpty
    }
}

extension UIViewController {
   
    func simpleAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert,animated: true, completion: nil)
        
    }
}


