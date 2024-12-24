//
//  View +.swift
//  KWDC_Check-in
//
//  Created by mac on 9/3/24.
//

import Foundation
import SwiftUI
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func alertButtonTint(color: Color) -> some View {
        modifier(AlertButtonTintColor(color: color))
    }
    
    func captionViewModifier() -> some View {
        modifier(CaptionDynamicFontModifier())
    }
    
    func titleViewModifier() -> some View {
        modifier(TitleDynamicFontModifier())
    }
}
#endif
