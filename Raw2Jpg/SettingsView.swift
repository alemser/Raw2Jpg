import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsViewModel: SettingsViewModel
    @Binding var isShowingSettings: Bool
    @State private var isShowingSourceFolderPicker = false
    @State private var isShowingDestinationFolderPicker = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Configure Folders")) {
                    HStack {
                        Text("Source Folder:")
                        Spacer()
                        Button(action: {
                            isShowingSourceFolderPicker = true
                        }) {
                            Text("Choose Folder")
                        }
                        .fileImporter(
                            isPresented: $isShowingSourceFolderPicker,
                            allowedContentTypes: [.folder],
                            onCompletion: { result in
                                do {
                                    let selectedFolder = try result.get()
                                    settingsViewModel.sourceFolder = selectedFolder.path
                                } catch {
                                    print("Error selecting source folder: \(error.localizedDescription)")
                                }
                            }
                        )
                    }

                    HStack {
                        Text(">")
                        Text(settingsViewModel.sourceFolder)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }

                    Divider()

                    HStack {
                        Text("Destination Folder:")
                        Spacer()
                        Button(action: {
                            isShowingDestinationFolderPicker = true
                        }) {
                            Text("Choose Folder")
                        }
                        .fileImporter(
                            isPresented: $isShowingDestinationFolderPicker,
                            allowedContentTypes: [.folder],
                            onCompletion: { result in
                                do {
                                    let selectedFolder = try result.get()
                                    settingsViewModel.destinationFolder = selectedFolder.path
                                } catch {
                                    print("Error selecting destination folder: \(error.localizedDescription)")
                                }
                            }
                        )
                    }

                    HStack {
                        Text(">")
                        Text(settingsViewModel.destinationFolder)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarItems(
                trailing: Button("Save") {
                    saveSettings()
                }
            )
        }
    }

    private func saveSettings() {
        if !settingsViewModel.sourceFolder.isEmpty && !settingsViewModel.destinationFolder.isEmpty {
            UserDefaults.standard.set(settingsViewModel.sourceFolder, forKey: "SourceFolder")
            UserDefaults.standard.set(URL(fileURLWithPath: settingsViewModel.destinationFolder), forKey: "DestinationFolder")
            isShowingSettings = false // Close the SettingsView
        }
    }
}
