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
/// - A native progress indicator showing survey completion
/// - Display of the current survey step
/// - Navigation buttons for moving between steps
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
    private let steps: [SurveyFlowStep]
    private let onBack: () -> Void
    private let onFlowStepContinue: (_ step: SurveyFlowStep) -> Void
    private let nextStep: SurveyFlowNextStep
    private let onAnswer: (_ question: SurveyQuestion, _ answers: Set<SurveyAnswer>) -> Void
    private let onCompletion: (_ allAnswers: [SurveyQuestion: Set<SurveyAnswer>]) -> Void
    let textBundle: Bundle?
    @Environment(\.surveyAccentColor) private var surveyAccentColor
    @Environment(\.surveyFlowAnimation) private var surveyFlowAnimation
    @State private var currentStepID: String
    @State private var stepHistory: [String] = []
    @State private var answers: [SurveyQuestion: Set<SurveyAnswer>] = [:]

    private var currentSurveyStep: SurveyFlowStep? {
        steps.first { $0.id == currentStepID }
    }

    private var currentStepIndex: Int {
        guard let index = steps.firstIndex(where: { $0.id == currentStepID }) else { return 0 }
        return index
    }

    private var currentPathStepIDs: [String] {
        stepHistory + [currentStepID]
    }

    private var currentPathAnswers: [SurveyQuestion: Set<SurveyAnswer>] {
        let questionIDs = Set(
            steps
                .filter { currentPathStepIDs.contains($0.id) }
                .compactMap { $0.question?.id }
        )

        return answers.filter { question, _ in
            questionIDs.contains(question.id)
        }
    }

    private var isNextDisabled: Bool {
        switch currentSurveyStep?.storage {
        case .question(let question):
            answers[question, default: .init()].isEmpty
        case .content, .custom:
            false
        case nil:
            true
        }
    }

    private var continueButtonTitle: LocalizedStringKey {
        .continueButton
    }

    /// Creates a new survey flow with the specified questions and callback handlers.
    /// - Parameters:
    ///   - questions: An array of `SurveyQuestion` objects representing the survey questions to be presented.
    ///   - onAnswer: A closure that is called when the user answers a question. It provides both the question and the selected answers.
    ///   - onStepContinue: A closure that is called when the user continues from any step.
    ///   - nextStep: A closure that decides which step should be shown after the current step is submitted.
    ///   - onCompletion: A closure that is called when the user completes the entire survey. It provides a dictionary of all questions and their corresponding answers.
    public init(
        questions: [SurveyQuestion],
        textBundle: Bundle? = nil,
        onAnswer: @escaping (SurveyQuestion, Set<SurveyAnswer>) -> Void = { _, _ in },
        onStepContinue: @escaping (SurveyStep) -> Void = { _ in },
        nextStep: @escaping SurveyFlowNextStep = { _, _ in .next },
        onCompletion: @escaping ([SurveyQuestion: Set<SurveyAnswer>]) -> Void = { _ in }
    ) {
        self.init(
            internalFlowSteps: questions.map { SurveyFlowStep.question($0) },
            textBundle: textBundle,
            onBack: {},
            onFlowStepContinue: { step in
                if let surveyStep = step.surveyStep {
                    onStepContinue(surveyStep)
                }
            },
            nextStep: nextStep,
            onAnswer: onAnswer,
            onCompletion: onCompletion
        )
    }

    /// Creates a new survey flow with the specified questions and callback handlers.
    /// - Parameters:
    ///   - questions: An array of `SurveyQuestion` objects representing the survey questions to be presented.
    ///   - onBack: A closure that is called when the user taps Back on the first step.
    ///   - onAnswer: A closure that is called when the user answers a question. It provides both the question and the selected answers.
    ///   - onStepContinue: A closure that is called when the user continues from any step.
    ///   - nextStep: A closure that decides which step should be shown after the current step is submitted.
    ///   - onCompletion: A closure that is called when the user completes the entire survey. It provides a dictionary of all questions and their corresponding answers.
    public init(
        questions: [SurveyQuestion],
        textBundle: Bundle? = nil,
        onBack: @escaping () -> Void,
        onAnswer: @escaping (SurveyQuestion, Set<SurveyAnswer>) -> Void = { _, _ in },
        onStepContinue: @escaping (SurveyStep) -> Void = { _ in },
        nextStep: @escaping SurveyFlowNextStep = { _, _ in .next },
        onCompletion: @escaping ([SurveyQuestion: Set<SurveyAnswer>]) -> Void = { _ in }
    ) {
        self.init(
            internalFlowSteps: questions.map { SurveyFlowStep.question($0) },
            textBundle: textBundle,
            onBack: onBack,
            onFlowStepContinue: { step in
                if let surveyStep = step.surveyStep {
                    onStepContinue(surveyStep)
                }
            },
            nextStep: nextStep,
            onAnswer: onAnswer,
            onCompletion: onCompletion
        )
    }

    /// Creates a new survey flow with the specified steps and callback handlers.
    /// - Parameters:
    ///   - steps: An array of `SurveyStep` objects representing each screen in the flow.
    ///   - onStepContinue: A closure that is called when the user continues from any step.
    ///   - onAnswer: A closure that is called when the user answers a question. It provides both the question and the selected answers.
    ///   - nextStep: A closure that decides which step should be shown after the current step is submitted.
    ///   - onCompletion: A closure that is called when the user completes the entire survey. It provides a dictionary of all questions and their corresponding answers.
    public init(
        steps: [SurveyStep],
        textBundle: Bundle? = nil,
        onStepContinue: @escaping (SurveyStep) -> Void = { _ in },
        onAnswer: @escaping (SurveyQuestion, Set<SurveyAnswer>) -> Void = { _, _ in },
        nextStep: @escaping SurveyFlowNextStep = { _, _ in .next },
        onCompletion: @escaping ([SurveyQuestion: Set<SurveyAnswer>]) -> Void = { _ in }
    ) {
        self.init(
            internalFlowSteps: steps.map(SurveyFlowStep.init),
            textBundle: textBundle,
            onBack: {},
            onFlowStepContinue: { step in
                if let surveyStep = step.surveyStep {
                    onStepContinue(surveyStep)
                }
            },
            nextStep: nextStep,
            onAnswer: onAnswer,
            onCompletion: onCompletion
        )
    }

    /// Creates a new survey flow with the specified steps and callback handlers.
    /// - Parameters:
    ///   - steps: An array of `SurveyStep` objects representing each screen in the flow.
    ///   - onBack: A closure that is called when the user taps Back on the first step.
    ///   - onStepContinue: A closure that is called when the user continues from any step.
    ///   - onAnswer: A closure that is called when the user answers a question. It provides both the question and the selected answers.
    ///   - nextStep: A closure that decides which step should be shown after the current step is submitted.
    ///   - onCompletion: A closure that is called when the user completes the entire survey. It provides a dictionary of all questions and their corresponding answers.
    public init(
        steps: [SurveyStep],
        textBundle: Bundle? = nil,
        onBack: @escaping () -> Void,
        onStepContinue: @escaping (SurveyStep) -> Void = { _ in },
        onAnswer: @escaping (SurveyQuestion, Set<SurveyAnswer>) -> Void = { _, _ in },
        nextStep: @escaping SurveyFlowNextStep = { _, _ in .next },
        onCompletion: @escaping ([SurveyQuestion: Set<SurveyAnswer>]) -> Void = { _ in }
    ) {
        self.init(
            internalFlowSteps: steps.map(SurveyFlowStep.init),
            textBundle: textBundle,
            onBack: onBack,
            onFlowStepContinue: { step in
                if let surveyStep = step.surveyStep {
                    onStepContinue(surveyStep)
                }
            },
            nextStep: nextStep,
            onAnswer: onAnswer,
            onCompletion: onCompletion
        )
    }

    /// Creates a new survey flow with runtime steps that can include arbitrary SwiftUI content.
    /// - Parameters:
    ///   - flowSteps: An array of `SurveyFlowStep` objects representing each screen in the flow.
    ///   - onFlowStepContinue: A closure that is called when the user continues from any flow step.
    ///   - onAnswer: A closure that is called when the user answers a question. It provides both the question and the selected answers.
    ///   - nextStep: A closure that decides which step should be shown after the current step is submitted.
    ///   - onCompletion: A closure that is called when the user completes the entire survey. It provides a dictionary of all questions and their corresponding answers.
    public init(
        flowSteps: [SurveyFlowStep],
        textBundle: Bundle? = nil,
        onFlowStepContinue: @escaping (SurveyFlowStep) -> Void = { _ in },
        onAnswer: @escaping (SurveyQuestion, Set<SurveyAnswer>) -> Void = { _, _ in },
        nextStep: @escaping SurveyFlowNextStep = { _, _ in .next },
        onCompletion: @escaping ([SurveyQuestion: Set<SurveyAnswer>]) -> Void = { _ in }
    ) {
        self.init(
            internalFlowSteps: flowSteps,
            textBundle: textBundle,
            onBack: {},
            onFlowStepContinue: onFlowStepContinue,
            nextStep: nextStep,
            onAnswer: onAnswer,
            onCompletion: onCompletion
        )
    }

    /// Creates a new survey flow with runtime steps that can include arbitrary SwiftUI content.
    /// - Parameters:
    ///   - flowSteps: An array of `SurveyFlowStep` objects representing each screen in the flow.
    ///   - onBack: A closure that is called when the user taps Back on the first step.
    ///   - onFlowStepContinue: A closure that is called when the user continues from any flow step.
    ///   - onAnswer: A closure that is called when the user answers a question. It provides both the question and the selected answers.
    ///   - nextStep: A closure that decides which step should be shown after the current step is submitted.
    ///   - onCompletion: A closure that is called when the user completes the entire survey. It provides a dictionary of all questions and their corresponding answers.
    public init(
        flowSteps: [SurveyFlowStep],
        textBundle: Bundle? = nil,
        onBack: @escaping () -> Void,
        onFlowStepContinue: @escaping (SurveyFlowStep) -> Void = { _ in },
        onAnswer: @escaping (SurveyQuestion, Set<SurveyAnswer>) -> Void = { _, _ in },
        nextStep: @escaping SurveyFlowNextStep = { _, _ in .next },
        onCompletion: @escaping ([SurveyQuestion: Set<SurveyAnswer>]) -> Void = { _ in }
    ) {
        self.init(
            internalFlowSteps: flowSteps,
            textBundle: textBundle,
            onBack: onBack,
            onFlowStepContinue: onFlowStepContinue,
            nextStep: nextStep,
            onAnswer: onAnswer,
            onCompletion: onCompletion
        )
    }

    private init(
        internalFlowSteps: [SurveyFlowStep],
        textBundle: Bundle?,
        onBack: @escaping () -> Void,
        onFlowStepContinue: @escaping (SurveyFlowStep) -> Void,
        nextStep: @escaping SurveyFlowNextStep,
        onAnswer: @escaping (SurveyQuestion, Set<SurveyAnswer>) -> Void,
        onCompletion: @escaping ([SurveyQuestion: Set<SurveyAnswer>]) -> Void
    ) {
        self.steps = internalFlowSteps
        self.textBundle = textBundle
        self.onBack = onBack
        self.onFlowStepContinue = onFlowStepContinue
        self.nextStep = nextStep
        self.onAnswer = onAnswer
        self.onCompletion = onCompletion
        self._currentStepID = State(initialValue: internalFlowSteps.first?.id ?? "")
    }

    private func nextAction() {
        guard let currentSurveyStep else { return }

        switch currentSurveyStep.storage {
        case .question(let question):
            guard let answer = answers[question] else { return }
            onAnswer(question, answer)
        case .content, .custom:
            break
        }

        onFlowStepContinue(currentSurveyStep)
        navigate(from: currentSurveyStep)
    }

    private func navigate(from currentSurveyStep: SurveyFlowStep) {
        switch nextStep(currentSurveyStep, currentPathAnswers) {
        case .next:
            navigateToNextStep()
        case .step(let id):
            guard navigateToStep(id: id) else {
                navigateToNextStep()
                return
            }
        case .complete:
            onCompletion(currentPathAnswers)
        }
    }

    private func navigateToNextStep() {
        let nextIndex = currentStepIndex + 1
        guard steps.indices.contains(nextIndex) else {
            onCompletion(currentPathAnswers)
            return
        }
        _ = navigateToStep(id: steps[nextIndex].id)
    }

    @discardableResult
    private func navigateToStep(id: String) -> Bool {
        guard id != currentStepID, steps.contains(where: { $0.id == id }) else { return false }
        stepHistory.append(currentStepID)
        currentStepID = id
        return true
    }

    private func backAction() {
        guard let previousStepID = stepHistory.popLast() else {
            onBack()
            return
        }
        currentStepID = previousStepID
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
            toolbar
            surveyStepView
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .background(.background.secondary)
        .safeAreaInset(
            edge: .bottom,
            content: actionButtons
        )
    }

    private var toolbar: some View {
        HStack(spacing: 12) {
            backButton
            progressView
        }
    }

    private var progressView: some View {
        ProgressView(
            value: Double(currentStepIndex + 1),
            total: Double(steps.count)
        )
        .progressViewStyle(.linear)
        .tint(surveyAccentColor)
        .animation(
            surveyFlowAnimation.isEnabled ? surveyFlowAnimation.progressAnimation : nil,
            value: currentStepIndex
        )
    }

    @ViewBuilder
    private var surveyStepView: some View {
        switch currentSurveyStep?.storage {
        case .question(let currentQuestion):
            SurveyQuestionView(
                question: currentQuestion,
                textBundle: textBundle,
                answers: answersBinding(for: currentQuestion),
                animationTrigger: currentStepID
            )
        case .content(let contentStep):
            SurveyContentStepView(
                step: contentStep,
                textBundle: textBundle,
                animationTrigger: currentStepID
            )
        case .custom(let isScrollable, let content):
            customContentView(
                isScrollable: isScrollable,
                content: content
            )
            .surveyEntrance(
                trigger: currentStepID,
                delay: surveyFlowAnimation.titleDelay,
                animation: surveyFlowAnimation.titleAnimation,
                configuration: surveyFlowAnimation
            )
        case nil:
            EmptyView()
        }
    }

    @ViewBuilder
    private func customContentView(
        isScrollable: Bool,
        content: @escaping @MainActor () -> AnyView
    ) -> some View {
        if isScrollable {
            ScrollView {
                content()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
            }
            .scrollIndicators(.hidden)
        } else {
            content()
        }
    }

    private func actionButtons() -> some View {
        nextButton
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .background(.regularMaterial)
    }

    private var nextButton: some View {
        Button(action: nextAction) {
            Text(continueButtonTitle, bundle: .module)
        }
        .buttonStyle(.primary)
        .disabled(isNextDisabled)
    }

    private var backButton: some View {
        Button(action: backAction) {
            Image(systemName: "arrow.left")
                .font(.headline.weight(.semibold))
                .frame(width: 36, height: 36)
                .backButtonBackground()
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(.back, bundle: .module))
    }
}

private extension View {
    @ViewBuilder
    func backButtonBackground() -> some View {
        if #available(iOS 26, macOS 26, *) {
            self.glassEffect(.regular.interactive(), in: .circle)
        } else {
            self.background(.ultraThinMaterial, in: Circle())
        }
    }
}

#Preview("English") {
    SurveyFlow(
        questions: .mock(),
        onAnswer: { question, answers in
            print(question.title)
            print("Answer(s):")
            for answer in answers {
                print(answer.title)
            }
        },
        onCompletion: { SurveyQA in
            print("Survey completed")
            for (question, answers) in SurveyQA {
                print(question.title)
                print("Answer(s):")
                for answer in answers {
                    print(answer.title)
                }
            }
        }
    )
}

#Preview("Mixed Content Steps") {
    SurveyFlow(
        flowSteps: [
            .custom {
                VStack(spacing: 28) {
                    Text("Designed to help you stay on track")
                        .font(.largeTitle.weight(.semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: 18) {
                        Text("Weight trend")
                            .font(.title2.weight(.semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        PreviewTrendChart()

                        Text("Track your habits and stay consistent over time.")
                            .font(.title3.weight(.medium))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(24)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                }
            },
            .custom {
                VStack(spacing: 24) {
                    Text("Everything works together")
                        .font(.largeTitle.weight(.semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: 12) {
                        PreviewFeatureRow(
                            title: "Personalized setup",
                            subtitle: "Ask only for the inputs you need.",
                            systemImage: "slider.horizontal.3"
                        )
                        PreviewFeatureRow(
                            title: "Helpful context",
                            subtitle: "Add education between questions.",
                            systemImage: "lightbulb"
                        )
                        PreviewFeatureRow(
                            title: "Clear progress",
                            subtitle: "Custom content screens count in the flow.",
                            systemImage: "gauge.with.dots.needle.67percent"
                        )
                    }
                }
            },
            .question(
                .init(
                    titleKey: "What best describes your goal?",
                    answers: [
                        .init(titleKey: "Build consistency", systemImage: "calendar"),
                        .init(titleKey: "Understand trends", systemImage: "chart.xyaxis.line"),
                        .init(titleKey: "Stay accountable", systemImage: "checkmark.circle")
                    ]
                )
            ),
            .custom {
                VStack(spacing: 24) {
                    Text("Small actions add up")
                        .font(.largeTitle.weight(.semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Show key outcomes before asking for another answer.")
                        .font(.title3.weight(.medium))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ],
                        spacing: 12
                    ) {
                        PreviewStatCard(value: "3x", label: "More likely to finish", systemImage: "arrow.up.forward")
                        PreviewStatCard(value: "12 weeks", label: "Typical habit window", systemImage: "calendar")
                        PreviewStatCard(value: "86%", label: "Prefer guided setup", systemImage: "person.2")
                        PreviewStatCard(value: "2 min", label: "Average setup time", systemImage: "timer")
                    }
                }
            },
            .question(
                .init(
                    titleKey: "How often do you want to check in?",
                    answers: [
                        .init(titleKey: "Daily", systemImage: "sun.max"),
                        .init(titleKey: "Weekly", systemImage: "calendar"),
                        .init(titleKey: "Occasionally", systemImage: "clock")
                    ]
                )
            ),
            .custom {
                VStack(spacing: 24) {
                    Text("You are ready to begin")
                        .font(.largeTitle.weight(.semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    PreviewChecklistItem(title: "Goal selected")
                    PreviewChecklistItem(title: "Check-in rhythm chosen")
                    PreviewChecklistItem(title: "Personalized flow prepared")
                }
            }
        ]
    )
}

#Preview("Branching Steps") {
    let quickAnswer = SurveyAnswer(id: "quick", titleKey: "Keep it short", systemImage: "forward")
    let detailedAnswer = SurveyAnswer(id: "detailed", titleKey: "Show me more", systemImage: "list.bullet")
    let setupQuestion = SurveyQuestion(
        id: "setup-depth",
        titleKey: "How much setup guidance do you want?",
        answers: [quickAnswer, detailedAnswer]
    )
    let steps: [SurveyFlowStep] = [
        .question(setupQuestion),
        .custom(id: "details") {
            VStack(spacing: 24) {
                Text("Here is the extra context")
                    .font(.largeTitle.weight(.semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)

                PreviewFeatureRow(
                    title: "Branching flow",
                    subtitle: "This screen only appears for people who asked for more guidance.",
                    systemImage: "arrow.triangle.branch"
                )
            }
        },
        .custom(id: "summary") {
            VStack(spacing: 24) {
                Text("Ready to continue")
                    .font(.largeTitle.weight(.semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)

                PreviewChecklistItem(title: "The next step was chosen from your answer")
            }
        }
    ]

    SurveyFlow(
        flowSteps: steps,
        nextStep: { step, answers in
            guard step.question?.id == setupQuestion.id else { return .next }
            return answers[setupQuestion, default: .init()].contains(quickAnswer)
                ? .step(id: "summary")
                : .next
        }
    )
}

#Preview("Spanish") {
    SurveyFlow(questions: .mock())
        .environment(\.locale, .init(identifier: "es"))
}

#Preview("Custom Accent") {
    SurveyFlow(questions: .mock())
        .surveyAccentColor(.purple)
}

#Preview("Animation Disabled") {
    SurveyFlow(questions: .mock())
        .surveyFlowAnimation(.disabled)
}

private struct PreviewTrendChart: View {
    @Environment(\.surveyAccentColor) private var surveyAccentColor

    var body: some View {
        Canvas { context, size in
            let path = Path { path in
                path.move(to: CGPoint(x: 0, y: size.height * 0.72))
                path.addCurve(
                    to: CGPoint(x: size.width, y: size.height * 0.22),
                    control1: CGPoint(x: size.width * 0.32, y: size.height * 0.76),
                    control2: CGPoint(x: size.width * 0.56, y: size.height * 0.1)
                )
            }
            context.stroke(path, with: .color(surveyAccentColor), lineWidth: 4)

            let baseline = Path { path in
                path.move(to: CGPoint(x: 0, y: size.height * 0.38))
                path.addLine(to: CGPoint(x: size.width, y: size.height * 0.38))
            }
            context.stroke(baseline, with: .color(.secondary.opacity(0.35)), style: StrokeStyle(lineWidth: 1, dash: [4]))
        }
        .frame(height: 160)
    }
}

private struct PreviewFeatureRow: View {
    let title: String
    let subtitle: String
    let systemImage: String
    @Environment(\.surveyAccentColor) private var surveyAccentColor

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: systemImage)
                .font(.title3.weight(.semibold))
                .foregroundStyle(surveyAccentColor)
                .frame(width: 32, height: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline.weight(.semibold))
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct PreviewStatCard: View {
    let value: String
    let label: String
    let systemImage: String
    @Environment(\.surveyAccentColor) private var surveyAccentColor

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: systemImage)
                .font(.title3.weight(.semibold))
                .foregroundStyle(surveyAccentColor)

            Text(value)
                .font(.title2.weight(.bold))

            Text(label)
                .font(.footnote.weight(.medium))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 128, alignment: .topLeading)
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct PreviewChecklistItem: View {
    let title: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.green)
            Text(title)
                .font(.headline.weight(.semibold))
            Spacer()
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}
