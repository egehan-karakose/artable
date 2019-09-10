//
//  ProductDetailVC.swift
//  Artable
//
//  Created by Egehan Karaköse on 10.09.2019.
//  Copyright © 2019 Egehan Karaköse. All rights reserved.
//

import UIKit
import Kingfisher


class ProductDetailVC: UIViewController {

    @IBOutlet weak var bgView: UIVisualEffectView!
    @IBOutlet weak var productDesc: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    var product : Product!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productTitle.text = product.name
        productDesc.text = product.productDescription
        
        if let url = URL(string: product.imageUrl){
            productImage.kf.setImage(with: url)
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber){
            productPrice.text = price
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissProduct(_:)))
        tap.numberOfTapsRequired = 1
        bgView.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissProduct(){
        dismiss(animated: true, completion: nil)
    }


    @IBAction func addCartClicked(_ sender: Any) {
        
        
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissProduct(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
