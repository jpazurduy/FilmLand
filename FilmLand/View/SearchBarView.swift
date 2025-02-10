//
//  SearchBarView.swift
//  FilmLand
//
//  Created by Jorge Azurduy on 2/9/25.
//

import SwiftUI

import SwiftUI

struct SearchBarView: View {
    
    @Binding var text: String

    @State private var isEditing = false
    
    @ObservedObject var viewModel: MoviesViewModel

    var body: some View {
        HStack {

            TextField("", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .keyboardType(.default)
                .submitLabel(.search)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing {
                            Button {
                                self.text = ""
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
                .onChange(of: text, { oldValue, newValue in
                    Task {
                        await viewModel.searchMovie(using: newValue)
                    }
                })
                .onSubmit {
                    isEditing = false
                    Task {
                        await viewModel.searchMovie(using: text)
                    }
                }
        }
    }
    
    private func isEditingSearch() -> Bool {
        return self.isEditing
    }
}

#Preview {
    SearchBarView(text: .constant(""), viewModel: MoviesViewModel(httpService: HttpService()))
}
