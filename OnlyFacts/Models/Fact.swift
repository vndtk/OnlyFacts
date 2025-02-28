//
//  Fact.swift
//  OnlyFacts
//
//  Created by Vlady Schmidt on 2/23/25.
//

struct Fact: Codable, Identifiable, Hashable {
    let id: String
    let content: String
    let icon: String
    let category: String
    let likes: Int
    let dislikes: Int
    let image: String?
    let author: String? // author id
}
