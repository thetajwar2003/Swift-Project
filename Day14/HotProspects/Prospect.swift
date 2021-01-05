//
//  Prospect.swift
//  HotProspects
//
//  Created by Tajwar Rahman on 1/4/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

class Prospect: Codable, Identifiable {
    var id = UUID()
    var name = "Anonymous"
    var email = ""
    var added = Date()
    fileprivate(set) var isContacted = false
}

class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    static let saveKey = "SavedData"

    init() {
        if let data = FileManager().load(withName: Self.saveKey) {
            self.people = data
        }
        self.people = []
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(people){
             FileManager().save(encoded, withName: Self.saveKey)
        }
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
}

extension FileManager {
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save(_ userData: Data, withName name: String) {
        let url = getDocumentsDirectory().appendingPathComponent(name)
        
        do {
            try userData.write(to: url, options: .atomicWrite)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func load(withName name: String) -> [Prospect]? {
        let url = getDocumentsDirectory().appendingPathComponent(name)
        if let data = try? Data(contentsOf: url) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                return decoded
            }
        }
        return nil
    }
}
