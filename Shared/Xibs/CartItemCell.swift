//
//  CartItemCell.swift
//  Artable
//
//  Created by Egehan Karaköse on 11.09.2019.
//  Copyright © 2019 Egehan Karaköse. All rights reserved.
//

import UIKit
import Kingfisher

protocol CartItemDelegate : class{
    func removeItem(product: Product)
}

class CartItemCell: UITableViewCell {

    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var productImage: RoundedImageView!
    @IBOutlet weak var removeItemBtn: UIButton!
    
    
    private var item : Product!
    weak var delegate : CartItemDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(product: Product , delegate : CartItemDelegate){
        
        self.delegate = delegate
        self.item = product
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber){
               productTitleLbl.text = "\(product.name) \(price)"
        }
        
        if let url = URL(string: product.imageUrl){
            let placeholder = UIImage(named: AppImages.Placeholder)
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            productImage.kf.indicatorType = .activity
            productImage.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
        
        
        
        
        
    }
    @IBAction func removeItemClicked(_ sender: Any) {
        
        delegate?.removeItem(product: item)
        
        
    }
}
