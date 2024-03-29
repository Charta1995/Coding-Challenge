//
//  Alerts.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 29/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit
class Alerts {
    
    private var alertController: UIAlertController!
    
    func presentStandardOKAlert(title: String, message: String, okActionTitle: String) -> UIAlertController {
        alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: okActionTitle, style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(okAction)
        return alertController
    }
    
    func presentShareController(contentToShare: [Any], viewHolder: UIView) -> UIActivityViewController {
        let shareActivity = UIActivityViewController(activityItems: contentToShare, applicationActivities: nil)
        shareActivity.popoverPresentationController?.sourceView = viewHolder
        return shareActivity
    }
    
    func presentLoadingAlert(onCancel: @escaping () -> ()) -> UIAlertController {
        alertController = UIAlertController(title: "Searching, please wait", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) in
            onCancel()
        }
        alertController.addAction(cancelAction)
        return alertController
    }
    
    func forceClose() {
        if alertController != nil {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
}
