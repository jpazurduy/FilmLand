//
//  MoviesViewModel.swift
//  FilmLand
//
//  Created by Jorge Azurduy on 2/9/25.
//

import SwiftUI

@MainActor
class MoviesViewModel: ObservableObject {
    
    @Published private(set) var movies: [Movie] = []
    
    private var httpService: HttpService?
    
    init(httpService: HttpService) {
        self.movies = []
        self.httpService = httpService
    }
    
    func searchMovie(using name: String) async {
        let movie = Path.search + Path.movie
        
        do {
            let result = try await httpService?.sendRequest(text: name, path: movie, parameters: "", page: "1")
            DispatchQueue.main.async { [weak self ] in
                self?.movies = result?.results ?? []
            }
        } catch(let error) {
            print(error.localizedDescription)
        }
        
        
    }
}
