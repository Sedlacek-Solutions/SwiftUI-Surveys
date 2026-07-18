import SwiftUI
import Testing
@testable import Surveys

@Suite("Discovery source question")
struct SurveyDiscoveryQuestionTests {
    @MainActor
    @Test("Built-in presets have stable IDs and recommended ordering")
    func presetOrdering() {
        #expect(SurveyDiscoverySource.allPresets.map(\.id) == [
            "app-store",
            "google",
            "instagram",
            "tiktok",
            "youtube",
            "facebook",
            "x",
            "reddit",
            "threads",
            "linkedin",
            "product-hunt",
            "referral",
            "podcast",
            "article-or-blog",
            "other"
        ])
    }

    @MainActor
    @Test("Every branded preset references a bundled icon resource")
    func brandedAssets() {
        let expectedAssets = [
            "BrandAppStore",
            "BrandGoogle",
            "BrandInstagram",
            "BrandTikTok",
            "BrandYouTube",
            "BrandFacebook",
            "BrandX",
            "BrandReddit",
            "BrandThreads",
            "BrandLinkedIn",
            "BrandProductHunt"
        ]

        let actualAssets: [String] = SurveyDiscoverySource.allPresets.compactMap { source in
            guard case .appIcon(let assetName) = source.icon else { return nil }
            return assetName
        }

        #expect(actualAssets == expectedAssets)
        let resourcesExist = SurveyDiscoverySource.allPresets.allSatisfy {
            $0.bundledBrandIconExists
        }
        #expect(resourcesExist)
    }

    @MainActor
    @Test("Discovery question converts to a regular callback question")
    func regularQuestionConversion() {
        let discoveryQuestion = SurveyDiscoveryQuestion(
            id: "discovery",
            titleKey: "How did you hear about us?",
            sources: [.instagram, .youtube, .other]
        )

        #expect(discoveryQuestion.question.id == "discovery")
        #expect(discoveryQuestion.question.answers.map(\.id) == [
            "instagram",
            "youtube"
        ])
        #expect(discoveryQuestion.question.isMultipleChoice == false)
        #expect(discoveryQuestion.question.includeOther == false)
    }

    @MainActor
    @Test("Selecting a source returns only that source")
    func singleSelection() {
        let discoveryQuestion = SurveyDiscoveryQuestion(
            id: "discovery",
            titleKey: "Source",
            sources: [.instagram, .youtube]
        )

        let first = discoveryQuestion.answers(selecting: .instagram)
        let second = discoveryQuestion.answers(selecting: .youtube)

        #expect(first.map(\.id) == ["instagram"])
        #expect(second.map(\.id) == ["youtube"])
    }

    @MainActor
    @Test("Other requires text and uses a stable answer ID")
    func otherText() {
        let discoveryQuestion = SurveyDiscoveryQuestion(
            id: "discovery",
            titleKey: "Source",
            sources: [.instagram, .other]
        )

        #expect(discoveryQuestion.answers(selecting: .other).isEmpty)

        let answers = discoveryQuestion.answers(
            selecting: .other,
            otherText: "Newsletter"
        )

        #expect(answers.first?.id == "discovery.other")
        #expect(answers.first?.titleKey == "Newsletter")
        #expect(answers.first?.titleString == "Newsletter")
    }

    @MainActor
    @Test("Custom source keeps its identity and icon content")
    func customSource() {
        let custom = SurveyDiscoverySource.custom(
            id: "newsletter",
            titleKey: "source.newsletter"
        ) {
            Image(systemName: "envelope.fill")
        }

        #expect(custom.id == "newsletter")
        #expect(custom.answer.id == "newsletter")
        #expect(custom.titleKey == "source.newsletter")
        #expect(custom.usesPackageLocalization == false)

        guard case .custom = custom.icon else {
            Issue.record("Expected custom icon content")
            return
        }
    }

    @MainActor
    @Test("Runtime step participates in normal question branching")
    func runtimeStepQuestion() {
        let discoveryQuestion = SurveyDiscoveryQuestion(
            id: "discovery",
            titleKey: "Source",
            sources: [.reddit, .other]
        )
        let step = SurveyFlowStep.discoveryQuestion(discoveryQuestion)
        let answers = [
            discoveryQuestion.question: Set([SurveyDiscoverySource.reddit.answer])
        ]

        #expect(step.question == discoveryQuestion.question)
        #expect(step.surveyStep == nil)
        #expect(
            answers[step.question!]?.contains(SurveyDiscoverySource.reddit.answer) == true
        )

        guard case .question = step.stepType else {
            Issue.record("Discovery step should be exposed as a question")
            return
        }
    }
}
