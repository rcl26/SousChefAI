import SwiftUI
import PhotosUI

struct ContentView: View {
    var body: some View {
        TabView {
            EatOutView()
                .tabItem {
                    Image(systemName: "mappin.and.ellipse")
                    Text("Eat Out")
                }

            EatAtHomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Eat at Home")
                }

            SavedRecipesView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Saved Recipes")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
    }
}

struct EatOutView: View {
    @State private var locationPermissionGranted = false
    @State private var nearbyRestaurants: [String] = [] // Placeholder for restaurant data

    var body: some View {
        NavigationView {
            VStack {
                if locationPermissionGranted {
                    Text("Personalized Restaurant Recommendations")
                        .font(.title2)
                        .padding()

                    List(nearbyRestaurants, id: \ .self) { restaurant in
                        Text(restaurant)
                    }
                } else {
                    Text("Location access is required to suggest nearby restaurants.")
                        .multilineTextAlignment(.center)
                        .padding()

                    Button(action: {
                        requestLocationAccess()
                    }) {
                        Text("Enable Location")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                }
            }
            .navigationTitle("Eat Out")
        }
    }

    func requestLocationAccess() {
        // Mock implementation. Replace with actual location access logic.
        locationPermissionGranted = true
        // Fetch nearby restaurants based on user location here.
        nearbyRestaurants = ["Restaurant A", "Restaurant B", "Restaurant C"]
    }
}

struct EatAtHomeView: View {
    var body: some View {
        UploadGroceriesView()
    }
}

struct UploadGroceriesView: View {
    @State private var selectedImages: [UIImage] = []
    @State private var isImagePickerPresented = false
    @State private var isCameraPresented = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Upload Your Groceries")
                    .font(.title2)
                    .padding()

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(selectedImages, id: \ .self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()

                HStack(spacing: 40) {
                    Button(action: {
                        isImagePickerPresented.toggle()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.2))
                                .frame(width: 100, height: 100)

                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                        }
                    }

                    Button(action: {
                        isCameraPresented.toggle()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.2))
                                .frame(width: 100, height: 100)

                            Image(systemName: "camera")
                                .font(.largeTitle)
                                .foregroundColor(.green)
                        }
                    }
                }
                .padding()
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(images: $selectedImages)
                }
                .sheet(isPresented: $isCameraPresented) {
                    CameraView(images: $selectedImages)
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
            .navigationTitle("Upload Groceries")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("User Profile")
                    .font(.title2)
                    .padding()

                // Additional profile content can go here

            }
            .navigationTitle("Profile")
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage]

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 0 // Allow multiple selections
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                        guard let self = self else { return }
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.images.append(image)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var images: [UIImage]

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                DispatchQueue.main.async {
                    self.parent.images.append(image)
                }
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

