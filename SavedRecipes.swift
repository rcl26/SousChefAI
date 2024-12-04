import SwiftUI

struct SavedRecipesView: View {
    @State private var savedRecipes: [String] = ["Spaghetti Carbonara", "Chicken Salad", "Vegetarian Stir Fry"] // Placeholder
    
    var body: some View {
        VStack {
            Text("Saved Recipes")
                .font(.title2)
                .padding()
            
            List(savedRecipes, id: \.self) { recipe in
                Text(recipe)
            }
        }
        .navigationTitle("Saved Recipes")
    }
}
