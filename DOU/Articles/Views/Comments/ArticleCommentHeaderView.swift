import Foundation
import SwiftUI

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
