import SwiftUI
import Testing
@testable import Surveys

@Suite("Custom survey flow steps")
struct SurveyFlowCustomStepTests {
    @MainActor
    @Test("Existing custom steps keep the package footer")
    func defaultCustomStepBehavior() {
        let step = SurveyFlowStep.custom(id: "legacy") {
            Text("Legacy content")
        }

        guard case .custom(let isScrollable, .automatic, let content) = step.storage else {
            Issue.record("Expected an automatic-footer custom step")
            return
        }

        #expect(isScrollable)
        _ = content(noOpContinuation)
    }

    @MainActor
    @Test("Continuation-aware steps can hide or replace the package footer")
    func customFooterBehavior() {
        let hidden = SurveyFlowStep.custom(id: "hidden", footer: .hidden) { _ in
            Text("Authentication")
        }
        let custom = SurveyFlowStep.custom(id: "custom") { _ in
            Text("Authentication")
        } footer: { _ in
            Button("Sign in") {}
        }

        guard case .custom(_, .hidden, _) = hidden.storage else {
            Issue.record("Expected a hidden-footer custom step")
            return
        }
        guard case .custom(_, .custom(let footer), _) = custom.storage else {
            Issue.record("Expected an app-owned custom footer")
            return
        }

        _ = footer(noOpContinuation)
    }

    @MainActor
    @Test("Forward and back navigation preserve visited history and progress")
    func navigationHistoryAndProgress() {
        let steps = testSteps
        let validIDs = Set(steps.map(\.id))
        var state = SurveyFlowNavigationState(firstStepID: steps[0].id)

        #expect(state.currentStepIndex(in: steps) == 0)
        #expect(state.currentPathStepIDs == ["intent"])
        let consumedIntent = state.consume(from: "intent", generation: 0)
        let movedToPrivacy = state.move(to: "privacy", validStepIDs: validIDs)
        #expect(consumedIntent)
        #expect(movedToPrivacy)
        #expect(state.currentStepIndex(in: steps) == 2)
        #expect(state.currentPathStepIDs == ["intent", "privacy"])

        let privacyGeneration = state.generation
        let consumedPrivacy = state.consume(from: "privacy", generation: privacyGeneration)
        let previousStepID = state.moveBack()
        #expect(consumedPrivacy)
        #expect(previousStepID == "intent")
        #expect(state.currentStepIndex(in: steps) == 0)
        #expect(state.currentPathStepIDs == ["intent"])
    }

    @MainActor
    @Test("A presentation can navigate only once")
    func navigationIsSingleUse() {
        let steps = testSteps
        let validIDs = Set(steps.map(\.id))
        var state = SurveyFlowNavigationState(firstStepID: "intent")

        let firstConsume = state.consume(from: "intent", generation: 0)
        let repeatedConsume = state.consume(from: "intent", generation: 0)
        let movedToAudience = state.move(to: "audience", validStepIDs: validIDs)
        let staleConsume = state.consume(from: "intent", generation: 0)
        #expect(firstConsume)
        #expect(!repeatedConsume)
        #expect(movedToAudience)
        #expect(!staleConsume)

        let audienceGeneration = state.generation
        let audienceConsume = state.consume(
            from: "audience",
            generation: audienceGeneration
        )
        let repeatedAudienceConsume = state.consume(
            from: "audience",
            generation: audienceGeneration
        )
        #expect(audienceConsume)
        #expect(!repeatedAudienceConsume)
    }

    @MainActor
    @Test("The final step can complete once with the full visited path")
    func completionPath() {
        let steps = testSteps
        let validIDs = Set(steps.map(\.id))
        var state = SurveyFlowNavigationState(firstStepID: "intent")

        let consumedIntent = state.consume(from: "intent", generation: 0)
        let movedToAudience = state.move(to: "audience", validStepIDs: validIDs)
        let audienceGeneration = state.generation
        let consumedAudience = state.consume(
            from: "audience",
            generation: audienceGeneration
        )
        let movedToPrivacy = state.move(to: "privacy", validStepIDs: validIDs)
        #expect(consumedIntent)
        #expect(movedToAudience)
        #expect(consumedAudience)
        #expect(movedToPrivacy)

        let completionGeneration = state.generation
        let completed = state.consume(from: "privacy", generation: completionGeneration)
        #expect(state.currentStepIndex(in: steps) == steps.count - 1)
        #expect(state.currentPathStepIDs == ["intent", "audience", "privacy"])
        let repeatedCompletion = state.consume(
            from: "privacy",
            generation: completionGeneration
        )
        #expect(completed)
        #expect(!repeatedCompletion)
    }

    @MainActor
    private var noOpContinuation: SurveyFlowContinuation {
        SurveyFlowContinuation(advance: {}, goBack: {})
    }

    @MainActor
    private var testSteps: [SurveyFlowStep] {
        [
            .custom(id: "intent") { EmptyView() },
            .custom(id: "audience") { EmptyView() },
            .custom(id: "privacy") { EmptyView() }
        ]
    }
}
