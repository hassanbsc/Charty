// The Swift Programming Language
// https://docs.swift.org/swift-book
import DGCharts
import SwiftUI
import Charts


// Data Model
struct Profit: Identifiable {
    var id = UUID()
    let department: String
    let profit: Double
}

// Sample Data
let data: [Profit] = [
    Profit(department: "Production", profit: 15000),
    Profit(department: "Production\\margin", profit: 1300),
    Profit(department: "Production\\margin\\sublevel1", profit: 500),
    Profit(department: "Production\\margin\\sublevel2", profit: 800),
    Profit(department: "Marketing", profit: 8000),
    Profit(department: "Finance", profit: 10000)
]

// Main Chart View
public struct DrillDownChartView: View {
    @State private var currentDepartment: String? = nil // Track the current department level
    
    public var body: some View {
        VStack {
            Text(currentDepartment ?? "All Departments")
                .font(.title)
                .padding()
            
            Chart(filteredData) { profit in
                BarMark(
                    x: .value("Department", profit.department.components(separatedBy: "\\").last ?? profit.department),
                    y: .value("Profit", profit.profit)
                )
                .foregroundStyle(by: .value("Department", profit.department))
//                .onTapGesture {
//                    // Drill down into the selected department
//                    if hasSublevels(profit.department) {
//                        currentDepartment = profit.department
//                    }
//                }
            }
            .chartXSelection(value: $currentDepartment)
            .frame(height: 300)
            .padding()
            
            // Back button to navigate to the previous level
            if currentDepartment != nil {
                Button("Back") {
                    if let current = currentDepartment {
                        // Go back to the parent level
                        let components = current.components(separatedBy: "\\")
                        if components.count > 1 {
                            currentDepartment = components.dropLast().joined(separator: "\\")
                        } else {
                            currentDepartment = nil // Go back to the top level
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    // Filter data based on the current department level
    private var filteredData: [Profit] {
        if let currentDepartment = currentDepartment {
            // Filter data to include only sublevels of the current department
            return data.filter { $0.department.hasPrefix(currentDepartment + "\\") || $0.department == currentDepartment }
        } else {
            // Show top-level departments
            return data.filter { !$0.department.contains("\\") }
        }
    }
    
    // Check if a department has sublevels
    private func hasSublevels(_ department: String) -> Bool {
        return data.contains { $0.department.hasPrefix(department + "\\") }
    }
}

// Preview
struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        DrillDownChartView()
    }
}
