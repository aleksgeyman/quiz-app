//
//  ResultsScreen.swift
//  QuizApp
//
//  Created by Aleksandar Geyman on 18.01.22.
//

import SwiftUI

struct ResultsScreen: View {
    let numberOfCorrectAnswers: Int
    
    var body: some View {
        Image("finish-icon")
            .padding(.bottom, Paddings.large)
        Text(getReview(correctAnswers:numberOfCorrectAnswers))
            .bold()
            .font(.subheadline)
    }
    
    private func getReview(correctAnswers: Int) -> String {
        let text: String
        switch correctAnswers {
        case 5:
            text = "Perfect!"
        case 4:
            text = "Excellent result, almost perfect!"
        case 3:
            text = "Not bad."
        case 2:
            text = "You can do better."
        case 1:
            text = "Better than nothing."
        case 0:
            text = "Did you at least try?"
        default:
            text = "Congratulations!"
        }
        return text
    }
}
