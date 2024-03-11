import SwiftUI

struct ContentView: View {
    @StateObject private var settingsViewModel = SettingsViewModel()
    @State private var isShowingSettings = false
    @State private var selectedFolder: URL?

    var body: some View {
        VStack {
            HStack {
                Button("Copy Images") {
                    copyImages()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Configure Folders") {
                    isShowingSettings = true
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .sheet(isPresented: $isShowingSettings) {
                    SettingsView(settingsViewModel: settingsViewModel, isShowingSettings: $isShowingSettings)
                }
            }
            .padding()

            if let imageList = settingsViewModel.imageList {
                List(imageList, id: \.self) { imageName in
                    Text(imageName)
                }
                .padding()
            } else {
                Text("No images available.")
                    .padding()
            }
        }
    }

    private func copyImages() {
        let sourceFolder = URL(fileURLWithPath: settingsViewModel.sourceFolder)
        let destinationFolder = URL(fileURLWithPath: settingsViewModel.destinationFolder)

        let fileManager = FileManager.default

        // Move file copying operations to a background thread
        DispatchQueue.global(qos: .background).async {
            do {
                let sdCardContents = try fileManager.contentsOfDirectory(atPath: sourceFolder.path)

                for file in sdCardContents {
                    let sdCardFilePath = sourceFolder.appendingPathComponent(file)
                    do {
                        let destinationFilePath = destinationFolder.appendingPathComponent(file)
                        print("Destination file path: \(destinationFilePath)")
                        
                        if !fileManager.fileExists(atPath: destinationFilePath.path) {
                            try fileManager.copyItem(at: sdCardFilePath, to: destinationFilePath)
                            print("File \(file) copied successfully.")
                        } else {
                            print("File \(file) already exists in the destination folder.")
                        }
                    } catch {
                        print("Error copying file \(file): \(error.localizedDescription)")
                    }
                }
            } catch {
                print("Error copying images: \(error.localizedDescription)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
