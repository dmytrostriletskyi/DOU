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

    var body: some View {
        Text("Publication page.")
    }
}
