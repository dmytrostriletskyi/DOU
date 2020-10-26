import Foundation
import SwiftUI
import URLImage

struct ArticlesView: View {
    
    @ObservedObject var articlesService: ArticlesService = ArticlesService()
    
    private let navigationBarStyle: NavigationBarStyle = NavigationBarStyle()
    private let tabBarStyle: TabBarStyle = TabBarStyle()

    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            .font: UIFont.systemFont(
                ofSize: CGFloat(navigationBarStyle.headerSize),
                weight: UIFont.Weight.semibold
            )
        ]
    }

    var body: some View {
        VStack(alignment: .leading) {
            NavigationView() {
                List(
                    articlesService.article
                ) { (article: Article) in
                    ZStack {
                        ArticlesItemView(
                            article: article
                        ).onAppear {
                            articlesService.fetchNext(
                                currentArticle: article
                            )
                        }.padding(
                            .horizontal, 5
                        )
                        NavigationLink(
                            destination: ArticleView(article: article),
                            label: {}
                        ).frame(
                            width: 0
                        )
                    }
                }.navigationBarTitle(
                    tabBarStyle.articlesTabNameUkrainian,
                    displayMode: .inline
                )
            }
        }
    }
}

struct ArticlesItemView: View {
    
    let article: Article

    var body: some View {
        VStack(alignment: .leading) {
            URLImage(
                URL(
                    string: article.imageUrl
                )!,
                processors: [
                    Resize(
                        size: CGSize(width: UIScreen.main.bounds.size.width - 41.5, height: 179),
                        scale: UIScreen.main.scale)
                ],
                content:  {
                    $0.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                }
            ).frame(
                width: UIScreen.main.bounds.size.width - 41.5,
                height: 179
            )
            Spacer()
            RegularPostTitle(title: article.title)
            HStack() {
                RegularPostAuthorName(authorName: article.authorName)
                RegularPostPublicationDate(
                    publicationDate: DateRepresentation(
                        date: article.publicationDate
                    ).get(
                        localization: .ukrainian
                    )
                )
                Spacer()
                RegularPostViews(views: article.views)
                RegularPostCommentsCount(commentsCount: article.commentsCount)
            }.padding(
                .vertical, 1
            )
        }.padding(
            .vertical, 10
        )
    }
}

struct ArticleView: View {
    
    public let article: Article

    @State public var isActivityIndicatorLoaing: Bool = true
    @State private var htmlStrings: [HtmlString] = [HtmlString]()
    
    var body: some View {
        Group {
            if isActivityIndicatorLoaing {
                ActivityIndicator(isLoading: $isActivityIndicatorLoaing)
            } else {
                ScrollView {
                    Group {
                        VStack {
                            Text("").frame(height: 10)
                            GeometryReader { _ in
                                HStack(spacing: 15) {
                                    AttributedPostAuthorName(authorName: article.authorName)
                                    AttributedPostPublicationDate(
                                        publicationDate: DateRepresentation(
                                            date: article.publicationDate
                                        ).get(
                                            localization: .ukrainian
                                        )
                                    )
                                    AttributedPostViews(views: article.views)
                                    AttributedPostCommentsCount(commentsCount: article.commentsCount)
                                }.padding(.bottom, 10)
                            }.padding(.leading, 21)
                            ForEach(htmlStrings, id: \.id) { htmlString in
                                if htmlString.type == HtmlStringType.text {
                                    PostTextView(uiView: htmlString.uiView).frame(height: htmlString.uiViewHeigth)
                                }

                                if htmlString.type == HtmlStringType.image {
                                    PostImageView(uiView: htmlString.uiView).frame(height: htmlString.uiViewHeigth)
                                }
                            }.padding(.horizontal, 20)
                            Divider()
                            VStack {
                                if article.commentsCount > 0 {
                                    NavigationLink(
                                        destination: ArticleCommentsView(article: article)
                                    ) {
                                        Text("\(article.commentsCount) комментар(ів)").foregroundColor(Color.black).underline()
                                    }
                                } else {
                                    Text("Немає комментарів").foregroundColor(Color.black).underline()
                                }
                            }.frame(height: 30)
                        }
                    }
                }.padding(.bottom, 15)
            }
        }.onAppear {
            Html(url: article.url).get() { html in
                guard let html = html else {
                    return
                }

                let htmlParser: ArticlesHtmlParser = ArticlesHtmlParser(html: html, rootTag: "article")

                guard let htmlString: [HtmlString] = htmlParser.parse() else {
                    return
                }

                self.htmlStrings = htmlString
                self.isActivityIndicatorLoaing = false
            }
        }
    }
}

struct ArticleCommentHeaderView: View {

    public let articleAuthorName: String
    public let authorName: String
    public let authorTitle: String?
    public let authorCompany: String?
    public let publicationDate: Date
    
    private let articleCommentsStyle: ArticleCommentsStyle = ArticleCommentsStyle()
    
    var body: some View {
        HStack() {
            if authorName == articleAuthorName {
                Text(
                    authorName
                ).font(
                    Font.system(
                        size: articleCommentsStyle.authorNameFontSize,
                        weight: articleCommentsStyle.authorNameFontWeight,
                        design: articleCommentsStyle.authorNameFontDesign
                    )
                ).background(articleCommentsStyle.articleAuthorCommentBackgroundColor)
                
            } else {
                Text(
                    authorName
                ).font(
                    Font.system(
                        size: articleCommentsStyle.authorNameFontSize,
                        weight: articleCommentsStyle.authorNameFontWeight,
                        design: articleCommentsStyle.authorNameFontDesign
                    )
                )
            }
            Spacer()
            AttributedPostPublicationDate(
                publicationDate: DateRepresentation(
                    date: publicationDate
                ).get(
                    localization: .ukrainian
                )
            )
        }.padding(
            EdgeInsets(
                top: 10,
                leading: 0,
                bottom: -4,
                trailing: 0
            )
        )
        HStack {
            if authorTitle != nil {
                if authorCompany != nil {
                    Text(
                        authorTitle!
                    ).font(
                        Font.system(
                            size: articleCommentsStyle.authorTitleFontSize,
                            weight: articleCommentsStyle.authorTitleFontWeight,
                            design: articleCommentsStyle.authorTitleFontDesign
                        )
                    ).foregroundColor(
                        articleCommentsStyle.authorTitleFontColor
                    ) +
                    Text(
                        " в \(authorCompany!)"
                    ).font(
                        Font.system(
                            size: articleCommentsStyle.authorCompanyFontSize,
                            weight: articleCommentsStyle.authorCompanyFontWeight,
                            design: articleCommentsStyle.authorCompanyFontDesign
                        )
                    ).foregroundColor(
                        articleCommentsStyle.authorCompanyFontColor
                    )
                }
                
                if authorCompany == nil {
                    Text(
                        authorTitle!
                    ).font(
                        Font.system(
                            size: articleCommentsStyle.authorTitleFontSize,
                            weight: articleCommentsStyle.authorTitleFontWeight,
                            design: articleCommentsStyle.authorTitleFontDesign
                        )
                    ).foregroundColor(
                        articleCommentsStyle.authorTitleFontColor
                    )
                }
            }
        }.padding(.bottom, -1.5)
    }
}

struct ArticleCommentsItselfView: View {
    
    public let articleAuthorName: String
    public var articleComments: [ArticleComment] = [ArticleComment]()
    private let articleCommentsStyle: ArticleCommentsStyle = ArticleCommentsStyle()
    
    var body: some View {
        ForEach(articleComments, id: \.id) { articleComment in
            if articleComment.uiView != nil {
                VStack(alignment: .leading) {
                    ArticleCommentHeaderView(
                        articleAuthorName: articleAuthorName,
                        authorName: articleComment.authorName!,
                        authorTitle: articleComment.authorTitle,
                        authorCompany: articleComment.authorCompany,
                        publicationDate: articleComment.publicationDate!
                    )
                    PostTextView(
                        uiView: articleComment.uiView!
                    ).frame(
                        height: articleComment.uiViewHeigth!
                    )
                    Divider()
                }.padding(
                    EdgeInsets(
                        top: 0,
                        leading: 20 + (15 * articleComment.level),
                        bottom: 0,
                        trailing: 20
                    )
                )
            }
        }
    }
}

struct ArticleCommentsView: View {

    public let article: Article

    @State public var isActivityIndicatorLoaing: Bool = true
    @State private var articleComments: [ArticleComment] = [ArticleComment]()
    @State private var articleBestComments: [ArticleComment] = [ArticleComment]()
    @State private var articleCommentsNumber: Int = 0

    private let articleCommentsStyle: ArticleCommentsStyle = ArticleCommentsStyle()
    
    var body: some View {
        Group {
            if isActivityIndicatorLoaing {
                ActivityIndicator(isLoading: $isActivityIndicatorLoaing)
            } else {
                ScrollView {
                    if !articleBestComments.isEmpty {
                        Text(
                            "Найкращі коментарі"
                        ).font(
                            Font.system(
                                size: articleCommentsStyle.articleBestCommentsTitleFontSize,
                                weight: articleCommentsStyle.articleBestCommentsTitleFontWeight,
                                design: articleCommentsStyle.articleBestCommentsTitleFontDesign
                            )
                        ).frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        ).padding(
                            .leading, 20
                        )
                        Divider()
                        ArticleCommentsItselfView(
                            articleAuthorName: article.authorName,
                            articleComments: articleBestComments
                        )
                    }

                    if !articleComments.isEmpty {
                        Text(
                            "\(articleCommentsNumber) коментар(ів)"
                        ).font(
                            Font.system(
                                size: articleCommentsStyle.articleCommentsNumberFontSize,
                                weight: articleCommentsStyle.articleCommentsNumberFontWeight,
                                design: articleCommentsStyle.articleCommentsNumberFontDesign
                            )
                        ).frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        ).padding(
                            EdgeInsets(
                                top: articleBestComments.isEmpty ? 0 : 24,
                                leading: 20,
                                bottom: 0,
                                trailing: 0
                            )
                        )
                        Divider()
                        ArticleCommentsItselfView(
                            articleAuthorName: article.authorName,
                            articleComments: articleComments
                        )
                    }
                }.navigationBarTitle(
                    "Комментарі"
                ).padding(
                    .top, 12
                )
            }
        }.onAppear {
            Html(url: article.url).get() { html in
                guard let html = html else {
                    return
                }

                let articleCommentsHtmlParser: ArticleCommentsHtmlParser = ArticleCommentsHtmlParser(
                    html: html,
                    rootTag: "commentsList",
                    identifier: .id
                )
                
                let articleBestCommentsHtmlParser: ArticleCommentsHtmlParser = ArticleCommentsHtmlParser(
                    html: html,
                    rootTag: "b-comments __best",
                    identifier: .class_
                )

                let articleComments: ArticleComments = ArticleComments(htmlParser: articleCommentsHtmlParser)
                let articleBestComments: ArticleComments = ArticleComments(htmlParser: articleBestCommentsHtmlParser)

                self.articleComments = articleComments.get()
                self.articleBestComments = articleBestComments.get()
                self.articleCommentsNumber = self.articleComments.count
                self.isActivityIndicatorLoaing = false
            }
        }
    }
}
