//
//  Constants.swift
//  Artable
//
//  Created by Egehan Karaköse on 29.08.2019.
//  Copyright © 2019 Egehan Karaköse. All rights reserved.
//

import Foundation
import UIKit

struct Storyboard {
    static let LoginStoryboard = "LoginStoryboard"
    static let Main = "Main"
    
}

struct StoryboardId {
    static let LoginVC = "loginVC"
    
}

struct AppImages{
    static let GreenCheck = "green_check"
     static let RedCheck = "red_check"
    static let FilledStar = "filled_star"
    static let EmptyStar = "empty_star"
    static let Placeholder = "placeholder"
    
}

struct AppColors {
    
    static let Blue = #colorLiteral(red: 0.2274509804, green: 0.2666666667, blue: 0.3607843137, alpha: 1)
    static let Red = #colorLiteral(red: 0.8352941176, green: 0.3921568627, blue: 0.3137254902, alpha: 1)
    static let OffWhite = #colorLiteral(red: 0.9529411765, green: 0.9490196078, blue: 0.968627451, alpha: 1)
    
}

struct Identifiers {
    static let CategoryCell = "CategoryCell"
    static let ProductCell = "ProductCell"
    static let CartItemCell = "CartItemCell"
    
}

struct Segues {
    static let ToProducts = "toProductsVC"
    static let ToAddEditCategory = "ToAddEditCategory"
    static let ToEditCategory = "ToEditCategory"
    static let ToAddEditProduct = "ToAddEditProduct"
    static let ToFavorites = "ToFavorites"
}
