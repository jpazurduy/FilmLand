//
//  DetailMoviewView.swift
//  FilmLand
//
//  Created by Jorge Azurduy on 2/10/25.
//

import SwiftUI

struct DetailMoviewView: View {
    var movie: Movie
    
    @ViewBuilder
    private func loadImage(movie: Movie) -> some View {
        AsyncImage(url: URL(string: Path.baseURLProd + (movie.posterPath ?? ""))) { image in
            image
                .resizable()
                .scaledToFit()
                .cornerRadius(8)
                .clipShape(.rect)
        } placeholder: {
            ProgressView()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        //.frame(width: 350, height: 450, alignment: .center)
    }
    
    var body: some View {
        VStack {
            
            loadImage(movie: movie)
            
            Text(movie.title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.blue)
            
            Text(movie.overview)
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: 150, alignment: .center)
                .padding(.horizontal, 10)
            
            HStack {
                Text(getYear(releaseDate: movie.releaseDate))
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text("Rate: \(movie.voteCount)")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .padding(.horizontal, 10)
            
            Spacer()
            
        }
    }
    
    private func getYear(releaseDate: String) -> String {
        return "Year: \(releaseDate[..<releaseDate.index(releaseDate.startIndex, offsetBy: 4)])"
    }
}

//#Preview {
//    DetailMoviewView()
//}
