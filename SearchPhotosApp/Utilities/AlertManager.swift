//
//  AlertManager.swift
//  SearchPhotos
//
//  Created by Gourav on 13/03/22.
//

import UIKit


class AlertManager {
    
    // MARK: - Alerts
    
    static func showErrorAlert(with message: String,view :UIViewController) {
        
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "OK", style: .default) {  _ in
        }
        alertController.addAction(retryAction)
        
        view.present(alertController, animated: true, completion: nil)
    }
}
