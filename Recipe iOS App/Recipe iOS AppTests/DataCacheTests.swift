//
//  DataCacheTests.swift
//  Recipe iOS AppTests
//
//  Created by Samuel Folledo on 4/16/25.
//

import Testing
@testable import Recipe_iOS_App

struct DataCacheTests {
    @Test func testSaveAndLoad() async {
        let cache = DataCache<[String]>(directoryName: "TestCache")
        let data = ["a", "b"]
        await cache.save(data, forKey: "strings")
        let loaded = await cache.load(forKey: "strings")
        #expect(loaded == data)

        await cache.clear(forKey: "strings")
        let empty = await cache.load(forKey: "strings")
        #expect(empty == nil)
    }
}
