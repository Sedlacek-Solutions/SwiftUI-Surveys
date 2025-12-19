# SwiftUI-Surveys

A Swift package that provides an elegant and customizable survey interface for iOS applications using SwiftUI. <br>
SwiftUI-Surveys makes it easy to create professional-looking surveys with a modern design and smooth user experience.

<img width="6888" height="2976" alt="InsightsSurvey" src="https://github.com/user-attachments/assets/d8cf3f50-c747-4969-92a3-e7d33e30c08b" />

## Features

- 📊 Horizontal step indicator for survey progress
- ✅ Support for single and multiple choice questions
- 🔄 Seamless navigation between questions with back/next functionality
- ✨ Automatic answer validation
- 🎯 Completion handling
- 🎨 Clean and modern UI with smooth animations
- 📱 Fully SwiftUI native

## Requirements

- iOS 17.0+
- Swift 6+
- Xcode 16.0+

## Installation

### Swift Package Manager

Add SwiftUI-Surveys to your project through Xcode:

1. File > Add Packages
2. Enter package URL: ```https://github.com/Sedlacek-Solutions/SwiftUI-Surveys.git```
3. Select version requirements
4. Click Add Package

## Usage

### Creating Survey Questions

```swift
let questions = [
    SurveyQuestion(
        title: "How would you describe your experience?",
        answers: [
            .init(title: "Beginner"),
            .init(title: "Intermediate"),
            .init(title: "Advanced")
        ],
        isMultipleChoice: false
    ),
    SurveyQuestion(
        title: "What features interest you?",
        answers: [
            .init(title: "Analytics"),
            .init(title: "Reporting"),
            .init(title: "Sharing"),
            .init(title: "Export")
        ],
        isMultipleChoice: true
    )
]
```

### Using Identifiers

Questions and answers support optional identifiers for external tracking systems:

```swift
let questions = [
    SurveyQuestion(
        identifier: "user-experience-q1",
        title: "How would you describe your experience?",
        answers: [
            .init(identifier: "exp-beginner", title: "Beginner"),
            .init(identifier: "exp-intermediate", title: "Intermediate"),
            .init(identifier: "exp-advanced", title: "Advanced")
        ]
    ),
    SurveyQuestion(
        identifier: "feature-interest-q2",
        title: "What features interest you?",
        answers: [
            .init(identifier: "feat-analytics", title: "Analytics"),
            .init(identifier: "feat-reporting", title: "Reporting"),
            .init(identifier: "feat-sharing", title: "Sharing"),
            .init(identifier: "feat-export", title: "Export")
        ],
        isMultipleChoice: true
    )
]
```

This is useful for:
- Paper surveys: `identifier: "question 1"`, `identifier: "answer A"`
- Analytics tracking: `identifier: "app-user-sentiment-survey-question-1-version-1"`
- Database mapping: Use identifiers as foreign keys
- Multi-version surveys: Track question/answer versions over time

### Basic Implementation

```swift
import Surveys
import SwiftUI

struct ContentView: View {
    let questions: [SurveyQuestion] = .mock()

    var body: some View {
        SurveyFlow(
            questions: questions,
            onAnswer: { question, answers in
                // Handle each question's answers
                print("Question: \(question.title)")
                if let questionId = question.identifier {
                    print("Question ID: \(questionId)")
                }
                print("Selected answers: \(answers)")
                
                // Access answer identifiers
                for answer in answers {
                    if let answerId = answer.identifier {
                        print("Answer ID: \(answerId) - \(answer.title)")
                    }
                }
            },
            onCompletion: {
                // Handle survey completion
                print("Survey completed")
            }
        )
    }
}
```

### Skip Button Example

```swift
import Surveys
import SwiftUI

@MainActor
struct ContentScreen {
    private func skipAction() {
        // TODO: skip the survey
    }
}

extension ContentScreen: View {
    var body: some View {
        NavigationStack {
            SurveyFlow(questions: .mock())
                .toolbar(content: toolbarContent)
        }
    }

    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(
            placement: .confirmationAction,
            content: skipButton
        )
    }

    private func skipButton() -> some View {
        Button(.skip, action: skipAction)
    }
}

@MainActor
extension LocalizedStringKey {
    static let skip = LocalizedStringKey("Skip")
}

#Preview {
    ContentScreen()
}
```
