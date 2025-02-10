//
//  ContentView.swift
//  FilmLand
//
//  Created by Jorge Azurduy on 2/9/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
        
    @State private var searchText = ""
    
    @StateObject var viewModel: MoviesViewModel = MoviesViewModel(httpService: HttpService())
    
    
    @ViewBuilder
    func buildListCell(movie: Movie) -> some View {
        HStack {
            AsyncImage(url: URL(string: Path.baseURLProd + (movie.posterPath ?? ""))) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .border(Color.white, width: 6)
                    .cornerRadius(8)
                    .clipShape(.rect)
            } placeholder: {
                ProgressView()
            }
            .padding(.leading, 20)
            .padding(.vertical, 10)
            .frame(width: 150, height: 200, alignment: .center)
            
            
            VStack(alignment: .leading, spacing: 10) {
                Text(movie.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
                
                Text(movie.releaseDate)
                    .font(.footnote)
                    .fontWeight(.light)
            }
            .padding(.leading, 30)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
        .padding(.leading, -10)
    }
    
    var body: some View {
                    
        ZStack {
            VStack {
                NavigationStack {
                    SearchBarView(text: $searchText, viewModel: viewModel)
                        .padding()
                    
                    if isEmptyText() {
                        Spacer()
                        VStack {
                            Image(systemName: "movieclapper")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100, alignment: .center)
                            
                            Text("Start Reviewing details about \nyour favourite movies.")
                                .font(.headline)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                    } else {
                        List(viewModel.movies, id: \.self) { movie in
                            NavigationLink {
                                DetailMoviewView(movie: movie)
                            } label: {
                                buildListCell(movie: movie)
                                    .background(.mint)
                                    .cornerRadius(10)
                                    .shadow(color: .gray, radius: 2, x: 5, y: 5)
                            }
                            
                            .buttonStyle(.borderless)
                        }
                        .listRowSeparator(.hidden)
                        .listStyle(.plain)
                        .padding(.horizontal, -10)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .background(.red)
    }
    
    private func isEmptyText() -> Bool {
        if searchText == "" {
            return true
        } else {
            return false
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
