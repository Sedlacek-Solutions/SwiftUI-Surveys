//
//  SurveyQuestionView.swift
//
//  Created by James Sedlacek on 11/12/24.
//

import SwiftUI

@MainActor
struct SurveyQuestionView {
    private let question: SurveyQuestion
    private let textBundle: Bundle?
    private let animationTrigger: String
    @Environment(\.surveyFlowAnimation) private var surveyFlowAnimation
    @Binding private var answers: Set<SurveyAnswer>
    @State private var otherText: String = ""

    init(
        question: SurveyQuestion,
        textBundle: Bundle?,
        answers: Binding<Set<SurveyAnswer>>,
        animationTrigger: String
    ) {
        self.question = question
        self.textBundle = textBundle
        self.animationTrigger = animationTrigger
        self._answers = answers
    }

    /// Creates a binding for tracking the selection state of an answer.
    /// - Parameter answer: The answer string to create a binding for.
    /// - Returns: A binding that manages the selection state of the answer.
    private func binding(for answer: SurveyAnswer) -> Binding<Bool> {
        .init(
            get: { answers.contains(answer) },
            set: { _ in
                if !question.isMultipleChoice && !answers.contains(answer) {
                    answers.removeAll()
                    otherText = ""
                }
                answers.toggle(answer)
            }
        )
    }

    private func otherTextChanged(oldText: String, newText: String) {
        answers.remove(SurveyAnswer(titleKey: oldText, titleString: oldText))
        guard !newText.isEmpty else { return }

        if !question.isMultipleChoice {
            answers.removeAll()
        }

        answers.insert(SurveyAnswer(titleKey: newText, titleString: newText))
    }

    /// Resets the 'other' text field based on the current answers.
    /// If there's an answer that's not in the predefined answers list,
    /// it will be set as the other text. Otherwise, other text will be cleared.
    private func resetOtherText() {
        guard let otherAnswer = answers.first(where: { answer in
            !question.answers.contains(answer)
        }) else {
            otherText = ""
            return
        }
        otherText = otherAnswer.titleString ?? ""
    }
}

extension SurveyQuestionView: View {
    var body: some View {
        VStack(spacing: 16) {
            titleView
            selectAllThatApplyView
            answerList
        }
        .onChange(of: question, resetOtherText)
    }

    private var titleView: some View {
        Text(question.title, bundle: textBundle ?? .module)
            .font(.largeTitle.weight(.semibold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
            .padding(.bottom, 24)
            .surveyEntrance(
                trigger: animationTrigger,
                delay: surveyFlowAnimation.titleDelay,
                animation: surveyFlowAnimation.titleAnimation,
                configuration: surveyFlowAnimation
            )
    }

    @ViewBuilder
    private var selectAllThatApplyView: some View {
        if question.isMultipleChoice {
            Text(.selectAllThatApply, bundle: .module)
                .font(.headline.weight(.medium))
                .frame(maxWidth: .infinity, alignment: .leading)
                .surveyEntrance(
                    trigger: animationTrigger,
                    delay: itemDelay(for: 0),
                    animation: surveyFlowAnimation.itemAnimation,
                    configuration: surveyFlowAnimation
                )
        }
    }

    private var answerList: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(Array(question.answers.enumerated()), id: \.element.id) { index, answer in
                    answerToggle(answer: answer)
                        .surveyEntrance(
                            trigger: animationTrigger,
                            delay: itemDelay(for: answerIndexOffset + index),
                            animation: surveyFlowAnimation.itemAnimation,
                            configuration: surveyFlowAnimation
                        )
                }

                otherTextField
            }
            .padding(.vertical)
        }
        .scrollIndicators(.hidden)
    }

    private var answerIndexOffset: Int {
        question.isMultipleChoice ? 1 : 0
    }

    private func itemDelay(for index: Int) -> TimeInterval {
        surveyFlowAnimation.itemBaseDelay + (Double(index) * surveyFlowAnimation.itemDelay)
    }

    private func answerToggle(answer: SurveyAnswer) -> some View {
        Toggle(isOn: binding(for: answer)) {
            if let systemImage = answer.systemImage {
                Label {
                    Text(answer.title, bundle: textBundle ?? .module)
                } icon: {
                    Image(systemName: systemImage)
                }
            } else {
                Text(answer.title, bundle: textBundle ?? .module)
            }
        }
        .toggleStyle(.labeledCheckmark)
    }

    @ViewBuilder
    private var otherTextField: some View {
        if question.includeOther {
            OtherTextField(text: $otherText)
                .onChange(of: otherText, otherTextChanged)
                .surveyEntrance(
                    trigger: animationTrigger,
                    delay: itemDelay(for: answerIndexOffset + question.answers.count),
                    animation: surveyFlowAnimation.itemAnimation,
                    configuration: surveyFlowAnimation
                )
        }
    }
}
