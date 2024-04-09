//
//  ContentView.swift
//  SwiftQuizApp
//
//  Created by y0shi on 3/22/24.
//

import SwiftUI

struct Question {
    let text: String
    let choices: [String]
    let correctAnswerIndex: Int
}

class QuizViewModel: ObservableObject {
    // things that get updated, hence variables.
    @Published var currentQuestionIndex = 0
    @Published var score = 0
    @Published var showingScore = false
    
    // The questions for the quiz, duh. You can add as many questions and as many answers as you want.
    // Just make sure everything fits on the actual screen.
    let questions: [Question] = [
        Question(text: "Question_1", choices: ["Answer", "Incorrect", "Incorrect", "Incorrect"], correctAnswerIndex: 0),
        Question(text: "Question_2", choices: ["Incorrect", "Answer", "Incorrect", "Incorrect"], correctAnswerIndex: 1),
        Question(text: "2 + 2 equals?", choices: ["3", "4", "5", "6"], correctAnswerIndex: 1)
        // Add more questions here, just copy and paste.
    ]
    // Function that handles answer selection
    func answerSelected(_ index: Int) {
        if index == questions[currentQuestionIndex].correctAnswerIndex {
            score += 1
        }
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            showingScore = true
        }
    }
    
    // Function to restart the quiz
    func restartQuiz() {
        score = 0
        currentQuestionIndex = 0
        showingScore = false
    }
}

// Main Quiz UI Screen
struct QuizView: View {
    @StateObject private var viewModel = QuizViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.questions[viewModel.currentQuestionIndex].text)
                .font(.title)
            
            ForEach(0..<viewModel.questions[viewModel.currentQuestionIndex].choices.count, id: \.self) { choiceIndex in
                Button(action: {
                    viewModel.answerSelected(choiceIndex)
                }) {
                    Text(viewModel.questions[viewModel.currentQuestionIndex].choices[choiceIndex])
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .alert(isPresented: $viewModel.showingScore) {
            Alert(title: Text("Quiz Finished!"), message: Text("Your score is \(viewModel.score) out of \(viewModel.questions.count)"), dismissButton: .default(Text("Restart")) {
                viewModel.restartQuiz()
            })
        }
    }
}
// other stuff
@main
struct QuizApp: App {
    var body: some Scene {
        WindowGroup {
            QuizView()
        }
    }
}

#Preview {
    QuizView()
}
