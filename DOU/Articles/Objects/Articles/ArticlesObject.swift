import Foundation
import Atributika

struct Articles: Decodable {

  let count: Int
  let next: String
  let previous: Optional<String>
  let results: [Article]
  
  enum CodingKeys: String, CodingKey {
    case count = "count"
    case next = "next"
    case previous = "previous"
    case results = "results"
  }
}
