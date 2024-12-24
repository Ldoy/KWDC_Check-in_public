//
//  AddPassDelegate.swift
//  KWDC_Check-in
//
//  Created by mac on 9/11/24.
//

import Foundation
import PassKit

protocol PassDelegatable: PKAddPassesViewControllerDelegate {
    var isFinished: Bool { get set }
}

@Observable final class AddPassDelegate: NSObject, PassDelegatable {
    var isFinished: Bool = false
    
    func addPassesViewControllerDidFinish(_ controller: PKAddPassesViewController) {
        self.isFinished = true
        controller.dismiss(animated: true)
    }
}
