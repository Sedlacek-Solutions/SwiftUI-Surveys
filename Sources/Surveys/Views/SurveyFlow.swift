//
//  SurveyFlow.swift
//
//  Created by James Sedlacek on 2/1/25.
//

import SwiftUI

/// SurveyFlow is a SwiftUI view that manages a multi-step survey interface.
/// It handles the presentation of questions, collection of answers, and navigation between survey steps.
///
/// The view includes:
/// - A horizontal step indicator showing progress
/// - Display of the current survey question
/// - Navigation buttons for moving between questions
/// - Automatic answer validation and storage
///
/// Example usage:
/// ```swift
/// let questions = [SurveyQuestion(...), SurveyQuestion(...)]
/// SurveyFlow(questions: questions) { question, answers in
///     // Handle each answer
/// } onCompletion: {
///     // Handle survey completion
/// }
/// ```
@MainActor
public struct SurveyFlow {
    private let questions: [SurveyQuestion]
    private let onAnswer: (_ question: SurveyQuestion, _ answers: Set<String>) -> Void
    private let onCompletion: () -> Void
    @State private var currentStep: Int = 1
    @State private var answers: [SurveyQuestion: Set<String>] = [:]

    private var currentQuestion: SurveyQuestion? {
        questions[safe: currentStep - 1]
    }

    private var isNextDisabled: Bool {
        guard let currentQuestion else { return true }
        return answers[currentQuestion, default: .init()].isEmpty
    }

    private var isShowingBackButton: Bool {
        currentStep > 1
    }

    /// Creates a new survey flow with the specified questions and callback handlers.
    /// - Parameters:
    ///   - questions: An array of `SurveyQuestion` objects representing the survey questions to be presented.
    ///   - onAnswer: A closure that is called when the user answers a question. It provides both the question and the selected answers.
    ///   - onCompletion: A closure that is called when the user completes the entire survey.
    public init(
        questions: [SurveyQuestion],
        onAnswer: @escaping (SurveyQuestion, Set<String>) -> Void = { _, _ in },
        onCompletion: @escaping () -> Void = {}
    ) {
        self.questions = questions
        self.onAnswer = onAnswer
        self.onCompletion = onCompletion
    }

    private func nextAction() {
        guard let currentQuestion, let answer = answers[currentQuestion] else { return }
        onAnswer(currentQuestion, answer)

        guard currentStep < questions.count else {
            onCompletion()
            return
        }
        currentStep += 1
    }

    private func backAction() {
        guard currentStep > 1 else { return }
        currentStep -= 1
    }

    private func answersBinding(for question: SurveyQuestion) -> Binding<Set<String>> {
        .init(
            get: { answers[question, default: .init()] },
            set: { answers[question] = $0 }
        )
    }
}

extension SurveyFlow: View {
    public var body: some View {
        VStack(spacing: 16) {
            horizontalStepper
            surveyQuestionView
            actionButtons
        }
        .padding(24)
        .background(.background.secondary)
        .animation(.easeInOut, value: currentStep)
    }

    private var horizontalStepper: some View {
        HorizontalStepper(
            step: currentStep,
            total: questions.count
        )
    }

    @ViewBuilder
    private var surveyQuestionView: some View {
        if let currentQuestion {
            SurveyQuestionView(
                question: currentQuestion,
                answers: answersBinding(for: currentQuestion)
            )
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 16) {
            backButton
            nextButton
        }
    }

    private var nextButton: some View {
        Button(.next, action: nextAction)
            .buttonStyle(.filled)
            .disabled(isNextDisabled)
    }

    @ViewBuilder
    private var backButton: some View {
        if isShowingBackButton {
            Button(.back, action: backAction)
                .buttonStyle(.bezeledGray)
        }
    }
}

#Preview {
    SurveyFlow(questions: .mock())
}
