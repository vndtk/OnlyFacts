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
    let author: String
    let image: String?
}

struct FactCategory: Codable, Identifiable, Hashable {
    let id: String
    let name: String
}
