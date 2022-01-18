//
//  QuestionsScreenViewModel.swift
//  QuizApp
//
//  Created by Aleksandar Geyman on 17.01.22.
//

import Foundation
import SwiftUI

enum QuestionState {
    case submitAnswer
    case nextQuestion
    case getResults
    
    var title: String {
        let title: String
        switch self {
        case .getResults:
            title = "See Results"
        case .submitAnswer:
            title = "Submit"
        case .nextQuestion:
            title = "Next Question"
        }
        return title
    }
}

class QuestionsScreenViewModel: ObservableObject {
    @Published var currentQuestion: Question?
    @Published var buttonType: QuestionState = .submitAnswer
    @Published var currentQuestionNumber: Int = 0
    @Published var showAnswer: Bool? = false
    @Published var isGameCompleted: Bool = false
    @Published var didTimerExpire: Bool = false
    var correctAnswers: Int = 0
    var numberOfQuestions: Int {
        questions?.count ?? 0
    }
    
    private let repository = QuestionsRepository()
    private var shouldBreakTimer: Bool = false
    private var questions: [Question]? {
        didSet {
            setVisibleQuestion(questionNumber: 0)
        }
    }
    
    func getQuestions() {
        repository.getQuestions { [weak self] questions in
            self?.questions = questions
        }
        startGameTimer()
    }
    
    func didTapOnMainButton(selectedAnswer: Int) {
        switch buttonType {
        case .submitAnswer:
            showAnswer = true
            setButtonType()
            checkAnswer(selectedAnswer: selectedAnswer)
        case .nextQuestion:
            showAnswer = false
            buttonType = .submitAnswer
            getNextQuestion()
        case .getResults:
            isGameCompleted = true
            shouldBreakTimer = true
        }
    }
    
    private func getNextQuestion() {
        currentQuestionNumber += 1
        if currentQuestionNumber == questions?.count {
            buttonType = .getResults
            return
        }
        
        setVisibleQuestion(questionNumber: currentQuestionNumber)
    }
    
    private func checkAnswer(selectedAnswer: Int) {
        if selectedAnswer == currentQuestion?.correct {
           correctAnswers += 1
        }
    }
    
    private func setButtonType() {
        guard let questionsNumber = questions?.count else { return }
        buttonType = (currentQuestionNumber < questionsNumber - 1) ? .nextQuestion : .getResults
    }
    
    private func setVisibleQuestion(questionNumber: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.currentQuestion = self?.questions?[questionNumber]
        }
    }
    
    private func startGameTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.gameDuration) { [weak self] in
            guard let self = self, !self.shouldBreakTimer else { return }
            self.didTimerExpire = true
        }
    }
}
