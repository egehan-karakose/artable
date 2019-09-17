//
//  ViewController.swift
//  Artable
//
//  Created by Egehan Karaköse on 29.08.2019.
//  Copyright © 2019 Egehan Karaköse. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class HomeVC: UIViewController {

    @IBOutlet weak var loginOutButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var categories = [Category]()
    var selectedCategory : Category!
    var db : Firestore!
    var listener : ListenerRegistration!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        setupCollectionView()
        setupInitialAnonymousUser()
//        setupNavigationBar()
        
        
    }
    
    func setupNavigationBar(){
        guard let font = UIFont(name: "futura", size: 26) else {return}
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font: font]
        
    
    }
    
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: Identifiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CategoryCell)
        
    }
    
    func setupInitialAnonymousUser(){
        
        if Auth.auth().currentUser == nil{
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error{
                    Auth.auth().handleFireAuthError(error: error, vc:self)
                    debugPrint(error)
                }
            }
        }
        
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        //            fetchDocument()
        //        fetchCollection()
        setCategoriesListener()
        if let user = Auth.auth().currentUser , !user.isAnonymous{
           loginOutButton.title = "Logout"
            if UserService.userListener == nil{
                UserService.getCurrentUser()
            }
            
        }else{
            loginOutButton.title = "Login"
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
        categories.removeAll()
        collectionView.reloadData()
    }

    func setCategoriesListener() {
        listener = db.categories.addSnapshotListener({ (snap, error) in
            
            
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            snap?.documentChanges.forEach({ (change) in
                
                let data = change.document.data()
                let category = Category.init(data: data)
                
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, category: category)
                case .modified:
                    self.onDocumentModified(change: change, category: category)
                case .removed:
                    self.onDocumentRemoved(change: change)
                    
                }
                
            })
        })
       
    }
    
    
    
    fileprivate func presentLoginController() {
        let storyboard = UIStoryboard(name:Storyboard.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardId.LoginVC)
        present(controller, animated: true, completion: nil)
    }
    
    
    
    @IBAction func favoritesClicked(_ sender: Any) {
        performSegue(withIdentifier: Segues.ToFavorites, sender: self)
    }
    
    
    
    
    
    @IBAction func loginOutClicked(_ sender: Any) {
        
        guard let user = Auth.auth().currentUser else { return }
        if user.isAnonymous{
            presentLoginController()
        }else{
            do {
                try Auth.auth().signOut()
                UserService.logoutUser()
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error {
                        Auth.auth().handleFireAuthError(error: error, vc:self)
                        debugPrint(error)
                        
                    }
                    self.presentLoginController()
                }
            }catch{
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint(error)
                
            }
        }
        
        
    }
}

extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func onDocumentAdded(change : DocumentChange, category : Category){
        let newIndex = Int(change.newIndex)
        categories.insert(category, at: newIndex)
        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)])
        
    }
    
    func onDocumentModified(change: DocumentChange , category: Category){
        if change.newIndex == change.oldIndex{
            let index = Int(change.oldIndex)
            categories[index] = category
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }else{
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            categories.remove(at: oldIndex)
            categories.insert(category, at: newIndex)
            
            collectionView.moveItem(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
        }
        
    }
    func onDocumentRemoved(change : DocumentChange){
        let oldIndex = Int(change.oldIndex)
        categories.remove(at: oldIndex)
        collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: 0)])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CategoryCell, for: indexPath) as? CategoryCell{
            cell.configureCell(category: categories[indexPath.item])
            return cell
            
            
        }
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let cellWidth = (width - 30) / 2
        let cellHeight = cellWidth * 1.5
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: Segues.ToProducts, sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToProducts{
            if let destination = segue.destination as? ProductsVC{
               destination.category = selectedCategory
            }
        }else if segue.identifier == Segues.ToFavorites {
            if let desitination = segue.destination as? ProductsVC{
                desitination.category  = selectedCategory
                desitination.showFavorites = true
            }
        }
    }
    
   
    
    
}





// This is prior code left for referance

//    func fetchDocument() {
//        let docRef = db.collection("categories").document("z9Wf2qK9lGtPwg0lBxIz")
//
//        docRef.addSnapshotListener { (snap, error) in
//            self.categories.removeAll()
//            guard let data = snap?.data() else { return }
//            let newCategory = Category.init(data: data)
//            self.categories.append(newCategory)
//            self.collectionView.reloadData()
//        }
//
////        docRef.getDocument { (snap, error) in
////            guard let data = snap?.data() else { return }
////            let newCategory = Category.init(data: data)
////            self.categories.append(newCategory)
////            self.collectionView.reloadData()
////        }
//    }
//
//
//    func fetchCollection(){
//        let collectionReferance = db.collection("categories")
//
//
//       listener =  collectionReferance.addSnapshotListener { (snap, error) in
//            guard let documents = snap?.documents else { return }
//
//
//
//
//            self.categories.removeAll()
//            for document in documents{
//                let data = document.data()
//                let newCategory = Category.init(data: data)
//                self.categories.append(newCategory)
//            }
//            self.collectionView.reloadData()
//
//        }
////        collectionReferance.getDocuments { (snap, error) in
////            guard let documents = snap?.documents else { return }
////            for document in documents{
////                let data = document.data()
////                let newCategory = Category.init(data: data)
////                self.categories.append(newCategory)
////            }
////            self.collectionView.reloadData()
////        }
//
//    }


