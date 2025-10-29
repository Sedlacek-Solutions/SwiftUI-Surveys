![SwiftUI-Surveys](https://github.com/user-attachments/assets/cba9fc77-c42c-4c9e-96c9-de7c6dabb2dd)

# SwiftUI-Surveys

A Swift package that provides an elegant and customizable survey interface for iOS applications using SwiftUI. <br>
SwiftUI-Surveys makes it easy to create professional-looking surveys with a modern design and smooth user experience.

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
        answers: ["Beginner", "Intermediate", "Advanced"],
        isMultipleChoice: false
    ),
    SurveyQuestion(
        title: "What features interest you?",
        answers: ["Analytics", "Reporting", "Sharing", "Export"],
        isMultipleChoice: true
    )
]
```

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
                print("Selected answers: \(answers)")
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
