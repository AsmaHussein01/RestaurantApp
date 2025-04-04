// Stage 1- Using dummy data for restauruant information
import SwiftUI

struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
    let rating: Double
    let type: String
}


// REPLACE WITH FETCHRESTAURANTDATA FUNCTION
let restaurants = [
    Restaurant(name: "Restaurant 1", rating: 1, type: "Type1"),
    Restaurant(name: "Restaurant 2", rating: 2, type: "Type2"),
    Restaurant(name: "Restaurant 3", rating: 3, type: "Type3"),
    Restaurant(name: "Restaurant 4", rating: 4, type: "Type4"),
    Restaurant(name: "Restaurant 5", rating: 5, type: "Type5"),
    Restaurant(name: "Restaurant 6", rating: 1.1, type: "Type6"),
    Restaurant(name: "Restaurant 7", rating: 2.2, type: "Type7"),
    Restaurant(name: "Restaurant 8", rating: 3.3, type: "Type8"),
    Restaurant(name: "Restaurant 9", rating: 4.4, type: "Type9"),
    Restaurant(name: "Restaurant 10", rating: 5.5, type: "Type10")
]


// Simple Display
struct ContentView: View {
    var body: some View {
        NavigationView {
            List(restaurants) { restaurant in
                VStack(alignment: .leading) {
                    Text(restaurant.name)
                    Text(restaurant.type)
                    Text("\(restaurant.rating, specifier: "%.1f")")
                }
            }
            .navigationTitle("Top 10 Restaurants")
        }
        .navigationViewStyle(.stack)

    }

}