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
                Text("Loading...")
                    .foregroundColor(.white)
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(viewModel.gifs, id: \.id) { gif in
                        GifView(url: gif.url)
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
        HTML("img", ["src": url, "style": "width: 100%; border-radius: 8px;"])
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
    
    let backendURL = "http://backend:8000"
    
    func fetchTrending() {
        isLoading = true
        let jsFetch = JSObject.global.fetch.function!
        let url = "\(backendURL)/gifs/trending"
        
        _ = jsFetch(url).then(JSClosure { response in
            return response.json!()
        }).then(JSClosure { data in
            self.parseGifs(from: data)
            DispatchQueue.main.async {
                self.isLoading = false
            }
            return .undefined
        }).catch(JSClosure { error in
            print("Error fetching trending: \(error)")
            DispatchQueue.main.async {
                self.isLoading = false
            }
            return .undefined
        })
    }
    
    func searchGifs() {
        guard !searchQuery.isEmpty else { return }
        isLoading = true
        let jsFetch = JSObject.global.fetch.function!
        let url = "\(backendURL)/gifs/search?q=\(searchQuery)"
        
        _ = jsFetch(url).then(JSClosure { response in
            return response.json!()
        }).then(JSClosure { data in
            self.parseGifs(from: data)
            DispatchQueue.main.async {
                self.isLoading = false
            }
            return .undefined
        }).catch(JSClosure { error in
            print("Error searching: \(error)")
            DispatchQueue.main.async {
                self.isLoading = false
            }
            return .undefined
        })
    }
    
    private func parseGifs(from data: JSValue) {
        // Assuming data is { data: [ { id: "...", images: { fixed_height: { url: "..." } } } ] }
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
        DispatchQueue.main.async {
            self.gifs = fetchedGifs
        }
    }
}
