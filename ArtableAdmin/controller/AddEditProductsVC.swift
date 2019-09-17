//
//  AddEditProductsVC.swift
//  ArtableAdmin
//
//  Created by Egehan Karaköse on 10.09.2019.
//  Copyright © 2019 Egehan Karaköse. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditProductsVC: UIViewController {

    @IBOutlet weak var addBtn: RoundedButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var productDescrpitionTxt: UITextView!
    @IBOutlet weak var productPriceTxt: UITextField!
    @IBOutlet weak var productNameTxt: UITextField!
    @IBOutlet weak var productImageView: RoundedImageView!
    
    var selectedCategory : Category!
    var productToEdit: Product?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(_:)))
        tap.numberOfTapsRequired = 1
        productImageView.isUserInteractionEnabled = true
        productImageView.addGestureRecognizer(tap)
        
        
        if let product = productToEdit {
            
            productNameTxt.text = product.name
            productDescrpitionTxt.text = product.productDescription
            productPriceTxt.text = String(product.price)
            
            addBtn.setTitle("Save Changes", for: .normal)
            
            if let url = URL(string: product.imageUrl){
                productImageView.contentMode = .scaleToFill
                productImageView.kf.setImage(with: url)
            }
        }
    }
    
   
    

    @objc func imgTapped(_ tap: UITapGestureRecognizer){
        launchImagePicker()
        
    }
    
    
  
    @IBAction func addProductClicked(_ sender: Any) {
        
        uploadImageThenDocument()
    }
    
    
    
    
    func uploadImageThenDocument(){
        guard let image = productImageView.image ,
            let productName = productNameTxt.text ,
            productName.isNotEmpty,
            let productDescription = productDescrpitionTxt.text,
            productDescription.isNotEmpty,
            let productPriceString = productPriceTxt.text,
            productPriceString.isNotEmpty
        else {
                simpleAlert(title: "Error" , msg: "Must fill all required fields" )
                return
        }
        activityIndicator.startAnimating()
        
        //        Step 1 : Turn image into Data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {return}
        
        //      Step 2: Create a storage image referance -> A location in Firestore for it to be stored.
        let imageRef = Storage.storage().reference().child("/productImage/\(productName).jpg")
        
        //        Step 3: Set the meta data
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        //        Step 4: upload Data
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error{
                self.handleError(error: error, msg: "Unable to Upload to image")
                return
            }
            
            
            //    Step 5: Once the image is uploaded , retrieve the download URL.
            
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error{
                    self.handleError(error: error, msg: "Unable to retrieve image URL.")
                    return
                }
                
                guard let url = url else { return }
                
                
                //                Step 6: Upload new Category documnet to the firestore categories collection
                self.uploadDocument(url: url.absoluteString)
                
                
            })
            
        }
        
        
        
        
        
    }
    func uploadDocument(url : String){
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current // USA: Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        let price = formatter.number(from: productPriceTxt.text!)
        
        var docRef: DocumentReference!
        var product = Product.init(name: productNameTxt.text!, id: "", imageUrl: url, price: price as! Double, stock: 0, timeStamp: Timestamp(), productDescription: productDescrpitionTxt.text!, category: selectedCategory.id)
        
        
        if let productToEdit = productToEdit{
            
            docRef = Firestore.firestore().collection("products").document(productToEdit.id)
            product.id = productToEdit.id
            
        }else{
            docRef = Firestore.firestore().collection("products").document()
            product.id = docRef.documentID
            
        }
        
        
        
        let data = Product.modelToData(product: product)
        docRef.setData(data, merge: true) { (error) in
            if let error = error{
                self.handleError(error: error, msg: "Unable to Upload to new category to Firestore")
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    func handleError(error :Error, msg: String){
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error", msg: msg)
        self.activityIndicator.stopAnimating()
        
    }
}

extension AddEditProductsVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func launchImagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker,animated: true,completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        productImageView.contentMode = .scaleAspectFill
        productImageView.image = image
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
