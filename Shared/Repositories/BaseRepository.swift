//
//  BaseRepository.swift
//  QuizApp
//
//  Created by Aleksandar Geyman on 17.01.22.
//

import Foundation
import Combine

class BaseRepository {
    
    func fetch(url: URL) -> AnyPublisher<Data, Error> {
        URLSession.DataTaskPublisher(request: URLRequest(url: url), session: .shared)
            .tryMap { data, _ in
                return data
            }
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }
    
    func fetch<T: Decodable>(url: URL) -> AnyPublisher<T, Error> {
        fetch(url: url)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError {error in
                return error
            }
            .eraseToAnyPublisher()
    }
}
