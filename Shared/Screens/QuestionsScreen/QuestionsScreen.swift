//
//  QuestionsScreen.swift
//  QuizApp
//
//  Created by Aleksandar Geyman on 17.01.22.
//

import SwiftUI

struct QuestionsScreen: View {
    @ObservedObject var viewModel: QuestionsScreenViewModel
    @Binding var isQuestionsScreenActive: Bool
    @State private var selectedAnswer: Int = -1
    @State private var isSelected: [Bool?] = [false, false, false, false]
    private var isButtonEnabled: Bool {
        !isSelected.contains(true)
    }
    
    var body: some View {
        if viewModel.didTimerExpire {
            gameExpiredView()
        } else {
            gameView()
                .padding(.horizontal, Paddings.medium)
        }
    }
    
    private func gameExpiredView() -> some View {
        VStack(spacing: Paddings.large) {
            Text("Time's up :(")
                .bold()
                .font(.title2)
            Image(systemName: "face.dashed.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(Color.yellow)
            QuizButton(title: "Try Again") {
                isQuestionsScreenActive = false
            }
        }
    }
    
    private func gameView() -> some View {
        VStack(alignment: .center, spacing: Paddings.small) {
            questionsCountView()
            questionText()
            if let questions = viewModel.currentQuestion?.content {
                answers(questions)
            }
            mainButton()
        }
        .sheet(isPresented: $viewModel.isGameCompleted,
               onDismiss: {},
               content: {
            ResultsScreen(numberOfCorrectAnswers: viewModel.correctAnswers)
        })
        .onAppear {
            viewModel.getQuestions()
        }
    }
    
    private func questionsCountView() -> some View {
        HStack() {
            Spacer()
            Text("Question \(viewModel.currentQuestionNumber + 1) of \(viewModel.numberOfQuestions)")
                .font(.caption)
        }
    }
    
    private func questionText() -> some View {
        HStack() {
            Text(viewModel.currentQuestion?.question ?? "")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.bottom, Paddings.small)
        }
    }
    
    private func answers(_ answers: [String]) -> some View {
        ForEach(0..<answers.count, id: \.self) { index in
            Answer(isSelected: $isSelected[index],
                   showAnswer: $viewModel.showAnswer,
                   text: answers[index],
                   isCorrect: index == viewModel.currentQuestion?.correct)
                .onTapGesture {
                    guard viewModel.buttonType == .submitAnswer else { return }
                    selectedAnswer = index
                    removeSelection()
                    isSelected[index] = true
                }
        }
    }
    
    private func mainButton() -> some View {
        QuizButton(title: viewModel.buttonType.title) {
            removeSelection()
            viewModel.didTapOnMainButton(selectedAnswer: selectedAnswer)
        }
        .disabled(viewModel.buttonType == .submitAnswer && isButtonEnabled)
    }
    
    private func removeSelection() {
        for i in isSelected.indices {
            isSelected[i] = false
        }
    }
}

fileprivate struct Answer: View {
    @Binding var isSelected: Bool?
    @Binding var showAnswer: Bool?
    let text: String
    let isCorrect: Bool
    var body: some View {
        Text(text)
            .font(.subheadline)
            .padding(.vertical, Paddings.small)
            .padding(.horizontal, Paddings.medium)
            .background(isSelected == false && showAnswer == true ? isCorrect == true ? Color.green : Color.red : nil)
            .overlay(isSelected == true ? Rectangle().stroke(Color.gray, lineWidth:2) : nil)
    }
}
