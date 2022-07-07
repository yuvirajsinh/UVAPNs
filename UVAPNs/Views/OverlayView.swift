//
//  OverlayView.swift
//  UVAPNs
//
//  Created by Yuvrajsinh Jadeja on 07/07/22.
//

import SwiftUI

// https://gist.github.com/ajjames/6c1b7cdb3719f6ed7e27c857ba17659e
struct OverlayView<OverlayContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    var modalContent: OverlayContent
    var transition: AnyTransition = .move(edge: .bottom)
    var animation: Animation = .easeInOut
    
    func body(content: Content) -> some View {
        GeometryReader { geo in
            ZStack {
                
                content
                
                VStack {
                    if self.isPresented {
                        self.modalContent
                            .transition(self.transition)
                            .animation(self.animation, value: 1)
                    } else {
                        Spacer()
                    }
                }
                
            }
        }
    }
}

extension View {
    func overlayModal<ModalContent: View>(isPresented: Binding<Bool>, @ViewBuilder modalContent: @escaping () -> ModalContent) -> some View {
        self.modifier(OverlayView(isPresented: isPresented, modalContent: modalContent()))
    }
}
