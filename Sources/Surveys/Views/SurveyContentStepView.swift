//
//  SurveyContentStepView.swift
//
//  Created by James Sedlacek on 7/4/26.
//

import SwiftUI

@MainActor
struct SurveyContentStepView {
    @Environment(\.surveyAccentColor) private var surveyAccentColor
    @Environment(\.surveyFlowAnimation) private var surveyFlowAnimation
    private let step: SurveyContentStep
    private let animationTrigger: String

    init(
        step: SurveyContentStep,
        animationTrigger: String
    ) {
        self.step = step
        self.animationTrigger = animationTrigger
    }
}

extension SurveyContentStepView: View {
    var body: some View {
        VStack(spacing: 16) {
            titleView
            contentView
        }
    }

    private var titleView: some View {
        Text(step.title, bundle: .module)
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

    private var contentView: some View {
        ScrollView {
            VStack(spacing: 28) {
                mediaView
                    .surveyEntrance(
                        trigger: animationTrigger,
                        delay: itemDelay(for: 0),
                        animation: surveyFlowAnimation.itemAnimation,
                        configuration: surveyFlowAnimation
                    )
                bodyView
                    .surveyEntrance(
                        trigger: animationTrigger,
                        delay: itemDelay(for: bodyItemIndex),
                        animation: surveyFlowAnimation.itemAnimation,
                        configuration: surveyFlowAnimation
                    )
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
        }
        .scrollIndicators(.hidden)
    }

    private var bodyItemIndex: Int {
        step.media == nil ? 0 : 1
    }

    private func itemDelay(for index: Int) -> TimeInterval {
        surveyFlowAnimation.itemBaseDelay + (Double(index) * surveyFlowAnimation.itemDelay)
    }

    @ViewBuilder
    private var mediaView: some View {
        if let media = step.media {
            switch media {
            case .systemImage(let systemName):
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(surveyAccentColor)
                    .frame(maxWidth: 160, maxHeight: 160)
                    .padding(32)
                    .background(.background.secondary, in: RoundedRectangle(cornerRadius: 8))
            case .asset(let name):
                Image(name)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    @ViewBuilder
    private var bodyView: some View {
        if let body = step.body {
            Text(body, bundle: .module)
                .font(.title3.weight(.medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
        }
    }
}

#Preview {
    SurveyContentStepView(
        step: .init(
            titleKey: "Designed to help you stay on track",
            bodyKey: "Track your habits and stay consistent over time.",
            media: .systemImage("chart.line.uptrend.xyaxis")
        ),
        animationTrigger: "preview"
    )
    .padding(24)
}
