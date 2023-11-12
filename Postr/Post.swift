import Foundation

struct Post: Decodable, Identifiable {
    let userId: Identifier<User, Int>
    let id: Identifier<Post, Int>
    let title: String
    let body: String
}
