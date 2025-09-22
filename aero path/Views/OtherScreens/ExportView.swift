import SwiftUI
import UniformTypeIdentifiers
import CoreLocation

struct ExportView: View {
    @State var viewModel: AeroPathViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedExportFormat: ExportFormat = .json
    @State private var showingShareSheet = false
    @State private var exportFileData: Data?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    enum ExportFormat: String, CaseIterable {
        case json = "JSON"
        case csv = "CSV"
        case pdf = "PDF"
        
        var fileExtension: String {
            switch self {
            case .json: return "json"
            case .csv: return "csv"
            case .pdf: return "pdf"
            }
        }
        
        var mimeType: String {
            switch self {
            case .json: return "application/json"
            case .csv: return "text/csv"
            case .pdf: return "application/pdf"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                headerView
                
                // Export format selection
                formatSelectionView
                
                // Export options
                exportOptionsView
                
                // Export button
                exportButton
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .navigationTitle("Export Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                if let data = exportFileData {
                    ShareSheet(activityItems: [data])
                }
            }
            .alert("Export Error", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 48))
                .foregroundColor(.blue)
            
            Text("Export Your Travel Data")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Choose a format to export your cities and travel statistics")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
    
    private var formatSelectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Export Format")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                ForEach(ExportFormat.allCases, id: \.self) { format in
                    Button(action: {
                        selectedExportFormat = format
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(format.rawValue)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text(formatDescription(for: format))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: selectedExportFormat == format ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedExportFormat == format ? .blue : .gray)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedExportFormat == format ? Color.blue.opacity(0.1) : Color(.systemGray6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedExportFormat == format ? Color.blue : Color.clear, lineWidth: 2)
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private var exportOptionsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Export Options")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                ExportOptionRow(
                    icon: "building.2.fill",
                    title: "Cities Data",
                    description: "\(viewModel.cities.count) cities",
                    isEnabled: true
                )
                
                ExportOptionRow(
                    icon: "chart.bar.fill",
                    title: "Statistics",
                    description: "Travel statistics and analytics",
                    isEnabled: true
                )
                
                ExportOptionRow(
                    icon: "photo.fill",
                    title: "Photos",
                    description: "City photos and captions",
                    isEnabled: false
                )
            }
        }
    }
    
    private var exportButton: some View {
        Button(action: exportData) {
            HStack {
                Image(systemName: "square.and.arrow.up")
                Text("Export \(selectedExportFormat.rawValue)")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue)
            )
        }
        .disabled(viewModel.cities.isEmpty)
    }
    
    private func formatDescription(for format: ExportFormat) -> String {
        switch format {
        case .json:
            return "Structured data format, easy to import"
        case .csv:
            return "Spreadsheet format, compatible with Excel"
        case .pdf:
            return "Printable report with statistics"
        }
    }
    
    private func exportData() {
        do {
            switch selectedExportFormat {
            case .json:
                exportFileData = try exportAsJSON()
            case .csv:
                exportFileData = try exportAsCSV()
            case .pdf:
                exportFileData = try exportAsPDF()
            }
            showingShareSheet = true
        } catch {
            alertMessage = error.localizedDescription
            showingAlert = true
        }
    }
    
    private func exportAsJSON() throws -> Data {
        let exportData = ExportData(
            cities: viewModel.cities,
            statistics: viewModel.travelStats,
            exportDate: Date()
        )
        return try JSONEncoder().encode(exportData)
    }
    
    private func exportAsCSV() throws -> Data {
        var csvString = "Name,Country,Latitude,Longitude,Visit Date,Rating,Notes,Is Favorite\n"
        
        for city in viewModel.cities {
            let row = [
                city.name,
                city.country,
                String(city.coordinate.latitude),
                String(city.coordinate.longitude),
                city.visitDate.formatted(.iso8601.dateSeparator(.dash)),
                String(city.rating),
                city.notes.replacingOccurrences(of: ",", with: ";"),
                city.isFavorite ? "Yes" : "No"
            ].joined(separator: ",")
            csvString += row + "\n"
        }
        
        return csvString.data(using: .utf8) ?? Data()
    }
    
    private func exportAsPDF() throws -> Data {
        // Simple PDF generation - in a real app, you'd use a proper PDF library
        let pdfString = """
        AeroPath Travel Report
        Generated: \(Date().formatted())
        
        Total Cities: \(viewModel.travelStats.totalCities)
        Total Countries: \(viewModel.travelStats.totalCountries)
        Average Rating: \(String(format: "%.1f", viewModel.travelStats.averageRating))
        Total Distance: \(String(format: "%.0f km", viewModel.travelStats.totalDistance))
        
        Cities:
        \(viewModel.cities.map { "• \($0.name), \($0.country) (\($0.rating) stars)" }.joined(separator: "\n"))
        """
        
        return pdfString.data(using: .utf8) ?? Data()
    }
}

struct ExportData: Codable {
    let cities: [City]
    let statistics: TravelStats
    let exportDate: Date
}

struct ExportOptionRow: View {
    let icon: String
    let title: String
    let description: String
    let isEnabled: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(isEnabled ? .blue : .gray)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(isEnabled ? .primary : .gray)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if !isEnabled {
                Text("Coming Soon")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.orange.opacity(0.2))
                    )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isEnabled ? Color(.systemGray6) : Color(.systemGray5))
        )
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ExportView(viewModel: AeroPathViewModel())
        .preferredColorScheme(.dark)
}
