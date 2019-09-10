//
//  Product.swift
//  Artable
//
//  Created by Egehan Karaköse on 9.09.2019.
//  Copyright © 2019 Egehan Karaköse. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Product {
    var name : String
    var id : String
    var category : String
    var price : Double
    var productDescription : String
    var imageUrl : String
    var timeStamp : Timestamp
    var stock : Int

    
    
    init(name: String, id: String, imageUrl: String ,price: Double ,stock: Int, timeStamp: Timestamp, productDescription : String,category: String) {
        self.name = name
        self.id = id
        self.imageUrl = imageUrl
        self.price = price
        self.category = category
        self.stock = stock
        self.productDescription = productDescription
        self.timeStamp = timeStamp
    }
    
    init(data : [String: Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.category = data["category"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0.0
        self.productDescription = data["productDescription"] as? String ?? ""
        self.imageUrl = data["imageUrl"] as? String ?? ""
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
        self.stock = data["stock"] as? Int ?? 0
    }
    
    
    static func modelToData(product: Product) -> [String: Any]{
        let data : [String :Any] = [
            "name" : product.name,
            "id" : product.id,
            "imageUrl": product.imageUrl,
            "category" : product.category,
            "stock": product.stock,
            "productDescription": product.productDescription,
            "price" : product.price,
            "timeStamp" : product.timeStamp
            
            
        ]
        return data
        
    }
}
