import Foundation

struct SoftwareEngineeringSalary {
    var city: String
    var jobPosition: String
    var workingExperience: Float64
    var salary: Int64
    var programmingLanguage: String
}

struct QualityAssuranceSalary {
    var city: String
    var jobPosition: String
    var workingExperience: Float64
    var salary: Int64
    var specialization: String
}

struct ManagementSalary {
    var city: String
    var jobPosition: String
    var workingExperience: Float64
    var salary: Int64
}

struct OtherSalary {
    var city: String
    var jobPosition: String
    var workingExperience: Float64
    var salary: Int64
}

struct Salaries {
    var cities: [String]

    var softwareEngineeringSalaries: [SoftwareEngineeringSalary]
    var qualityAssuranceSalaries: [QualityAssuranceSalary]
    var managementSalaries: [ManagementSalary]
    var otherSalaries: [OtherSalary]

    var softwareEngineeringJobsPositions: [String]
    var qualityAssuranceJobsPositions: [String]
    var managementJobsPositions: [String]
    var otherJobsPositions: [String]

    var softwareEngineeringProgrammingLanguages: [String]
    var qualityAssuranceSpesializations: [String]
}
