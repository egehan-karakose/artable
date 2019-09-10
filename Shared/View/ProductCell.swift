//
//  ProductCell.swift
//  Artable
//
//  Created by Egehan Karaköse on 9.09.2019.
//  Copyright © 2019 Egehan Karaköse. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCell: UITableViewCell {

    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var productImg: RoundedImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell(product : Product){
        productTitle.text = product.name
        if let url = URL(string: product.imageUrl){
            productImg.kf.setImage(with: url)
            
            
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let productPrice = formatter.string(from: product.price as NSNumber){
            price.text = productPrice
        }
    }
    
    @IBAction func addTOCartClicked(_ sender: Any) {
    }
    @IBAction func favoriteClicked(_ sender: Any) {
    }
    
}
