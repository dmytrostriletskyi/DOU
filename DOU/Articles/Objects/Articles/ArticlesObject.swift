import Foundation

import Atributika

struct Articles: Decodable {
  let count: Int
  let next: String
  let previous: String?
  let results: [Article]

  enum CodingKeys: String, CodingKey {
    case count
    case next
    case previous
    case results
  }
}
