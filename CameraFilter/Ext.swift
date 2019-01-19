//
//  Ext.swift
//  CameraFilter
//
//  Created by Munesada Yohei on 2019/01/18.
//  Copyright © 2019 Munesada Yohei. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        })
        self.present(alert, animated: true)
    }
    
}
