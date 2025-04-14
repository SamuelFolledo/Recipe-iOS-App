//
//  Recipe.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/14/25.
//

import Foundation

struct Recipe: Codable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    var name: String = ""
}
