//
//  AsyncButton +.swift
//  KWDC_Check-in
//
//  Created by mac on 9/12/24.
//

import Foundation
import AsyncButton
import SwiftUI

extension AsyncButton where Label == Text {
    public init(
        _ titleKey: String,
        _ tableName: String?,
        _ comment: StaticString? = nil,
        _ bundle: Bundle? = nil,
        role: ButtonRole? = nil,
        options: AsyncButtonOptions = .automatic,
        transaction: Transaction = Transaction(animation: .default),
        action: @escaping () async throws -> Void
    ) {
        self.init(role: role, options: options, transaction: transaction, action: action) { operations in
            Text(LocalizedStringKey(titleKey), tableName: tableName, bundle: bundle, comment: comment)
        }
    }
}
