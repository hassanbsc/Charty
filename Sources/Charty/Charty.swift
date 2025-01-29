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
    Profit(department: "Production", profit: 0), // Parent node, no value
    Profit(department: "Production\\margin", profit: 0), // Parent node, no value
    Profit(department: "Production\\margin\\sublevel1", profit: 500), // Leaf node
    Profit(department: "Production\\margin\\sublevel2", profit: 800), // Leaf node
    Profit(department: "Production\\margin\\sublevel2\\subsublevel1", profit: 300), // Leaf node
    Profit(department: "Marketing", profit: 8000), // Leaf node
    Profit(department: "Finance", profit: 10000) // Leaf node
]

// Main Chart View
public struct ChartView: View {
    @State private var currentDepartment: String? = nil // Track the current department level
    @State private var selectedDepartment: String? = nil // Track the selected department for drill-down
    
    public var body: some View {
        VStack {
            Text(currentDepartment ?? "All Departments")
                .font(.title)
                .padding()
            
            Chart(filteredData, id: \.department) { profit in
                BarMark(
                    x: .value("Department", profit.department.components(separatedBy: "\\").last ?? profit.department),
                    y: .value("Profit", profit.profit)
                )
                .foregroundStyle(by: .value("Department", profit.department))
            }
            .chartXSelection(value: $selectedDepartment) // Enable X-axis selection
            .onChange(of: selectedDepartment) {
                if let newSelection = selectedDepartment,
                   hasSublevels(currentDepartment == nil ? newSelection : (currentDepartment ?? "") + "\\" + newSelection) {
                    // Drill down into the selected department
                    currentDepartment = currentDepartment == nil ? newSelection : (currentDepartment ?? "") + "\\" + newSelection
                }
            }
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
                    selectedDepartment = nil // Reset selection
                }
                .padding()
            }
        }
    }
    
    // Filter data based on the current department level
    private var filteredData: [Profit] {
        if let currentDepartment = currentDepartment {
            // Filter data to include only direct sublevels of the current department
            let sublevels = data.filter { $0.department.hasPrefix(currentDepartment + "\\") && $0.department.components(separatedBy: "\\").count == currentDepartment.components(separatedBy: "\\").count + 1 }
            
            // Calculate the sum of leaf nodes for each sublevel
            return sublevels.map { sublevel in
                let leafNodes = data.filter { $0.department.hasPrefix(sublevel.department + "\\") }
                let totalProfit = leafNodes.isEmpty ? sublevel.profit : leafNodes.reduce(0) { $0 + $1.profit }
                return Profit(department: sublevel.department, profit: totalProfit)
            }
        } else {
            // Show top-level departments
            let topLevels = data.filter { !$0.department.contains("\\") }
            
            // Calculate the sum of leaf nodes for each top-level department
            return topLevels.map { topLevel in
                let leafNodes = data.filter { $0.department.hasPrefix(topLevel.department + "\\") }
                let totalProfit = leafNodes.isEmpty ? topLevel.profit : leafNodes.reduce(0) { $0 + $1.profit }
                return Profit(department: topLevel.department, profit: totalProfit)
            }
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
        ChartView()
    }
}
