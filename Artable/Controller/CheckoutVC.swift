//
//  CheckoutVC.swift
//  Artable
//
//  Created by Egehan Karaköse on 11.09.2019.
//  Copyright © 2019 Egehan Karaköse. All rights reserved.
//

import UIKit
import Stripe

class CheckoutVC: UIViewController, CartItemDelegate {

    @IBOutlet weak var acitivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var totalTxt: UILabel!
    @IBOutlet weak var shippingHandlingTxt: UILabel!
    @IBOutlet weak var feeTxt: UILabel!
    @IBOutlet weak var subTotalTxt: UILabel!
    @IBOutlet weak var shippingMethodBtn: UIButton!
    @IBOutlet weak var paymentMethodBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    var paymentContext : STPPaymentContext!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupTableView()
        setupPaymentInfo()
        setupStripeConfig()
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.CartItemCell, bundle: nil), forCellReuseIdentifier: Identifiers.CartItemCell)
        
    }
    func setupPaymentInfo(){
        subTotalTxt.text = StripeCart.subTotal.penniesToFormattedCurrency()
        feeTxt.text = StripeCart.processingFees.penniesToFormattedCurrency()
        shippingHandlingTxt.text = StripeCart.shippingFees.penniesToFormattedCurrency()
        totalTxt.text = StripeCart.total.penniesToFormattedCurrency()
        
    }
    
    func setupStripeConfig(){
        
        let config = STPPaymentConfiguration.shared()
        config.requiredBillingAddressFields = .none
        config.requiredShippingAddressFields = [.postalAddress]
        
        let customerContext = STPCustomerContext(keyProvider: StripeApi)
        paymentContext = STPPaymentContext(customerContext: customerContext, configuration: config, theme: .default())
        
        paymentContext.paymentAmount = StripeCart.total
        paymentContext.delegate = self
        paymentContext.hostViewController = self
        
    }
    
    @IBAction func placeOrderClicked(_ sender: Any) {
    }
    @IBAction func paymentClicked(_ sender: Any) {
        paymentContext.pushPaymentOptionsViewController()
       
        
    }
    
    @IBAction func shippingClicked(_ sender: Any) {
        paymentContext.pushShippingViewController()
    }
    
    func removeItem(product: Product) {
        StripeCart.removeItemFromCart(item: product)
        tableView.reloadData()
        setupPaymentInfo()
        paymentContext.paymentAmount = StripeCart.total
        
    }
}

extension CheckoutVC:  STPPaymentContextDelegate{
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        if let paymentMethod = paymentContext.selectedPaymentOption{
            paymentMethodBtn.setTitle(paymentMethod.label, for: .normal)
        }else{
            paymentMethodBtn.setTitle("Select Method", for: .normal)
        }
        
        
        if let shippingMethod = paymentContext.selectedShippingMethod{
            shippingMethodBtn.setTitle(shippingMethod.label, for: .normal)
            StripeCart.shippingFees = Int(Double(truncating: shippingMethod.amount) * 100)
            setupPaymentInfo()
        }else{
            shippingMethodBtn.setTitle("Select Method", for: .normal)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        acitivityIndicator.stopAnimating()
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        let retry = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.paymentContext.retryLoading()
        }
        
        alertController.addAction(cancel)
        alertController.addAction(retry)
        present(alertController, animated: true ,completion: nil)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        let upsGround = PKShippingMethod()
        upsGround.amount = 0
        upsGround.label = "Yurtiçi Kargo"
        upsGround.detail = "Varış 3-5 iş günü"
        upsGround.identifier = "ups_ground"
        
        
        let fedex = PKShippingMethod()
        fedex.amount = 10
        fedex.label = "MNG Kargo"
        fedex.detail = "Varış 2-3 iş günü"
        fedex.identifier = "fedex"
        
    
        if address.country == "TR" {
            completion(.valid, nil ,[upsGround,fedex], fedex)
        }else{
            completion(.invalid, nil,nil,nil)
        }
    }
    
}
extension CheckoutVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return StripeCart.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.CartItemCell, for: indexPath) as? CartItemCell {
            let product = StripeCart.cartItems[indexPath.row]
            cell.configureCell(product: product, delegate: self)
            
            return cell
            
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    
    
}
