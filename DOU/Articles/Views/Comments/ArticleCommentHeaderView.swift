import Foundation
import SwiftUI

struct ArticleCommentHeaderView: View {
    let articleAuthorName: String
    let authorName: String
    let authorTitle: String?
    let authorCompany: String?
    let publicationDate: Date

    private let style = Style()

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
            PostPublicationDate(
                publicationDate: DateRepresentation(
                    date: publicationDate
                ).get(
                    localization: .ukrainian
                ),
                font: style.informationFont,
                color: style.informationColor,
                size: style.informationSize
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
        let informationFont: String = "Arial"
        let informationSize: CGFloat = 13
        let informationColor = Color(
            red: 0,
            green: 0,
            blue: 0,
            opacity: 1.0
        )
        let authorNameFontSize: CGFloat = 16
        let authorNameFontWeight: Font.Weight = .bold
        let authorNameFontDesign: Font.Design = .default
        let authorTitleFontSize: CGFloat = 12
        let authorTitleFontWeight: Font.Weight = .regular
        let authorTitleFontDesign: Font.Design = .default
        let authorTitleFontColor: Color = .gray
        let authorCompanyFontSize: CGFloat = 12
        let authorCompanyFontWeight: Font.Weight = .regular
        let authorCompanyFontDesign: Font.Design = .default
        let authorCompanyFontColor: Color = .gray
        let articleAuthorCommentBackgroundColor = Color(red: 1.00, green: 0.90, blue: 0.30, opacity: 1.00)
        let commentInformationPaddingTop: CGFloat = 10
        let commentInformationPaddingLeading: CGFloat = 0
        let commentInformationPaddingBottom: CGFloat = -4
        let commentInformationPaddingTrailing: CGFloat = 0
        let commentHeaderAuthorTitlePaddingBottom: CGFloat = -1.5
    }
}
