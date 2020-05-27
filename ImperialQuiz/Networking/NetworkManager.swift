//
//  NetworkManager.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 25/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

class NetworkManager {
    
    private let urlString = "https://imperial-quiz.herokuapp.com/game_settings"
    
    func fetchRawSectionData(handler: @escaping (Result<[RawSectionData], NetworkErrors>) -> Void ) {
        guard let url = URL(string: urlString) else { handler(.failure(.url)); return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let result = self?.convertDataToRawModel(data: data) else { return }
            DispatchQueue.main.async { handler(result) }
        }
        task.resume()
    }
    
    private func convertDataToRawModel(data: Data?) -> Result<[RawSectionData], NetworkErrors> {
        guard let data = data, data.count != 0 else { return .failure(.data) }
        guard let rawModels = try? JSONDecoder().decode([RawSectionData].self, from: data) else { return .failure(.decode) }
        return .success(rawModels)
    }
    
}
