//
//  SurveyFlowNavigation.swift
//
//  Created by James Sedlacek on 7/5/26.
//

/// A navigation decision returned after a survey step is submitted.
public enum SurveyFlowNavigation {
    /// Continue to the next step in the original step order.
    case next
    /// Jump to a specific step by its stable identifier.
    case step(id: String)
    /// Complete the flow immediately.
    case complete
}

/// Decides which step should be shown after the current step is submitted.
public typealias SurveyFlowNextStep = @MainActor (
    _ currentStep: SurveyFlowStep,
    _ answers: [SurveyQuestion: Set<SurveyAnswer>]
) -> SurveyFlowNavigation
