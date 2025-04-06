// Stage 5- Added Important Error Handling
import SwiftUI

struct APIResponse: Codable {
    let restaurants: [Restaurant]
}

struct Restaurant: Codable, Identifiable {
    var id: UUID {UUID()}
    let name: String
    let cuisines: [Cuisine]
    let rating: Rating
    let address: Address
}

struct Cuisine: Codable {
    let name: String
}

struct Rating: Codable {
    let starRating: Double
}

struct Address: Codable {
    let firstLine: String
    let city: String
    let postalCode: String

    var fullAddress: String {
        [firstLine, city, postalCode]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}



class RestaurantViewModel: ObservableObject {

    @Published var restaurants: [Restaurant] = []

    @Published var errorMessage: String?

    func fetchRestaurants(for postcode: String) {
        let Postcode = postcode.replacingOccurrences(of: " ", with: "")

        // No Postcode Input Error 
        guard !postcode.trimmingCharacters(in: .whitespaces).isEmpty else {
            DispatchQueue.main.async {
                self.errorMessage = "Please enter a postcode."
                self.restaurants = []
            }
            return
        }

        

        guard let url = URL(string: "https://uk.api.just-eat.io/discovery/uk/restaurants/enriched/bypostcode/\(Postcode)") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid postcode format."
            }
            return
        }

        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("iOSApp/1.0", forHTTPHeaderField: "User-Agent")

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load data"
                    self.restaurants = []
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let apiResponse = try decoder.decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self.restaurants = Array(apiResponse.restaurants.prefix(10))
                    self.errorMessage = nil
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode data."
                    self.restaurants = []
                }
            }
        }.resume()
    }
}





struct ContentView: View {

    @StateObject private var viewModel = RestaurantViewModel()

    @State private var postcode: String = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter Your Postcode", text: $postcode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Search") {
                        viewModel.fetchRestaurants(for: postcode)
                    }
                }
                .padding()

                // Display error message
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                List(viewModel.restaurants) { restaurant in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(restaurant.name).font(.headline)
                        Text("Cuisines: \(restaurant.cuisines.map { $0.name }.joined(separator: ", "))")
                        Text("Rating: \(restaurant.rating.starRating, specifier: "%.1f")")
                        Text("Address: \(restaurant.address.fullAddress)")
                    }
                }
            }
            .navigationTitle("Top 10 Restaurants")
        }
        .navigationViewStyle(.stack)
    }
}