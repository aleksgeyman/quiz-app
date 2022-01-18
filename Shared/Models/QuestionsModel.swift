//
//  QuestionsModel.swift
//  QuizApp
//
//  Created by Aleksandar Geyman on 17.01.22.
//

import Foundation

struct QuestionsModel: Codable {
    let questions: [Question]
}

struct Question: Codable {
    let question: String
    let content: [String]
    let correct: Int
}
