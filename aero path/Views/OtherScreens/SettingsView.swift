import SwiftUI
import UserNotifications
import WebKit

struct SettingsView: View {
    @State var viewModel: AeroPathViewModel
    @StateObject private var notificationManager = NotificationManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showingExportView = false
    @State private var showingAboutView = false
    
    var body: some View {
        NavigationView {
            List {
                // Notifications Section
                Section("Notifications") {
                    Toggle("Enable Notifications", isOn: $notificationManager.isAuthorized)
                        .onChange(of: notificationManager.isAuthorized) { _, newValue in
                            if newValue {
                                notificationManager.requestPermission()
                            }
                        }
                    
                    if notificationManager.isAuthorized {
                        NavigationLink("Notification Settings") {
                            NotificationSettingsView()
                        }
                    }
                }
                
                // Data Section
                Section("Data") {
                    Button("Export Data") {
                        showingExportView = true
                    }
                    .foregroundColor(.blue)
                    
                    Button("Import Data") {
                        // TODO: Implement import
                    }
                    .foregroundColor(.blue)
                    
                    Button("Clear All Data") {
                        // TODO: Implement clear data
                    }
                    .foregroundColor(.red)
                }
                
                // App Section
                Section("App") {
                    NavigationLink("About") {
                        AboutView()
                    }
                    
                    NavigationLink("Privacy Policy") {
                        PrivacyPolicyView()
                    }
                    
                    NavigationLink("Terms of Service") {
                        TermsOfServiceView()
                    }
                }
                
                // Statistics Section
                Section("Statistics") {
                    HStack {
                        Text("Total Cities")
                        Spacer()
                        Text("\(viewModel.cities.count)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Total Countries")
                        Spacer()
                        Text("\(viewModel.travelStats.totalCountries)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Average Rating")
                        Spacer()
                        Text(String(format: "%.1f", viewModel.travelStats.averageRating))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingExportView) {
                ExportView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingAboutView) {
                AboutView()
            }
        }
    }
}

struct NotificationSettingsView: View {
    @State private var travelReminders = true
    @State private var locationNotifications = true
    @State private var weeklyStats = true
    @State private var reminderDays = 7
    
    var body: some View {
        List {
            Section("Travel Reminders") {
                Toggle("Enable Travel Reminders", isOn: $travelReminders)
                
                if travelReminders {
                    VStack(alignment: .leading) {
                        Text("Remind me \(reminderDays) days before travel")
                        Slider(value: Binding(
                            get: { Double(reminderDays) },
                            set: { reminderDays = Int($0) }
                        ), in: 1...30, step: 1)
                    }
                }
            }
            
            Section("Location Notifications") {
                Toggle("Welcome Messages", isOn: $locationNotifications)
                Text("Get notified when you arrive at a city")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section("Weekly Updates") {
                Toggle("Weekly Statistics", isOn: $weeklyStats)
                Text("Receive weekly travel statistics")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // App Icon
                Image(systemName: "airplane.departure")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                VStack(spacing: 8) {
                    Text("AeroPath")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Version 1.0.0")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("About AeroPath")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("AeroPath is your personal travel companion that helps you track and remember all the amazing places you've visited. Create your own travel map, add photos, and keep detailed notes about each destination.")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text("Features:")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        FeatureRow(icon: "map", text: "Interactive travel map")
                        FeatureRow(icon: "photo", text: "Photo gallery for each city")
                        FeatureRow(icon: "chart.bar", text: "Detailed travel statistics")
                        FeatureRow(icon: "heart", text: "Favorite cities collection")
                        FeatureRow(icon: "square.and.arrow.up", text: "Export your data")
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(text)
                .font(.body)
        }
    }
}


struct TermsOfServiceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Terms of Service")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Last updated: \(Date().formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("By using AeroPath, you agree to these terms and conditions.")
                    .font(.body)
                
                Text("Acceptable Use")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("• Use the app for personal travel tracking only\n• Do not share inappropriate content\n• Respect the privacy of others\n• Do not attempt to reverse engineer the app")
                    .font(.body)
                
                Text("Limitations")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("• The app is provided 'as is' without warranties\n• We are not responsible for data loss\n• Features may change without notice\n• Service may be discontinued at any time")
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle("Terms of Service")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsView(viewModel: AeroPathViewModel())
        .preferredColorScheme(.dark)
}
