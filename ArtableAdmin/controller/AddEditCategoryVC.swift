//
//  AddEditCategoryVC.swift
//  ArtableAdmin
//
//  Created by Egehan Karaköse on 10.09.2019.
//  Copyright © 2019 Egehan Karaköse. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditCategoryVC: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categoryImage: RoundedImageView!
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var addBtn: UIButton!
    
    var categoryToEdit : Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(_:)))

        tap.numberOfTapsRequired = 1
        categoryImage.isUserInteractionEnabled = true
        categoryImage.addGestureRecognizer(tap)
        
        
        if let category = categoryToEdit {
            nameText.text = category.name
            addBtn.setTitle("Save Changes", for: .normal)
            
            if let url = URL(string: category.imgUrl){
                categoryImage.contentMode = .scaleToFill
                categoryImage.kf.setImage(with: url)
            }
        }
        
    }
    
    
    @objc func imgTapped(_ tap: UITapGestureRecognizer){
        launchImagePicker()
        
    }
    
    @IBAction func addCategoryClicked(_ sender: Any) {
        activityIndicator.startAnimating()
        uploadImageThenDocument()
        
    }
    
    func uploadImageThenDocument(){
        guard let image = categoryImage.image ,
            let categoryName = nameText.text , categoryName.isNotEmpty else {
                simpleAlert(title: "Error" , msg: "Must add category image and name" )
                return
                
                
        }
        
        //        Step 1 : Turn image into Data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {return}
        
        //      Step 2: Create a storage image referance -> A location in Firestore for it to be stored.
        let imageRef = Storage.storage().reference().child("/categoryImages/\(categoryName).jpg")
        
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
        var docRef: DocumentReference!
        var category = Category.init(name: nameText.text! , id: "" , imgUrl: url , timeStamp: Timestamp())
        
        
        if let categoryToEdit = categoryToEdit{
            
            docRef = Firestore.firestore().collection("categories").document(categoryToEdit.id)
            category.id = categoryToEdit.id
            
        }else{
            docRef = Firestore.firestore().collection("categories").document()
            category.id = docRef.documentID
            
        }
        
       
        
        let data = Category.modelToData(category: category)
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


extension AddEditCategoryVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func launchImagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker,animated: true,completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        categoryImage.contentMode = .scaleAspectFill
        categoryImage.image = image
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
