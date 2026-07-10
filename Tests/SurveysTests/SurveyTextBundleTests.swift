import Foundation
@testable import Surveys
import Testing

@Suite("Survey text bundle")
struct SurveyTextBundleTests {
    @MainActor
    @Test("Stores the caller-provided text bundle")
    func callerBundle() {
        let survey = SurveyFlow(questions: [], textBundle: .main)
        #expect(survey.textBundle === Bundle.main)
    }

    @MainActor
    @Test("Defaults to the package bundle lookup path")
    func defaultBundle() {
        let survey = SurveyFlow(questions: [])
        #expect(survey.textBundle == nil)
    }
}
