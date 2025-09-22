import SwiftUI

struct FilterView: View {
    @State var viewModel: AeroPathViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Фильтр") {
                    ForEach(FilterOption.allCases, id: \.self) { option in
                        HStack {
                            Text(option.rawValue)
                            
                            Spacer()
                            
                            if viewModel.selectedFilterOption == option {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.filterOptionChanged(option)
                        }
                    }
                }
                
                Section("Сортировка") {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        HStack {
                            Text(option.rawValue)
                            
                            Spacer()
                            
                            if viewModel.selectedSortOption == option {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.sortOptionChanged(option)
                        }
                    }
                }
            }
            .navigationTitle("Фильтры и сортировка")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Применить") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    FilterView(viewModel: AeroPathViewModel())
        .preferredColorScheme(.dark)
}
