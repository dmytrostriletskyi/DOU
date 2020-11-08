import Foundation
import SwiftUI

struct ArticleCommentHeaderView: View {

    public let articleAuthorName: String
    public let authorName: String
    public let authorTitle: String?
    public let authorCompany: String?
    public let publicationDate: Date

    private let style: Style = Style()
    
    var body: some View {
        HStack() {
            if authorName == articleAuthorName {
                Text(
                    authorName
                ).font(
                    Font.system(
                        size: style.authorNameFontSize,
                        weight: style.authorNameFontWeight,
                        design: style.authorNameFontDesign
                    )
                ).background(style.articleAuthorCommentBackgroundColor)
                
            } else {
                Text(
                    authorName
                ).font(
                    Font.system(
                        size: style.authorNameFontSize,
                        weight: style.authorNameFontWeight,
                        design: style.authorNameFontDesign
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
                top: style.commentInformationPaddingTop,
                leading: style.commentInformationPaddingLeading,
                bottom: style.commentInformationPaddingBottom,
                trailing: style.commentInformationPaddingTrailing
            )
        )
        HStack {
            if authorTitle != nil {
                if authorCompany != nil {
                    Text(
                        authorTitle!
                    ).font(
                        Font.system(
                            size: style.authorTitleFontSize,
                            weight: style.authorTitleFontWeight,
                            design: style.authorTitleFontDesign
                        )
                    ).foregroundColor(
                        style.authorTitleFontColor
                    ) +
                    Text(
                        " в \(authorCompany!)"
                    ).font(
                        Font.system(
                            size: style.authorCompanyFontSize,
                            weight: style.authorCompanyFontWeight,
                            design: style.authorCompanyFontDesign
                        )
                    ).foregroundColor(
                        style.authorCompanyFontColor
                    )
                }
                
                if authorCompany == nil {
                    Text(
                        authorTitle!
                    ).font(
                        Font.system(
                            size: style.authorTitleFontSize,
                            weight: style.authorTitleFontWeight,
                            design: style.authorTitleFontDesign
                        )
                    ).foregroundColor(
                        style.authorTitleFontColor
                    )
                }
            }
        }.padding(
            .bottom, style.commentHeaderAuthorTitlePaddingBottom
        )
    }
    
    struct Style {
        public let authorNameFontSize: CGFloat = 16
        public let authorNameFontWeight: Font.Weight = .bold
        public let authorNameFontDesign: Font.Design = .default
        public let authorTitleFontSize: CGFloat = 12
        public let authorTitleFontWeight: Font.Weight = .regular
        public let authorTitleFontDesign: Font.Design = .default
        public let authorTitleFontColor: Color = .gray
        public let authorCompanyFontSize: CGFloat = 12
        public let authorCompanyFontWeight: Font.Weight = .regular
        public let authorCompanyFontDesign: Font.Design = .default
        public let authorCompanyFontColor: Color = .gray
        public let articleAuthorCommentBackgroundColor: Color = Color(red: 1.00, green: 0.90, blue: 0.30, opacity: 1.00)
        public let commentInformationPaddingTop: CGFloat = 10
        public let commentInformationPaddingLeading: CGFloat = 0
        public let commentInformationPaddingBottom: CGFloat = -4
        public let commentInformationPaddingTrailing: CGFloat = 0
        public let commentHeaderAuthorTitlePaddingBottom: CGFloat = -1.5
    }
}
