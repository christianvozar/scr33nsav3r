//  scr33nsav3r by Alpha King of a3ther

import SwiftUI

struct ConfigureSheetView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Picker(selection: $viewModel.selectedArtist, label: Text("Artist")) {
                    Text("Lord Jazz").tag("Lord Jazz")
                    Text("Tainted").tag("Tainted")
                    Text("Ungenneant").tag("Ungenneant")
                    Text("Filth").tag("Filth")
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.top)
                
                Toggle("Include NSFW", isOn: $viewModel.includeNSFW)
                    .padding(.top)
                
                Picker(selection: $viewModel.animationSpeedIndex, label: Text("Scroll Speed")) {
                    Text("2400").tag(0)
                    Text("9600").tag(1)
                    Text("28.8k").tag(2)
                    Text("56k").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top)
            }
            .padding(.horizontal)
            
            HStack{
                Spacer()
                // Add the "OK" button
                Button(action: {
                    //controller.saveSettingsAndClose()
                    viewModel.saveSettingsAndClose()
                    //viewModel.saveSettings()
                    dismiss()
                }) {
                    Text("OK")
                }
                .keyboardShortcut(.defaultAction)
                .padding(.bottom)
            }
        }
        .padding()
    }
}

/*
 Button(action: {
 NSColorPanel.shared.close()
 NSApp.endSheet(window)
 }) {
 Text("Close Configure Sheet")
 }
 */
