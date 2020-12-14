import Foundation
import SwiftUI

struct TopicDetailView: View {
    @State var topic: Topic

    private let style = Style()

    @State var isActivityIndicatorLoaing: Bool = true
    @State private var topicContents: [ArticleContent] = [ArticleContent]()

    var body: some View {
        Group {
            if isActivityIndicatorLoaing {
                ActivityIndicator(isLoading: $isActivityIndicatorLoaing)
            } else {
                ScrollView {
                    Group {
                        VStack {
                            Text("").frame(
                                height: style.informationPaddingTop
                            )
                            GeometryReader { _ in
                                TopicInformationView(
                                    topic: topic
                                ).padding(
                                    .bottom, style.informationPaddingBottom
                                )
                            }.padding(
                                .leading, style.informationPaddingLeading
                            )
                            ForEach(topicContents, id: \.id) { topicContent in
                                AttributedContentView(
                                    uiView: topicContent.uiView
                                ).frame(
                                    height: topicContent.uiViewHeigth
                                )
                            }.padding(
                                .horizontal, style.contentPaddingLeading
                            )
                            Divider()
                            TopicCommentsInformationView(
                                topic: topic
                            )
                        }
                    }.navigationBarTitle(
                        style.navigationBarHeaderNameUkrainian,
                        displayMode: .inline
                    )
                }.padding(
                    .bottom, style.contentPaddingBottom
                )
            }
        }.onAppear {
            Html(url: topic.url!).get { html in
                guard let html = html else {
                    return
                }

                let articleHtmlSource = ArticleHtmlSource(
                    html: html,
                    rootTag: "article",
                    identifier: .class_
                )

                let articleService = ArticleService(source: articleHtmlSource)

                self.topicContents = articleService.get()
                self.isActivityIndicatorLoaing = false

                let topicViewsCountHtmlSource = TopicViewsCountHtmlSource(html: html)

                let topicViewsCountService = TopicViewsCountService(source: topicViewsCountHtmlSource)
                self.topic.viewsCount = topicViewsCountService.get()
            }
        }
    }

    struct Style {
        let informationSpacingHorizontal: CGFloat = 15
        let informationPaddingLeading: CGFloat = 20
        let informationPaddingTop: CGFloat = 10
        let informationPaddingBottom: CGFloat = 10
        let contentPaddingBottom: CGFloat = 15
        let contentPaddingLeading: CGFloat = 20
        let navigationBarHeaderNameUkrainian: String = "Топік"
        let navigationBarHeaderNameRussian: String = "Топик"
    }
}

struct TopicInformationView: View {
    let topic: Topic

    private let style = Style()

    var body: some View {
        HStack(spacing: style.spacingHorizontal) {
            PostAuthorName(
                authorName: topic.authorName!,
                font: style.font,
                color: style.color,
                size: style.size
            )
            PostPublicationDate(
                publicationDate: DateRepresentation(
                    date: topic.publicationDate!
                ).get(
                    localization: .ukrainian
                ),
                font: style.font,
                color: style.color,
                size: style.size
            )
            PostViewsCount(
                viewsCount: topic.viewsCount!,
                imageSystemNane: style.viewsCountImageSystemName,
                font: style.font,
                color: style.color,
                size: style.size
            )
            PostCommentsCount(
                commentsCount: topic.commentsCount!,
                imageSystemNane: style.commentsCountImageSystemName,
                font: style.font,
                color: style.color,
                size: style.size
            )
        }
    }

    struct Style {
        let font: String = "Arial"
        let size: CGFloat = 13
        let color = Color(
            red: 0,
            green: 0,
            blue: 0,
            opacity: 1.0
        )
        let spacingHorizontal: CGFloat = 15
        let viewsCountImageSystemName: String = "eye.fill"
        let commentsCountImageSystemName: String = "bubble.right.fill"
    }
}

struct TopicCommentsInformationView: View {
    let topic: Topic

    private let style = Style()

    var body: some View {
        VStack {
            if topic.commentsCount! > 0 {
                NavigationLink(
                    destination: TopicCommentsScreenView(topic: topic)
                ) {
                    (
                        Text(
                            Image(
                                systemName: style.imageSystemName
                            )
                        ) + Text(
                            " \(topic.commentsCount!) \(style.wordCommentsUkrainian.lowercased())"
                        )
                    ).foregroundColor(
                        style.color
                    )
                }
            } else {
                (
                    Text(
                        Image(
                            systemName: style.imageSystemName
                        )
                    ) + Text(
                        " \(style.wordNoCommentsNameUkrainian)"
                    )
                ).foregroundColor(
                    style.color
                )
            }
        }.frame(height: style.height)
    }

    struct Style {
        let height: CGFloat = 30
        let imageSystemName: String = "bubble.right.fill"
        let color = Color.black
        let wordCommentsUkrainian: String = "Коментарі"
        let wordCommentsRussian: String = "Комментарии"
        let wordNoCommentsNameUkrainian: String = "Немає комментарів"
        let wordNoCommentsNameRussian: String = "Нет комментариев"
    }
}
