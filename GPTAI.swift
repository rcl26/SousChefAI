import SwiftUI

struct GPTAIView: View {
    @State private var recipes: [String] = [] // Placeholder for GPT-generated recipes
    
    var body: some View {
        VStack {
            Text("Meal Inspiration")
                .font(.title2)
                .padding()
            
            if recipes.isEmpty {
                Text("No recipes generated yet. Upload groceries to get started!")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(recipes, id: \.self) { recipe in
                    Text(recipe)
                }
            }
        }
        .navigationTitle("AI Recipes")
    }
}
