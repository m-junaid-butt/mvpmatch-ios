//
//  UIViewController.swift
//  MVP Match
//
//  Created by Junaid Butt on 2/8/22.
//

import Foundation
import UIKit
import Toast_Swift

extension UIViewController {
   
    //Error Alert 
    func showAlert(title: String,
                   message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAaction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertVC.addAction(okAaction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func showActivityView() {
        self.view.isUserInteractionEnabled = false
        self.view.makeToastActivity(.center)
    }
    
    func hideActivityView() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            self.view.hideToastActivity()
        }
    }
}
