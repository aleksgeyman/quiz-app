//
//  QuestionsRepository.swift
//  QuizApp
//
//  Created by Aleksandar Geyman on 17.01.22.
//

import Foundation
import Combine

class QuestionsRepository: BaseRepository {
    private var questionsReceivedValue: AnyCancellable?
    
    func getQuestions(completion: ((([Question]?) -> Void))? = nil) {
        guard let bundlePath = Bundle.main.path(forResource: "questions", ofType: "json") else { return }
        
        questionsReceivedValue = fetch(url: URL(fileURLWithPath: bundlePath))
            .sink { _ in
                
            } receiveValue: { (questions: QuestionsModel) in
                completion?(questions.questions)
            }
    }
}
