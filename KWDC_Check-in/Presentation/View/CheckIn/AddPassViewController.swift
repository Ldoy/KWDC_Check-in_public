//
//  AddPassViewController.swift
//  KWDC_Check-in
//
//  Created by mac on 9/4/24.
//

import Foundation
import PassKit
import SwiftUI

struct AddPassesViewController: UIViewControllerRepresentable {
    var pass: PKPass?
    var delegate: PassDelegatable
    
    func makeUIViewController(context: Context) -> PKAddPassesViewController {
        
        let emptyVC = PKAddPassesViewController()
        
        //TODO: 스레드 에러 원인 찾기
        //        guard let pass = self.passData else {
        //            return emptyVC
        //        }
        
        //왜 여기서 아래 스레드 에러가 생기지???
        //        guard let pkPass = try? PKPass(data: pass) else{
        //            return emptyVC
        //        }
        
        //왜 여기서 아래 스레드 에러가 생기지??? => 해결은 했는데.. 왜지..?
        guard let pass = pass, 
                let addPassesVC = PKAddPassesViewController(pass: pass) else {
            return emptyVC
        }
        
        addPassesVC.delegate = self.delegate
        return addPassesVC
    }
    
    func updateUIViewController(_ uiViewController: PKAddPassesViewController, context: Context) {
        
    }
}
