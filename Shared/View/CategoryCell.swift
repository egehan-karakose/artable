//
//  CategoryCell.swift
//  Artable
//
//  Created by Egehan Karaköse on 9.09.2019.
//  Copyright © 2019 Egehan Karaköse. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        categoryImg.layer.cornerRadius = 5
        
    }
    
    func configureCell(category : Category){
        nameLabel.text = category.name
        if let url = URL(string: category.imgUrl){
            let placeholder = UIImage(named: AppImages.Placeholder)
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            categoryImg.kf.indicatorType = .activity
            categoryImg.kf.setImage(with: url, placeholder: placeholder, options: options)
            
        }
        
    }

}
