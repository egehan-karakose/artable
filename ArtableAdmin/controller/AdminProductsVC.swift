//
//  AdminProductsVC.swift
//  ArtableAdmin
//
//  Created by Egehan Karaköse on 10.09.2019.
//  Copyright © 2019 Egehan Karaköse. All rights reserved.
//

import UIKit

class AdminProductsVC: ProductsVC {
    
    var selectedProduct: Product?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editCategoryBtn = UIBarButtonItem(title: "Edit Category", style: .plain, target: self, action: #selector(editCategory))
        
        let newProductBtn = UIBarButtonItem(title: "+ Product", style: .plain, target: self, action: #selector(newProduct))
        
        
        navigationItem.setRightBarButtonItems([editCategoryBtn ,newProductBtn], animated: false)
        
       
        
    }
    
    
    @objc func editCategory(){
        
        performSegue(withIdentifier: Segues.ToEditCategory, sender: self)
        
    }
    
    @objc func newProduct(){
        selectedProduct = nil 
        performSegue(withIdentifier: Segues.ToAddEditProduct, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: Segues.ToAddEditProduct, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.ToAddEditProduct {
            if let destination = segue.destination as? AddEditProductsVC{
                destination.selectedCategory = category
                destination.productToEdit = selectedProduct
            }
        }else if segue.identifier == Segues.ToEditCategory {
            if let destination = segue.destination as? AddEditCategoryVC{
                destination.categoryToEdit = category
            }
        }
    }
    
    override func productFavorited(product: Product) {
        return
    }
    
    override func productAddToCart(product: Product) {
        return
    }
    


}
