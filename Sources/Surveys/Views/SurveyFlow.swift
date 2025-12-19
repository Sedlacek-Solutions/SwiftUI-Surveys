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
/// } onCompletion: { allAnswers in
///     // Handle survey completion with all answers
/// }
/// ```
@MainActor
public struct SurveyFlow {
    private let questions: [SurveyQuestion]
    private let onAnswer: (_ question: SurveyQuestion, _ answers: Set<SurveyAnswer>) -> Void
    private let onCompletion: (_ allAnswers: [SurveyQuestion: Set<SurveyAnswer>]) -> Void
    @State private var currentStep: Int = 1
    @State private var answers: [SurveyQuestion: Set<SurveyAnswer>] = [:]

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
    ///   - onCompletion: A closure that is called when the user completes the entire survey. It provides a dictionary of all questions and their corresponding answers.
    public init(
        questions: [SurveyQuestion],
        onAnswer: @escaping (SurveyQuestion, Set<SurveyAnswer>) -> Void = { _, _ in },
        onCompletion: @escaping ([SurveyQuestion: Set<SurveyAnswer>]) -> Void = { _ in }
    ) {
        self.questions = questions
        self.onAnswer = onAnswer
        self.onCompletion = onCompletion
    }

    private func nextAction() {
        guard let currentQuestion, let answer = answers[currentQuestion] else { return }
        onAnswer(currentQuestion, answer)

        guard currentStep < questions.count else {
            onCompletion(answers)
            return
        }
        currentStep += 1
    }

    private func backAction() {
        guard currentStep > 1 else { return }
        currentStep -= 1
    }

    private func answersBinding(for question: SurveyQuestion) -> Binding<Set<SurveyAnswer>> {
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
        }
        .padding(24)
        .background(.background.secondary)
        .safeAreaInset(
            edge: .bottom,
            content: actionButtons
        )
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

    private func actionButtons() -> some View {
        HStack(spacing: 16) {
            backButton
            nextButton
        }
        .padding(20)
        .background(.background.tertiary)
    }

    private var nextButton: some View {
        Button(action: nextAction) {
            Text(.next, bundle: .module)
        }
        .buttonStyle(.primary)
        .disabled(isNextDisabled)
    }

    @ViewBuilder
    private var backButton: some View {
        if isShowingBackButton {
            Button(action: backAction) {
                Text(.back, bundle: .module)
            }
            .buttonStyle(.secondary)
        }
    }
}

#Preview("English") {
    SurveyFlow(questions: .mock())
}

#Preview("Spanish") {
    SurveyFlow(questions: .mock())
        .environment(\.locale, .init(identifier: "es"))
}
