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
- 🌍 Full localization support with LocalizedStringKey
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

### Using System Images

Answers can include an optional SF Symbol to show alongside the label:

```swift
let questions = [
    SurveyQuestion(
        title: "How would you describe your experience?",
        answers: [
            .init(title: "Beginner", systemImage: "figure.walk"),
            .init(title: "Intermediate", systemImage: "figure.hiking"),
            .init(title: "Advanced", systemImage: "figure.run")
        ]
    ),
    SurveyQuestion(
        title: "What features interest you?",
        answers: [
            .init(title: "Analytics", systemImage: "chart.bar"),
            .init(title: "Reporting", systemImage: "doc.text.magnifyingglass"),
            .init(title: "Sharing", systemImage: "square.and.arrow.up"),
            .init(title: "Export", systemImage: "arrow.down.doc")
        ],
        isMultipleChoice: true
    )
]
```

### Localization Support

SwiftUI-Surveys supports localization using `LocalizedStringKey`. You can provide localized strings for both questions and answers:

```swift
let questions = [
    SurveyQuestion(
        title: LocalizedStringKey("survey.question.experience"),
        answers: [
            .init(title: LocalizedStringKey("survey.answer.beginner"), systemImage: "figure.walk"),
            .init(title: LocalizedStringKey("survey.answer.intermediate"), systemImage: "figure.hiking"),
            .init(title: LocalizedStringKey("survey.answer.advanced"), systemImage: "figure.run")
        ]
    )
]
```

Add your localized strings to your `Localizable.strings` file:

```
// English (en)
"survey.question.experience" = "How would you describe your experience?";
"survey.answer.beginner" = "Beginner";
"survey.answer.intermediate" = "Intermediate";
"survey.answer.advanced" = "Advanced";

// Spanish (es)
"survey.question.experience" = "¿Cómo describirías tu experiencia?";
"survey.answer.beginner" = "Principiante";
"survey.answer.intermediate" = "Intermedio";
"survey.answer.advanced" = "Avanzado";
```

### Included Localizations

The package ships translations for the built-in UI strings (Back, Next, Other, Select all that apply) in these locales:

- English (en)
- Spanish (es)
- French (fr)
- German (de)
- Italian (it)
- Portuguese (Brazil) (pt-BR)
- Japanese (ja)
- Korean (ko)
- Chinese (Simplified) (zh-Hans)
- Chinese (Traditional) (zh-Hant)

When using the provided `LocalizedStringKey` helpers (for example `.back`, `.next`), use `Text(..., bundle: .module)` so the keys resolve from the package bundle.

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
                
                // Access answer titles
                for answer in answers {
                    print("Answer: \(answer.title)")
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
        Button(action: skipAction) {
            Text(.skip, bundle: .module)
        }
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
