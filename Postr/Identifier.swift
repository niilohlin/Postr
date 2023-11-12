import Foundation

struct Identifier<Identee, Value: Hashable & Decodable>: Hashable {
    let rawValue: Value
}

extension Identifier: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        rawValue = try container.decode(Value.self)
    }
}
