//
//  Bundle+Extension.swift
//  SinglePointDemoApp
//
//  Created by GOUTHAM on 26/11/24.
//

import Foundation
import Combine

extension Bundle {
    
    // get the data from the local json file
    func readFile(file: String) -> AnyPublisher<Data, Error> {
            self.url(forResource: file, withExtension: nil)
                .publisher
                .tryMap{ string in
                    guard let data = try? Data(contentsOf: string) else {
                        fatalError("Failed to load \(file) from bundle.")
                    }
                    return data
                }
                .mapError { error in
                    return error
                }.eraseToAnyPublisher()
        }
    
    // Decode the model with local file using combine
    func decodeable<T: Decodable>(fileName: String) -> AnyPublisher<T, Error> {
            readFile(file: fileName)
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError { error in
                    return error
                }
                .eraseToAnyPublisher()
            
        }
}
