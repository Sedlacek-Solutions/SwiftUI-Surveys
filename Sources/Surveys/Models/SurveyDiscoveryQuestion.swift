import SwiftUI

/// A required, single-choice question for collecting an acquisition source.
///
/// Discovery questions are runtime-only so their sources can contain arbitrary
/// SwiftUI icon content. Their selected value is still reported through the
/// regular survey question and answer callbacks.
@MainActor
public struct SurveyDiscoveryQuestion: Identifiable {
    public let id: String
    public let titleKey: String
    public let sources: [SurveyDiscoverySource]

    public init(
        id: String = UUID().uuidString,
        titleKey: String,
        sources: [SurveyDiscoverySource]
    ) {
        self.id = id
        self.titleKey = titleKey
        self.sources = sources
    }

    /// The regular question used for callbacks, branching, and results.
    public var question: SurveyQuestion {
        SurveyQuestion(
            id: id,
            titleKey: titleKey,
            answers: sources.filter { !$0.isOther }.map(\.answer)
        )
    }

    public var title: LocalizedStringKey {
        LocalizedStringKey(titleKey)
    }

    internal var otherAnswerID: String { "\(id).other" }

    internal func answers(
        selecting source: SurveyDiscoverySource,
        otherText: String = ""
    ) -> Set<SurveyAnswer> {
        guard source.isOther else { return [source.answer] }
        guard !otherText.isEmpty else { return [] }

        return [SurveyAnswer(
            id: otherAnswerID,
            titleKey: otherText,
            titleString: otherText
        )]
    }
}

/// A selectable source displayed by a discovery question.
@MainActor
public struct SurveyDiscoverySource: Identifiable {
    enum Icon {
        case appIcon(assetName: String)
        case systemImage(String)
        case custom(@MainActor () -> AnyView)
    }

    public let id: String
    public let titleKey: String
    public let answer: SurveyAnswer

    let icon: Icon
    let isOther: Bool
    let usesPackageLocalization: Bool

    private init(
        id: String,
        titleKey: String,
        icon: Icon,
        isOther: Bool = false,
        usesPackageLocalization: Bool = true
    ) {
        self.id = id
        self.titleKey = titleKey
        self.answer = SurveyAnswer(id: id, titleKey: titleKey)
        self.icon = icon
        self.isOther = isOther
        self.usesPackageLocalization = usesPackageLocalization
    }

    /// Creates an app-defined source with arbitrary SwiftUI icon content.
    public static func custom<IconContent: View>(
        id: String,
        titleKey: String,
        @ViewBuilder icon: @escaping @MainActor () -> IconContent
    ) -> Self {
        .init(
            id: id,
            titleKey: titleKey,
            icon: .custom { AnyView(icon()) },
            usesPackageLocalization: false
        )
    }

    public static let appStore = appIcon("app-store", "App Store", "BrandAppStore")
    public static let google = appIcon("google", "Google", "BrandGoogle")
    public static let instagram = appIcon("instagram", "Instagram", "BrandInstagram")
    public static let tiktok = appIcon("tiktok", "TikTok", "BrandTikTok")
    public static let youtube = appIcon("youtube", "YouTube", "BrandYouTube")
    public static let facebook = appIcon("facebook", "Facebook", "BrandFacebook")
    public static let x = appIcon("x", "X", "BrandX")
    public static let reddit = appIcon("reddit", "Reddit", "BrandReddit")
    public static let threads = appIcon("threads", "Threads", "BrandThreads")
    public static let linkedIn = appIcon("linkedin", "LinkedIn", "BrandLinkedIn")
    public static let productHunt = appIcon("product-hunt", "Product Hunt", "BrandProductHunt")
    public static let referral = system(
        "referral",
        "Referral",
        "person.2.fill"
    )
    @available(*, deprecated, renamed: "referral")
    public static let friendOrColleague = referral
    public static let podcast = system("podcast", "Podcast", "mic.fill")
    public static let articleOrBlog = system(
        "article-or-blog",
        "Article or blog",
        "doc.text.fill"
    )
    public static let other = SurveyDiscoverySource(
        id: "other",
        titleKey: "Other",
        icon: .systemImage("ellipsis"),
        isOther: true
    )

    /// All built-in presets in their recommended order.
    public static let allPresets: [Self] = [
        .appStore, .google, .instagram, .tiktok, .youtube, .facebook,
        .x, .reddit, .threads, .linkedIn, .productHunt,
        .referral, .podcast, .articleOrBlog, .other
    ]

    internal var bundledBrandIconExists: Bool {
        guard case .appIcon(let assetName) = icon else { return true }
        return Bundle.module.url(
            forResource: assetName,
            withExtension: "png"
        ) != nil
    }

    private static func appIcon(
        _ id: String,
        _ titleKey: String,
        _ assetName: String
    ) -> Self {
        .init(
            id: id,
            titleKey: titleKey,
            icon: .appIcon(assetName: assetName)
        )
    }

    private static func system(
        _ id: String,
        _ titleKey: String,
        _ systemImage: String
    ) -> Self {
        .init(id: id, titleKey: titleKey, icon: .systemImage(systemImage))
    }
}
