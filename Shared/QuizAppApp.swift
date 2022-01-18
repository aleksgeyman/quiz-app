//
//  QuizAppApp.swift
//  Shared
//
//  Created by Aleksandar Geyman on 17.01.22.
//

import SwiftUI

@main
struct QuizAppApp: App {
    @State private var isQuestionsScreenActive: Bool = false
    
    var body: some Scene {
        WindowGroup {
            VStack() {
                appIcon()
                QuizButton(title: "Start") {
                    isQuestionsScreenActive = true
                }
            }
            .fullScreenCover(isPresented: $isQuestionsScreenActive) {
                isQuestionsScreenActive = false
            } content: {
                gameView()
            }
        }
    }
    
    private func appIcon() -> some View {
        Image("game-icon")
            .resizable()
            .frame(maxHeight: 250)
            .padding(.bottom, Paddings.large)
    }
    
    private func gameView() -> some View {
        NavigationView {
            QuestionsScreen(viewModel: QuestionsScreenViewModel(),
                            isQuestionsScreenActive: $isQuestionsScreenActive)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Quiz App")
                .navigationBarItems(leading: Button(action: {
                    isQuestionsScreenActive = false
                }, label: {
                    Image(systemName: "xmark")
                }))
                .navigationBarItems(trailing: TimerViewRepresentable(duration: Constants.gameDuration))
        }
    }
}
