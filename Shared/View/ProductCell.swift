//
//  ProductCell.swift
//  Artable
//
//  Created by Egehan Karaköse on 9.09.2019.
//  Copyright © 2019 Egehan Karaköse. All rights reserved.
//

import UIKit
import Kingfisher

protocol ProductCellDelegate : class{
    func  productFavorited(product: Product)
    func productAddToCart(product: Product)
}


class ProductCell: UITableViewCell {

    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var productImg: RoundedImageView!

    
    
    
    
    weak var delegate: ProductCellDelegate?
    var product :Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell(product : Product , delegate : ProductCellDelegate){
        
        self.product = product
        self.delegate = delegate
        
        productTitle.text = product.name
        if let url = URL(string: product.imageUrl){
            let placeholder = UIImage(named: AppImages.Placeholder)
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            productImg.kf.indicatorType = .activity
            productImg.kf.setImage(with: url, placeholder: placeholder, options: options)
            
            
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let productPrice = formatter.string(from: product.price as NSNumber){
            price.text = productPrice
        }
        
        if UserService.favorites.contains(product){
            favoriteBtn.setImage(UIImage(named: AppImages.FilledStar), for: .normal)
        }else{
            favoriteBtn.setImage(UIImage(named: AppImages.EmptyStar), for: .normal)
        }
    }
    
    @IBAction func addToCartClicked(_ sender: Any) {
        delegate?.productAddToCart(product: product)
    }
    @IBAction func favoriteClicked(_ sender: Any) {
        delegate?.productFavorited(product: product)
        
        
    }
    
}
