//
//  ViewModifier.swift
//  KWDC_Check-in
//
//  Created by mac on 9/18/24.
//

import Foundation
import SwiftUI

struct AlertButtonTintColor: ViewModifier {
    let color: Color
    @State private var previousTintColor: UIColor?

    func body(content: Content) -> some View {
        content
            .onAppear {
                previousTintColor = UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor

                UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(color)
            }
            .onDisappear {
                UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = previousTintColor
            }
    }
}

struct AlertButtonTintColor2: ViewModifier {
    let color: UIColor

    func body(content: Content) -> some View {
        content
            .background(AlertPresenter(tintColor: color))
    }
}

struct AlertPresenter: UIViewControllerRepresentable {
    let tintColor: UIColor

    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController() // Empty UIViewController to host the alert
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            if let presentedVC = uiViewController.presentedViewController as? UIAlertController {
                // Loop through actions and apply the tint color
                presentedVC.view.tintColor = tintColor
                for action in presentedVC.actions {
                    action.setValue(tintColor, forKey: "titleTextColor")
                }
            }
        }
    }
}

extension View {
    func alertButtonTintColor(_ color: UIColor) -> some View {
        self.modifier(AlertButtonTintColor2(color: color))
    }
}
