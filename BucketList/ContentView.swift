//
//  ContentView.swift
//  BucketList
//
//  Created by Aaron Graves on 8/11/24.
//

import SwiftUI

extension FileManager {
    /*static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }*/
    
    private func getDocumentsDirectory() -> URL {
        let paths = self.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func encode<T: Encodable>(_ input: T, to file: String) {
        let url = getDocumentsDirectory().appendingPathComponent(file)
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(input)
            let jsonString = String(decoding: data, as: UTF8.self)
            try jsonString.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            fatalError("Failed to write to Documents \(error.localizedDescription)")
        }
    }
    
    func decode<T: Decodable>(_ type: T.Type,
                              from file: String,
                              dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                              keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) -> T {
        let url = getDocumentsDirectory().appendingPathComponent(file)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        
        do {
            let data = try Data(contentsOf: url)
            let loaded = try decoder.decode(T.self, from: data)
            return loaded
        } catch {
            fatalError("Failed to decode \(file) from directory \(error.localizedDescription)")
        }
    }
}

struct ContentView: View {
    var body: some View {
        Button("Read and Write") {
            /*let data = Data("Test Message".utf8)
            let url = URL.documentsDirectory.appending(path: "message.txt")
            
            do {
                try data.write(to: url, options: [.atomic, .completeFileProtection])
                let input = try String(contentsOf: url)
                print(input)
            } catch {
                print(error.localizedDescription)
            }*/
            FileManager.default.encode("Test Message", to: "message.txt")
            let input = FileManager.default.decode(String.self, from: "message.txt")
            print(input)
        }
    }
}

#Preview {
    ContentView()
}
