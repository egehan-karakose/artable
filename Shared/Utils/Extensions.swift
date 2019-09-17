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

extension Int {
    func penniesToFormattedCurrency() -> String{
        
        let dollars = Double(self) / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let dollarString = formatter.string(from: dollars as NSNumber){
            return dollarString
        }
        return "$0.00"
        
    }
}


