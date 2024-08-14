//
//  EditView.swift
//  BucketList
//
//  Created by Aaron Graves on 8/13/24.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = ViewModel(location: .example)

    var onSave: (Location) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                Section("Nearby") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                /*ToolbarItem(placement: .topBarLeading) {
                    Button("Delete", role: .destructive) {
                        
                    }
                    .foregroundColor(.red)
                    //.fontWeight(.bold)
                }*/
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        onSave(viewModel.saveNewLocation(name: viewModel.name, description: viewModel.description))
                        dismiss()
                    }
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
        .presentationDragIndicator(.visible)
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.onSave = onSave
        _viewModel = State(initialValue: ViewModel(location: location))
    }
    

}

#Preview {
    EditView(location: .example) { _ in }
}
