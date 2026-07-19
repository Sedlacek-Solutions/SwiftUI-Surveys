//
//  SurveyFlowContinuation.swift
//
//  Created by James Sedlacek on 7/19/26.
//

/// Navigation actions for a continuation-aware custom survey step.
///
/// Values are scoped to the step presentation that created them. After a
/// successful navigation, repeated or delayed calls are ignored.
@MainActor
public struct SurveyFlowContinuation {
    private let advanceAction: @MainActor () -> Void
    private let backAction: @MainActor () -> Void

    init(
        advance: @escaping @MainActor () -> Void,
        goBack: @escaping @MainActor () -> Void
    ) {
        self.advanceAction = advance
        self.backAction = goBack
    }

    /// Submits the current step and advances according to the flow's `nextStep` rule.
    public func advance() {
        advanceAction()
    }

    /// Returns to the previously visited step, or invokes the flow's `onBack`
    /// callback when the current step is the first step.
    public func goBack() {
        backAction()
    }
}
