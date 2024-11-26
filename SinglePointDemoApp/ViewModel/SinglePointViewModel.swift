//
//  SinglePointViewModel.swift
//  SinglePointDemoApp
//
//  Created by GOUTHAM on 25/11/24.
//

import Foundation
import Combine

protocol DataProvider {
    func decodeable<T: Decodable>(fileName: String) -> AnyPublisher<T, Error>
}

class BundleDataProvider: DataProvider {
    func decodeable<T: Decodable>(fileName: String) -> AnyPublisher<T, Error> {
        // Actual implementation
        Bundle.main.decodeable(fileName: fileName)
    }
}

class SinglePointViewModel: ObservableObject {
    @Published var singlePointList: [SinglePointModel] = []
    private var disposables = Set<AnyCancellable>()
    private let dataProvider: DataProvider
    
    init(dataProvider: DataProvider = BundleDataProvider()) {
        self.dataProvider = dataProvider
    }
    
    func fetchSinglePointDetails() {
        dataProvider.decodeable(fileName: "sample.json")
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.singlePointList = []
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] response in
                self?.singlePointList = response
        }).store(in: &disposables)
    }
}

