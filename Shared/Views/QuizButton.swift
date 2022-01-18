//
//  QuizButton.swift
//  QuizApp
//
//  Created by Aleksandar Geyman on 18.01.22.
//

import SwiftUI

struct QuizButton: View {
    let title: String
    let action: (() -> Void)?
    
    var body: some View {
        Button {
            action?()
        } label: {
            Text(title.uppercased())
                .font(.body)
                .bold()
                .padding(.horizontal, Paddings.large)
        }
        .buttonStyle(.borderedProminent)
    }
}
