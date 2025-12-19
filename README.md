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
        titleKey: "How would you describe your experience?",
        answers: [
            .init(titleKey: "Beginner"),
            .init(titleKey: "Intermediate"),
            .init(titleKey: "Advanced")
        ],
        isMultipleChoice: false
    ),
    SurveyQuestion(
        titleKey: "What features interest you?",
        answers: [
            .init(titleKey: "Analytics"),
            .init(titleKey: "Reporting"),
            .init(titleKey: "Sharing"),
            .init(titleKey: "Export")
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
        titleKey: "How would you describe your experience?",
        answers: [
            .init(titleKey: "Beginner", systemImage: "figure.walk"),
            .init(titleKey: "Intermediate", systemImage: "figure.hiking"),
            .init(titleKey: "Advanced", systemImage: "figure.run")
        ]
    ),
    SurveyQuestion(
        titleKey: "What features interest you?",
        answers: [
            .init(titleKey: "Analytics", systemImage: "chart.bar"),
            .init(titleKey: "Reporting", systemImage: "doc.text.magnifyingglass"),
            .init(titleKey: "Sharing", systemImage: "square.and.arrow.up"),
            .init(titleKey: "Export", systemImage: "arrow.down.doc")
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
        titleKey: "survey.question.experience",
        answers: [
            .init(titleKey: "survey.answer.beginner", systemImage: "figure.walk"),
            .init(titleKey: "survey.answer.intermediate", systemImage: "figure.hiking"),
            .init(titleKey: "survey.answer.advanced", systemImage: "figure.run")
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

### JSON Support

`SurveyQuestion` and `SurveyAnswer` conform to `Codable`, so you can serialize surveys to JSON and load them back at runtime:

```swift
import Surveys

let questions: [SurveyQuestion] = .mock()

let encoder = JSONEncoder()
encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
let data = try encoder.encode(questions)

let decoder = JSONDecoder()
let decoded = try decoder.decode([SurveyQuestion].self, from: data)
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
                // Handle each question's answers immediately when user submits
                print("Question: \(question.title)")
                print("Selected answers: \(answers)")
                
                // Access answer titles
                for answer in answers {
                    print("Answer: \(answer.title)")
                }
            },
            onCompletion: { allAnswers in
                // Handle survey completion with all questions and answers
                print("Survey completed!")
                print("Total questions answered: \(allAnswers.count)")
                
                // Process all answers together
                for (question, answers) in allAnswers {
                    print("Question: \(question.title)")
                    print("Answers: \(answers.map { $0.title })")
                }
                
                // Example: Serialize to JSON and upload
                // let jsonData = encodeToJSON(allAnswers)
                // uploadSurveyResults(jsonData)
            }
        )
    }
}
```

### Handling Only Final Results

If you don't need to process answers individually as they're submitted, you can omit the `onAnswer` parameter and only handle the final results:

```swift
struct ContentView: View {
    let questions: [SurveyQuestion] = .mock()

    var body: some View {
        SurveyFlow(questions: questions) { allAnswers in
            // Handle all answers at once when survey is complete
            processSurveyResults(allAnswers)
        }
    }
    
    func processSurveyResults(_ answers: [SurveyQuestion: Set<SurveyAnswer>]) {
        // Process or serialize all answers together
        print("Survey completed with \(answers.count) questions answered")
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
