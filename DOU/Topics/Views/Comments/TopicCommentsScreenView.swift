import Foundation
import SwiftUI

struct TopicCommentsScreenView: View {
    let topic: Topic

    @State var isActivityIndicatorLoaing: Bool = true
    @State private var topicComments: [TopicComment] = [TopicComment]()
    @State private var topicBestComments: [TopicComment] = [TopicComment]()
    @State private var topicCommentsNumber: Int = 0

    private let style = Style()

    init(topic: Topic) {
        UINavigationBar.appearance().titleTextAttributes = [
            .font: UIFont.systemFont(
                ofSize: style.navigationBarHeaderSize,
                weight: UIFont.Weight.semibold
            )
        ]

        self.topic = topic
    }

    var body: some View {
        Group {
            if isActivityIndicatorLoaing {
                ActivityIndicator(isLoading: $isActivityIndicatorLoaing)
            } else {
                ScrollView {
                    if !topicBestComments.isEmpty {
                        Text(
                            style.bestCommentsNameUkrainian
                        ).font(
                            Font.system(
                                size: style.topicBestCommentsTitleFontSize,
                                weight: style.topicBestCommentsTitleFontWeight,
                                design: style.topicBestCommentsTitleFontDesign
                            )
                        ).frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        ).padding(
                            .leading, style.commentsPaddingLeading
                        )
                        Divider()
                        TopicCommentsView(
                            topicAuthorName: topic.authorName!,
                            topicComments: topicBestComments
                        )
                    }

                    if !topicComments.isEmpty {
                        Text(
                            "\(topicCommentsNumber) \(style.commentsNameUkrainian.lowercased())"
                        ).font(
                            Font.system(
                                size: style.topicCommentsNumberFontSize,
                                weight: style.topicCommentsNumberFontWeight,
                                design: style.topicCommentsNumberFontDesign
                            )
                        ).frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        ).padding(
                            EdgeInsets(
                                top: topicBestComments.isEmpty ? 0 : 24,
                                leading: style.commentsPaddingLeading,
                                bottom: style.commentsPaddingBottom,
                                trailing: style.commentsPaddingTrailing
                            )
                        )
                        Divider()
                        TopicCommentsView(
                            topicAuthorName: topic.authorName!,
                            topicComments: topicComments
                        )
                    }
                }.navigationBarTitle(
                    style.navigationBarHeaderNameUkrainian,
                    displayMode: .inline
                ).padding(
                    .top, style.commentsPaddingTop
                )
            }
        }.onAppear {
            Html(url: topic.url!).get() { html in
                guard let html = html else {
                    return
                }

                let topicCommentsHtmlSource = ArticleCommentsHtmlSource(
                    html: html,
                    rootTag: "commentsList",
                    identifier: .id
                )

                let topicBestCommentsHtmlSource = ArticleCommentsHtmlSource(
                    html: html,
                    rootTag: "b-comments __best",
                    identifier: .class_
                )

                let topicComments = TopicCommentsService(source: topicCommentsHtmlSource)
                let topicBestComments = TopicCommentsService(source: topicBestCommentsHtmlSource)

                self.topicComments = topicComments.get()
                self.topicBestComments = topicBestComments.get()
                self.topicCommentsNumber = self.topicComments.count
                self.isActivityIndicatorLoaing = false
            }
        }
    }

    struct Style {
        let topicBestCommentsTitleFontSize: CGFloat = 16
        let topicBestCommentsTitleFontWeight: Font.Weight = .semibold
        let topicBestCommentsTitleFontDesign: Font.Design = .default
        let topicCommentsNumberFontSize: CGFloat = 18
        let topicCommentsNumberFontWeight: Font.Weight = .semibold
        let topicCommentsNumberFontDesign: Font.Design = .default
        let commentsPaddingTop: CGFloat = 12
        let commentsPaddingLeading: CGFloat = 20
        let commentsPaddingBottom: CGFloat = 0
        let commentsPaddingTrailing: CGFloat = 0
        let commentsNameUkrainian: String = "Коментарі"
        let commentsNameRussian: String = "Комментарии"
        let bestCommentsNameUkrainian: String = "Найкращі коментарі"
        let bestCommentsNameRussian: String = "Лучшие комментарии"
        let navigationBarHeaderSize: CGFloat = 20
        let navigationBarHeaderNameUkrainian: String = "Коментарі"
        let navigationBarHeaderNameRussian: String = "Комментарии"
    }
}
