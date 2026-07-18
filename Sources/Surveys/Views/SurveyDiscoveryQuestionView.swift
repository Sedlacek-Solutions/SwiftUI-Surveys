import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

@MainActor
struct SurveyDiscoveryQuestionView: View {
    private let discoveryQuestion: SurveyDiscoveryQuestion
    private let textBundle: Bundle?
    private let animationTrigger: String
    @Environment(\.surveyAccentColor) private var surveyAccentColor
    @Environment(\.surveyFlowAnimation) private var surveyFlowAnimation
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Binding private var answers: Set<SurveyAnswer>
    @State private var otherText = ""
    @State private var isOtherSelected = false

    init(
        question: SurveyDiscoveryQuestion,
        textBundle: Bundle?,
        answers: Binding<Set<SurveyAnswer>>,
        animationTrigger: String
    ) {
        self.discoveryQuestion = question
        self.textBundle = textBundle
        self.animationTrigger = animationTrigger
        self._answers = answers
    }

    var body: some View {
        VStack(spacing: 16) {
            titleView
            sourceList
        }
        .onAppear(perform: restoreSelection)
        .onChange(of: discoveryQuestion.id) {
            restoreSelection()
        }
    }

    private var titleView: some View {
        Text(discoveryQuestion.title, bundle: textBundle ?? .module)
            .font(.largeTitle.weight(.semibold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
            .padding(.bottom, 24)
            .surveyEntrance(
                trigger: animationTrigger,
                delay: surveyFlowAnimation.titleDelay,
                animation: surveyFlowAnimation.titleAnimation,
                configuration: surveyFlowAnimation
            )
    }

    private var sourceList: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(Array(discoveryQuestion.sources.enumerated()), id: \.element.id) { index, source in
                    sourceCard(source)
                        .surveyEntrance(
                            trigger: animationTrigger,
                            delay: itemDelay(for: index),
                            animation: surveyFlowAnimation.itemAnimation,
                            configuration: surveyFlowAnimation
                        )
                }
            }
            .padding(.vertical)

            if isOtherSelected {
                OtherTextField(text: $otherText)
                    .onChange(of: otherText, otherTextChanged)
                    .surveyEntrance(
                        trigger: animationTrigger,
                        delay: itemDelay(for: discoveryQuestion.sources.count),
                        animation: surveyFlowAnimation.itemAnimation,
                        configuration: surveyFlowAnimation
                    )
                    .padding(.bottom)
            }
        }
        .scrollIndicators(.hidden)
    }

    private var columns: [GridItem] {
        let count = dynamicTypeSize.isAccessibilitySize ? 1 : 2
        return Array(
            repeating: GridItem(.flexible(), spacing: 12, alignment: .top),
            count: count
        )
    }

    private func sourceCard(_ source: SurveyDiscoverySource) -> some View {
        let isSelected = isSelected(source)

        return Button {
            select(source)
        } label: {
            VStack(spacing: 12) {
                sourceIcon(source)

                Text(
                    LocalizedStringKey(source.titleKey),
                    bundle: source.usesPackageLocalization ? .module : (textBundle ?? .module)
                )
                .font(.body.weight(.semibold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(maxWidth: .infinity)
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 112)
            .background(.background.secondary, in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? surveyAccentColor.opacity(0.04) : .clear)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(
                        isSelected ? surveyAccentColor.opacity(0.7) : .clear,
                        lineWidth: 2
                    )
            }
            .overlay(alignment: .topTrailing) {
                if isSelected {
                    Image(.checkmarkCircleFill)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, surveyAccentColor)
                        .padding(10)
                }
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(
            Text(
                LocalizedStringKey(source.titleKey),
                bundle: source.usesPackageLocalization ? .module : (textBundle ?? .module)
            )
        )
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    @ViewBuilder
    private func sourceIcon(_ source: SurveyDiscoverySource) -> some View {
        switch source.icon {
        case .appIcon(let assetName):
            if let image = bundledImage(named: assetName) {
                image
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 46, height: 46)
                    .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 11, style: .continuous)
                            .strokeBorder(.primary.opacity(0.08))
                    }
            }

        case .systemImage(let systemImage):
            Image(systemName: systemImage)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 46, height: 46)
                .background(surveyAccentColor, in: RoundedRectangle(cornerRadius: 11))

        case .custom(let content):
            content()
                .frame(width: 46, height: 46)
        }
    }

    private func bundledImage(named assetName: String) -> Image? {
        guard let url = Bundle.module.url(
            forResource: assetName,
            withExtension: "png"
        ) else { return nil }

        #if canImport(UIKit)
        guard let image = UIImage(contentsOfFile: url.path) else { return nil }
        return Image(uiImage: image)
        #elseif canImport(AppKit)
        guard let image = NSImage(contentsOf: url) else { return nil }
        return Image(nsImage: image)
        #else
        return nil
        #endif
    }

    private func select(_ source: SurveyDiscoverySource) {
        if source.isOther {
            isOtherSelected = true
            answers = discoveryQuestion.answers(
                selecting: source,
                otherText: otherText
            )
        } else {
            isOtherSelected = false
            otherText = ""
            answers = discoveryQuestion.answers(selecting: source)
        }
    }

    private func isSelected(_ source: SurveyDiscoverySource) -> Bool {
        source.isOther ? isOtherSelected : answers.contains(source.answer)
    }

    private func otherTextChanged(oldText: String, newText: String) {
        guard isOtherSelected else { return }
        answers = discoveryQuestion.answers(
            selecting: .other,
            otherText: newText
        )
    }

    private func restoreSelection() {
        guard let otherAnswer = answers.first(where: {
            $0.id == discoveryQuestion.otherAnswerID
        }) else {
            isOtherSelected = false
            otherText = ""
            return
        }

        isOtherSelected = true
        otherText = otherAnswer.titleString ?? otherAnswer.titleKey
    }

    private func itemDelay(for index: Int) -> TimeInterval {
        surveyFlowAnimation.itemBaseDelay + (Double(index) * surveyFlowAnimation.itemDelay)
    }
}
