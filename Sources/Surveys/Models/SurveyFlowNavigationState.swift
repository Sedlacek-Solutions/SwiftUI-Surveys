//
//  SurveyFlowNavigationState.swift
//
//  Created by James Sedlacek on 7/19/26.
//

struct SurveyFlowNavigationState {
    private(set) var currentStepID: String
    private(set) var stepHistory: [String] = []
    private(set) var generation = 0
    private var consumedGeneration: Int?

    init(firstStepID: String) {
        self.currentStepID = firstStepID
    }

    var currentPathStepIDs: [String] {
        stepHistory + [currentStepID]
    }

    var hasPreviousStep: Bool {
        !stepHistory.isEmpty
    }

    func currentStepIndex(in steps: [SurveyFlowStep]) -> Int {
        steps.firstIndex { $0.id == currentStepID } ?? 0
    }

    mutating func consume(from stepID: String, generation: Int) -> Bool {
        guard isCurrent(stepID: stepID, generation: generation),
              consumedGeneration != generation else {
            return false
        }

        consumedGeneration = generation
        return true
    }

    func isCurrent(stepID: String, generation: Int) -> Bool {
        currentStepID == stepID && self.generation == generation
    }

    @discardableResult
    mutating func move(to stepID: String, validStepIDs: Set<String>) -> Bool {
        guard stepID != currentStepID, validStepIDs.contains(stepID) else { return false }
        stepHistory.append(currentStepID)
        currentStepID = stepID
        beginNewPresentation()
        return true
    }

    mutating func moveBack() -> String? {
        guard let previousStepID = stepHistory.popLast() else { return nil }
        currentStepID = previousStepID
        beginNewPresentation()
        return previousStepID
    }

    private mutating func beginNewPresentation() {
        generation += 1
        consumedGeneration = nil
    }
}
