//
//  SurveyFlowAnimation.swift
//
//  Created by James Sedlacek on 7/8/26.
//

import SwiftUI

/// Controls the entrance animation used when a survey flow moves between steps.
public struct SurveyFlowAnimation: Sendable {
    /// Whether step entrance animations should run.
    public var isEnabled: Bool
    /// Animation used for the step title.
    public var titleAnimation: Animation
    /// Delay before the step title animates in.
    public var titleDelay: TimeInterval
    /// Animation used for answer and content items.
    public var itemAnimation: Animation
    /// Animation used for progress value changes.
    public var progressAnimation: Animation
    /// Delay before the first answer or content item animates in.
    public var itemBaseDelay: TimeInterval
    /// Additional delay applied per answer or content item.
    public var itemDelay: TimeInterval
    /// Vertical offset applied before each element animates in.
    public var verticalOffset: CGFloat
    /// Opacity applied before each element animates in.
    public var hiddenOpacity: Double

    public init(
        isEnabled: Bool = true,
        titleAnimation: Animation = .smooth(duration: 0.42, extraBounce: 0),
        titleDelay: TimeInterval = 0,
        itemAnimation: Animation = .smooth(duration: 0.46, extraBounce: 0),
        progressAnimation: Animation = .smooth(duration: 0.56, extraBounce: 0),
        itemBaseDelay: TimeInterval = 0.1,
        itemDelay: TimeInterval = 0.04,
        verticalOffset: CGFloat = 8,
        hiddenOpacity: Double = 0
    ) {
        self.isEnabled = isEnabled
        self.titleAnimation = titleAnimation
        self.titleDelay = titleDelay
        self.itemAnimation = itemAnimation
        self.progressAnimation = progressAnimation
        self.itemBaseDelay = itemBaseDelay
        self.itemDelay = itemDelay
        self.verticalOffset = verticalOffset
        self.hiddenOpacity = hiddenOpacity
    }

    /// The default title-first, cascading-item entrance animation.
    public static let `default` = SurveyFlowAnimation()

    /// Disables step entrance animations.
    public static let disabled = SurveyFlowAnimation(isEnabled: false)
}

private struct SurveyFlowAnimationKey: EnvironmentKey {
    static let defaultValue: SurveyFlowAnimation = .default
}

public extension EnvironmentValues {
    /// The animation configuration used by built-in survey flow screens.
    var surveyFlowAnimation: SurveyFlowAnimation {
        get { self[SurveyFlowAnimationKey.self] }
        set { self[SurveyFlowAnimationKey.self] = newValue }
    }
}

public extension View {
    /// Sets the animation configuration used when survey flow steps enter.
    func surveyFlowAnimation(_ animation: SurveyFlowAnimation) -> some View {
        environment(\.surveyFlowAnimation, animation)
    }
}

extension View {
    func surveyEntrance(
        trigger: String,
        delay: TimeInterval,
        animation: Animation,
        configuration: SurveyFlowAnimation
    ) -> some View {
        modifier(
            SurveyEntranceModifier(
                trigger: trigger,
                delay: delay,
                animation: animation,
                configuration: configuration
            )
        )
    }
}

private struct SurveyEntranceModifier: ViewModifier {
    let trigger: String
    let delay: TimeInterval
    let animation: Animation
    let configuration: SurveyFlowAnimation
    @State private var isVisible = false
    @State private var visibilityTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        content
            .opacity(resolvedOpacity)
            .offset(y: resolvedOffset)
            .onAppear(perform: startAnimation)
            .onChange(of: trigger) { _, _ in
                startAnimation()
            }
            .onDisappear {
                visibilityTask?.cancel()
            }
    }

    private var resolvedOpacity: Double {
        guard configuration.isEnabled else { return 1 }
        return isVisible ? 1 : configuration.hiddenOpacity
    }

    private var resolvedOffset: CGFloat {
        guard configuration.isEnabled else { return 0 }
        return isVisible ? 0 : configuration.verticalOffset
    }

    private func startAnimation() {
        visibilityTask?.cancel()

        guard configuration.isEnabled else {
            isVisible = true
            return
        }

        isVisible = false

        visibilityTask = Task { @MainActor in
            if delay > 0 {
                try? await Task.sleep(nanoseconds: UInt64(max(0, delay) * 1_000_000_000))
            }

            guard !Task.isCancelled else { return }

            withAnimation(animation) {
                isVisible = true
            }
        }
    }
}
