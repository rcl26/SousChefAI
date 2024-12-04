import SwiftUI

struct BiteAIView: View {
    @State private var selectedImages: [UIImage] = []
    @State private var isImagePickerPresented = false
    
    var body: some View {
        VStack {
            Text("Upload Your Groceries")
                .font(.title2)
                .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(selectedImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            
            Button(action: {
                isImagePickerPresented.toggle()
            }) {
                Text("Select Images")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            .sheet(isPresented: $isImagePickerPresented) {
             //   ImagePicker(images: $selectedImages) // You need to implement this.
            }
            
            NavigationLink(destination: GPTAIView()) {
                Text("Analyze with Bite AI")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .navigationTitle("Bite AI")
    }
}
