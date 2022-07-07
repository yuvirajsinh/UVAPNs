//
//  MultilineInputFieldView.swift
//  Easy APNS
//
//  Created by Yuvrajsinh Jadeja on 03/07/21.
//

import SwiftUI

struct MultilineInputFieldView: View {
    let title: String
    var titleWidth: CGFloat?
    let inputFieldHeight: CGFloat
    @Binding var value: String
    
    var body: some View {
        HStack(alignment: .top, spacing: nil, content: {
            let tWidth: CGFloat = titleWidth ?? CGFloat.infinity
            Text(title)
                .font(.title3)
                .frame(width: tWidth, alignment: .leading)
            TextEditor(text: $value)
                .font(.body)
                .frame(width: .infinity, height: inputFieldHeight, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 5.0, style: .continuous))
        })
    }
}

// HACK to work-around the smart quote issue
extension NSTextView {
    open override var frame: CGRect {
        didSet {
            self.isAutomaticQuoteSubstitutionEnabled = false
        }
    }
}

struct MultilineInputFieldView_Previews: PreviewProvider {
    static var previews: some View {
        MultilineInputFieldView(title: "Some title", inputFieldHeight: 50, value: .constant("value"))
    }
}

