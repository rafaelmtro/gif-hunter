import TokamakDOM
import JavaScriptKit

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
    
    let backendURL = "http://localhost:8000"
    
    func fetchTrending() {
        isLoading = true
        let jsFetch = JSObject.global.fetch.function!
        let url = "\(backendURL)/gifs/trending"
        
        _ = jsFetch(url).then { response -> JSValue in
            return response.object!.json!().object!
        }.then { data -> JSValue in
            self.parseGifs(from: data)
            self.isLoading = false
            return JSValue.undefined
        }.catch { error -> JSValue in
            print("Error fetching trending: \(error)")
            self.isLoading = false
            return JSValue.undefined
        }
    }
    
    func searchGifs() {
        guard !searchQuery.isEmpty else { return }
        isLoading = true
        let jsFetch = JSObject.global.fetch.function!
        let url = "\(backendURL)/gifs/search?q=\(searchQuery)"
        
        _ = jsFetch(url).then { response -> JSValue in
            return response.object!.json!().object!
        }.then { data -> JSValue in
            self.parseGifs(from: data)
            self.isLoading = false
            return JSValue.undefined
        }.catch { error -> JSValue in
            print("Error searching: \(error)")
            self.isLoading = false
            return JSValue.undefined
        }
    }
    
    private func parseGifs(from data: JSValue) {
        // Assuming data is { data: [ { id: "...", images: { fixed_height: { url: "..." } } } ] }
        var fetchedGifs: [Gif] = []
        if let dataArray = data["data"].array {
            for item in dataArray {
                if let id = item["id"].string,
                   let images = item["images"].object,
                   let fixedHeight = images["fixed_height"].object,
                   let url = fixedHeight["url"].string {
                    fetchedGifs.append(Gif(id: id, url: url))
                }
            }
        }
        DispatchQueue.main.async {
            self.gifs = fetchedGifs
        }
    }
}
