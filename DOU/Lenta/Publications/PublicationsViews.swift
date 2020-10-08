import Foundation
import SwiftUI

struct PublicationsView: View {
    
    @ObservedObject var publicationsService: PublicationsService = PublicationsService()
    
    private let tabBarStyle: TabBarStyle = TabBarStyle()
    
    var body: some View {
        NavigationView() {
            List(
                publicationsService.publications
            ) { (publication: Publication) in
                NavigationLink(
                    destination: PublicationView(
                        publication: publication
//                        url: "https://dou.ua/lenta/articles/it-infrastructure-in-fast-growing-company/"
                    )
                ) {
                    PublicationsItemView(
                        publication: publication
                    ).onAppear {
                        publicationsService.fetchNext(
                            currentPublication: publication
                        )
                    }
                 }
            }.navigationBarTitle(
                tabBarStyle.forumTabNameUkrainian,
                displayMode: .inline
            )
        }
    }
}

struct PublicationsItemView: View {
    
    let publication: Publication

    var body: some View {
        VStack(alignment: .leading) {
            PostTitle(title: publication.title)
            HStack(spacing: 15) {
                PostAuthorName(authorName: publication.authorName)
                PostPublicationDate(
                    publicationDate: DateRepresentation(
                        date: publication.publicationDate
                    ).get(
                        localization: .ukrainian
                    )
                )
                PostViews(views: publication.views)
            }
            .padding(
                .vertical, 1
            )
        }.padding(
            .vertical, 10
        )
    }
}

struct PublicationView: View {
    
    let publication: Publication
    
//    let url: String
    
    @State private var htmlStrings: [HtmlString] = [HtmlString]()
    
    var body: some View {
        ScrollView {
            Group {
                ForEach(htmlStrings, id: \.id) { htmlString in
                    if htmlString.type == HtmlStringType.text {
                        PostTextView(uiView: htmlString.uiView).frame(height: htmlString.uiViewHeigth)
                    }
                    
                    if htmlString.type == HtmlStringType.image {
                        PostImageView(uiView: htmlString.uiView).frame(height: htmlString.uiViewHeigth)
                    }
                }
            }.onAppear {
                Html(url: publication.url).get() { html in
                    guard let html = html else {
                        return
                    }
                    
                    let htmlParser: HtmlParser = HtmlParser(html: html, rootTag: "article")
                    
                    guard let htmlString: [HtmlString] = htmlParser.parse() else {
                        return
                    }
                    
                    self.htmlStrings = htmlString
                }
            }
        }
    }
}
