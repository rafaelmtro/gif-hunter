import TokamakDOM
import JavaScriptKit
import Foundation

struct ContentView: View {
    @StateObject var viewModel = GifViewModel()

    var body: some View {
        VStack {
            Text("Gif Hunter")
                .font(.title)
                .foregroundColor(.orange)
            
            HStack {
                TextField("Search for GIFs", text: $viewModel.searchQuery)
                    .padding()
                
                Button("Search") {
                    viewModel.searchGifs()
                }
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
            }
            
            if viewModel.isLoading {
                Text("Loading GIFs...")
                    .foregroundColor(.white)
                    .padding()
            } else if viewModel.gifs.isEmpty {
                Text("No GIFs found. Try a different search!")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(viewModel.gifs, id: \.id) { gif in
                            GifView(url: gif.url)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.black)
        .onAppear {
            viewModel.fetchTrending()
        }
    }
}

struct GifView: View {
    let url: String
    
    var body: some View {
        HTML("img", ["src": url, "style": "width: 100%; border-radius: 8px; margin-bottom: 8px;"])
    }
}

struct Gif: Identifiable {
    let id: String
    let url: String
}

class GifViewModel: ObservableObject {
    @Published var gifs: [Gif] = []
    @Published var searchQuery: String = ""
    @Published var isLoading: Bool = false
    
    // Use relative path handled by Nginx proxy
    let apiPath = "/api"
    
    func fetchTrending() {
        isLoading = true
        let jsFetch = JSObject.global.fetch.function!
        let url = "\(apiPath)/gifs/trending"
        
        _ = jsFetch(url).then(JSClosure { args in
            let response = args[0].object!
            return response.json!()
        }).then(JSClosure { args in
            let data = args[0]
            self.parseGifs(from: data)
            Task {
                await MainActor.run {
                    self.isLoading = false
                }
            }
            return .undefined
        }).catch(JSClosure { args in
            let error = args[0]
            print("Error fetching trending: \(error)")
            Task {
                await MainActor.run {
                    self.isLoading = false
                }
            }
            return .undefined
        })
    }
    
    func searchGifs() {
        guard !searchQuery.isEmpty else { 
            fetchTrending()
            return 
        }
        isLoading = true
        let jsFetch = JSObject.global.fetch.function!
        let url = "\(apiPath)/gifs/search?q=\(searchQuery)"
        
        _ = jsFetch(url).then(JSClosure { args in
            let response = args[0].object!
            return response.json!()
        }).then(JSClosure { args in
            let data = args[0]
            self.parseGifs(from: data)
            Task {
                await MainActor.run {
                    self.isLoading = false
                }
            }
            return .undefined
        }).catch(JSClosure { args in
            let error = args[0]
            print("Error searching: \(error)")
            Task {
                await MainActor.run {
                    self.isLoading = false
                }
            }
            return .undefined
        })
    }
    
    private func parseGifs(from data: JSValue) {
        var fetchedGifs: [Gif] = []
        if let dataArray = data[dynamicMember: "data"].array {
            for item in dataArray {
                if let id = item[dynamicMember: "id"].string,
                   let images = item[dynamicMember: "images"].object,
                   let fixedHeight = images[dynamicMember: "fixed_height"].object,
                   let url = fixedHeight[dynamicMember: "url"].string {
                    fetchedGifs.append(Gif(id: id, url: url))
                }
            }
        }
        let stableGifs = fetchedGifs
        Task {
            await MainActor.run {
                self.gifs = stableGifs
            }
        }
    }
}
