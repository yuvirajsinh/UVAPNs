//
//  InputFieldView.swift
//  Easy APNS
//
//  Created by Yuvrajsinh Jadeja on 03/07/21.
//

import SwiftUI

struct InputFieldView: View {
    let title: String
    var titleWidth: CGFloat?
    @Binding var value: String
    
    var body: some View {
        HStack(alignment: .center, spacing: nil, content: {
            let tWidth: CGFloat = titleWidth ?? CGFloat.infinity
            Text(title)
                .font(.title3)
                .frame(width: tWidth, alignment: .leading)
            TextField(title, text: $value)
                .font(.body)
                .clipShape(Capsule())
        })
    }
}

struct InputFieldView_Previews: PreviewProvider {
    static var previews: some View {
        InputFieldView(title: "Some ID", titleWidth: 80, value: .constant(""))
    }
}
