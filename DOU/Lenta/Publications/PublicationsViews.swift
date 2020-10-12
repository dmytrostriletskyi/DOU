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
            RegularPostTitle(title: publication.title)
            HStack(spacing: 15) {
                RegularPostAuthorName(authorName: publication.authorName)
                RegularPostPublicationDate(
                    publicationDate: DateRepresentation(
                        date: publication.publicationDate
                    ).get(
                        localization: .ukrainian
                    )
                )
                RegularPostViews(views: publication.views)
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

    @State private var htmlStrings: [HtmlString] = [HtmlString]()
    
    var body: some View {
        ScrollView {
            Group {
                VStack {
                    Text("").frame(height: 10)
                    GeometryReader { _ in
                        HStack(spacing: 15) {
                            AttributedPostAuthorName(authorName: publication.authorName)
                            AttributedPostPublicationDate(
                                publicationDate: DateRepresentation(
                                    date: publication.publicationDate
                                ).get(
                                    localization: .ukrainian
                                )
                            )
                            AttributedPostViews(views: publication.views)
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
        }.padding(.bottom, 15)
    }
}
