import Foundation

class URL_ {
    func getOneFromText(text: String) -> URL? {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))

            for match in matches {
                guard let range = Range(match.range, in: text) else {
                    continue
                }

                let urlAsString = String(text[range])
                return URL(string: urlAsString)!
            }
        } catch {
            return nil
        }

        return nil
    }
}
