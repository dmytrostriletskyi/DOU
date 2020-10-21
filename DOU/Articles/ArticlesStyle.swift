import Foundation
import SwiftUI

struct ArticleCommentsStyle {
    
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
    
    public let articleBestCommentsTitleFontSize: CGFloat = 18
    public let articleBestCommentsTitleFontWeight: Font.Weight = .bold
    public let articleBestCommentsTitleFontDesign: Font.Design = .default
    
    public let articleCommentsNumberFontSize: CGFloat = 18
    public let articleCommentsNumberFontWeight: Font.Weight = .bold
    public let articleCommentsNumberFontDesign: Font.Design = .default
}
