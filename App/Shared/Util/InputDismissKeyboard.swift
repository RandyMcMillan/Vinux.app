//
//  InputDismissKeyboard.swift
//  damus
//
//  Created by William Casarin on 2022-07-02.
//

import Foundation
import SwiftUI

public extension View {
    func dismissKeyboardOnTap() -> some View {
        modifier(DismissKeyboardOnTap())
    }
}

public struct DismissKeyboardOnTap: ViewModifier {
    public func body(content: Content) -> some View {
#if !os(macOS) || targetEnvironment(macCatalyst)
        return content.gesture(tapGesture)
#else
        return content
#endif
    }

    private var tapGesture: some Gesture {
        TapGesture().onEnded(end_editing)
    }

}

func end_editing() {
#if !os(macOS) || targetEnvironment(macCatalyst)
    UIApplication.shared.connectedScenes
      .filter {$0.activationState == .foregroundActive}
      .map {$0 as? UIWindowScene}
      .compactMap({$0})
      .first?.windows
      .filter {$0.isKeyWindow}
      .first?.endEditing(true)
#else
    // TODO: better macOS support
#endif
}
