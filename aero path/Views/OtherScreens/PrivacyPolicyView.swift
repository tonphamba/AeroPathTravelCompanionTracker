import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Privacy Policy")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.aeroPrimary)
                        
                        Text("Last updated: September 20, 2024")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 10)
                    
                    // Quick Summary
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Quick Summary")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.aeroAccent)
                        
                        Text("AeroPath is designed with privacy in mind. We don't collect personal data, don't track you, and your travel data stays on your device.")
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.aeroPrimary.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.aeroPrimary.opacity(0.3), lineWidth: 1)
                                    )
                            )
                    }
                    
                    // Section 1
                    policySection(
                        title: "1. Information We Collect",
                        content: "AeroPath is a local-first application that prioritizes your privacy:",
                        items: [
                            "Travel Data: Cities you've visited, photos, notes, and ratings are stored locally on your device",
                            "Location Data: Coordinates of cities you add are stored locally and not transmitted to our servers",
                            "Device Information: Basic app usage statistics (anonymized) to improve app performance"
                        ]
                    )
                    
                    // Section 2
                    policySection(
                        title: "2. How We Use Your Information",
                        content: "Your data is used exclusively for:",
                        items: [
                            "Providing the core functionality of the travel tracking app",
                            "Displaying your personal travel map and statistics",
                            "Improving app performance and user experience",
                            "Generating local analytics and insights about your travels"
                        ]
                    )
                    
                    // Section 3
                    policySection(
                        title: "3. Data Storage and Security",
                        content: "All your travel data is stored locally on your device using iOS's secure storage mechanisms:",
                        items: [
                            "City information and coordinates",
                            "Photos and notes",
                            "Travel statistics and analytics",
                            "App preferences and settings"
                        ]
                    )
                    
                    // Section 4
                    policySection(
                        title: "4. Third-Party Services",
                        content: "AeroPath may use the following third-party services:",
                        items: [
                            "MapKit: For displaying maps and location services (Apple's privacy policy applies)",
                            "PhotosUI: For accessing your photo library (with your permission)",
                            "Core Location: For location-based features (with your permission)"
                        ]
                    )
                    
                    // Section 5
                    policySection(
                        title: "5. Your Rights and Choices",
                        content: "You have complete control over your data:",
                        items: [
                            "Access: View all your data within the app",
                            "Export: Export your travel data in JSON, CSV, or PDF formats",
                            "Delete: Delete individual cities or all data at any time",
                            "Modify: Edit or update your travel information"
                        ]
                    )
                    
                    // Section 6
                    policySection(
                        title: "6. Data Sharing",
                        content: "We do not share your personal data with third parties. Your travel information:",
                        items: [
                            "Remains on your device unless you choose to export it",
                            "Is not sold to advertisers or data brokers",
                            "Is not used for marketing purposes",
                            "Is not transmitted to our servers"
                        ]
                    )
                    
                    // Section 7
                    policySection(
                        title: "7. Children's Privacy",
                        content: "AeroPath is not intended for children under 13. We do not knowingly collect personal information from children under 13. If you are a parent or guardian and believe your child has provided us with personal information, please contact us.",
                        items: []
                    )
                    
                    // Section 8
                    policySection(
                        title: "8. Changes to This Privacy Policy",
                        content: "We may update this Privacy Policy from time to time. We will notify you of any changes by:",
                        items: [
                            "Posting the new Privacy Policy in the app",
                            "Updating the \"Last updated\" date at the top of this policy",
                            "Providing in-app notification of significant changes"
                        ]
                    )
                    
                    // Section 9
                    VStack(alignment: .leading, spacing: 12) {
                        Text("9. Contact Information")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.aeroPrimary)
                        
                        Text("If you have any questions about this Privacy Policy or our privacy practices, please contact us:")
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            contactItem(title: "Email", value: "privacy@aeropath.app")
                            contactItem(title: "Website", value: "https://aeropath.app")
                            contactItem(title: "Support", value: "Available through the app's settings menu")
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.aeroLightTertiary.opacity(0.5))
                        )
                    }
                    
                    // Section 10
                    policySection(
                        title: "10. Compliance",
                        content: "This Privacy Policy complies with:",
                        items: [
                            "Apple's App Store Review Guidelines",
                            "iOS Privacy Requirements",
                            "General Data Protection Regulation (GDPR) principles",
                            "California Consumer Privacy Act (CCPA) requirements"
                        ]
                    )
                    
                    // Final Note
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Privacy Matters")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.aeroSuccess)
                        
                        Text("We built AeroPath with privacy as a core principle. Your travel memories are personal, and we believe they should stay that way.")
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.aeroSuccess.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.aeroSuccess.opacity(0.3), lineWidth: 1)
                                    )
                            )
                    }
                }
                .padding()
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func policySection(title: String, content: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.aeroPrimary)
            
            Text(content)
                .font(.body)
                .foregroundColor(.primary)
            
            if !items.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(items, id: \.self) { item in
                        HStack(alignment: .top, spacing: 8) {
                            Text("•")
                                .foregroundColor(.aeroAccent)
                                .fontWeight(.bold)
                            
                            Text(item)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding(.leading, 8)
            }
        }
    }
    
    private func contactItem(title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(title + ":")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.aeroPrimary)
            
            Text(value)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}