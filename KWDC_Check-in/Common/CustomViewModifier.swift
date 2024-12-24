//
//  CustomViewModifier.swift
//  KWDC_Check-in
//
//  Created by mac on 9/23/24.
//

import Foundation
import SwiftUI

struct CaptionDynamicFontModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .dynamicTypeSize(.xSmall ... .accessibility5)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct TitleDynamicFontModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .dynamicTypeSize(.xSmall ... .accessibility5)
            .fixedSize(horizontal: false, vertical: true)
    }
}
