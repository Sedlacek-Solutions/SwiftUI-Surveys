//
//  SurveyQuestionView.swift
//
//  Created by James Sedlacek on 11/12/24.
//

import SwiftUI

@MainActor
struct SurveyQuestionView {
    private let question: SurveyQuestion
    @Binding private var answers: Set<SurveyAnswer>
    @State private var otherText: String = ""

    init(
        question: SurveyQuestion,
        answers: Binding<Set<SurveyAnswer>>
    ) {
        self.question = question
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
        answers.remove(SurveyAnswer(title: LocalizedStringKey(oldText), titleString: oldText))
        guard !newText.isEmpty else { return }

        if !question.isMultipleChoice {
            answers.removeAll()
        }

        answers.insert(SurveyAnswer(title: LocalizedStringKey(newText), titleString: newText))
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
        Text(question.title)
            .font(.largeTitle.weight(.semibold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 24)
    }

    @ViewBuilder
    private var selectAllThatApplyView: some View {
        if question.isMultipleChoice {
            Text(.selectAllThatApply)
                .font(.headline.weight(.medium))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var answerList: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(question.answers, content: answerToggle)

                otherTextField
            }
            .padding(.vertical)
        }
        .scrollIndicators(.hidden)
    }

    private func answerToggle(answer: SurveyAnswer) -> some View {
        Toggle(isOn: binding(for: answer)) {
            if let systemImage = answer.systemImage {
                Label(answer.title, systemImage: systemImage)
            } else {
                Text(answer.title)
            }
        }
        .toggleStyle(.labeledCheckmark)
    }

    @ViewBuilder
    private var otherTextField: some View {
        if question.includeOther {
            OtherTextField(text: $otherText)
                .onChange(of: otherText, otherTextChanged)
        }
    }
}
