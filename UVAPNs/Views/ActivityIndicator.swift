//
//  ActivityIndicator.swift
//  UVAPNs
//
//  Created by Yuvrajsinh Jadeja on 06/07/22.
//

import SwiftUI

/// https://programmingwithswift.com/swiftui-activity-indicator/
/// A wrapper to use `NSProgressIndicator` from `AppKit`
struct ActivityIndicator: NSViewRepresentable {
    typealias NSViewType = NSProgressIndicator
    
    @Binding var shouldAnimate: Bool
    
    func makeNSView(context: Context) -> NSProgressIndicator {
        let indicator = NSProgressIndicator()
        indicator.style = .spinning
        indicator.isDisplayedWhenStopped = false
        return indicator
    }
    
    func updateNSView(_ nsView: NSProgressIndicator, context: Context) {
        if shouldAnimate {
            nsView.startAnimation(nil)
        }
        else {
            nsView.stopAnimation(nil)
        }
    }
}

#if DEBUG
struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator(shouldAnimate: .constant(true))
    }
}
#endif
