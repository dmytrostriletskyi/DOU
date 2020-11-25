import Foundation

import SwiftCSV

enum SalariesCsvFileKeys: String {
    case city = "Город"
    case jobPosition = "Должность"
    case workingExperience = "exp"
    case salary = "Зарплата.в.месяц"
    case programmingLanguage = "Язык.программирования"
    case specialization = "Специализация"
}

class SalariesCsvSource {
    let url: String
    private let citiesToExclude: [String] = ["Другой"]
    private let managementJobPositions: [String] = [
        "Project manager",
        "Product Manager",
        "Senior Project manager / Program Manager",
        "Director of Engineering / Program Director"
    ]

    init(url: String) {
        self.url = url
    }

    private func get(url: String) -> CSV? {
        do {
            let url = URL(string: url)!
            let csv: CSV = try CSV(url: url)

            return csv
        } catch {
            return nil
        }
    }

    func parse() -> (
        parsedSoftwareEngineeringSalaries: [SoftwareEngineeringSalary],
        parsedQualityAssuranceSalaries: [QualityAssuranceSalary],
        parsedManagementSalaries: [ManagementSalary],
        parsedOtherSalaries: [OtherSalary],
        cities: [String]
    )? {
        guard let csv: CSV = get(url: url) else {
            return nil
        }

        do {
            var cities: [String] = [String]()
            var parsedSoftwareEngineeringSalaries: [SoftwareEngineeringSalary] = [SoftwareEngineeringSalary]()
            var parsedQualityAssuranceSalaries: [QualityAssuranceSalary] = [QualityAssuranceSalary]()
            var parsedManagementSalaries: [ManagementSalary] = [ManagementSalary]()
            var parsedOtherSalaries: [OtherSalary] = [OtherSalary]()

            try csv.enumerateAsDict { salaryRaw in
                let city: String = salaryRaw[SalariesCsvFileKeys.city.rawValue]!
                let jobPosition: String = salaryRaw[SalariesCsvFileKeys.jobPosition.rawValue]!
                let workingExperience = Float64(salaryRaw[SalariesCsvFileKeys.workingExperience.rawValue]!)!
                let salary = Int64(salaryRaw[SalariesCsvFileKeys.salary.rawValue]!)!
                let programmingLanguage: String = salaryRaw[SalariesCsvFileKeys.programmingLanguage.rawValue]!
                let specialization: String = salaryRaw[SalariesCsvFileKeys.specialization.rawValue]!

                if self.citiesToExclude.contains(city) {
                    return
                }

                if !cities.contains(city) && !self.citiesToExclude.contains(city) {
                    cities.append(city)
                }

                if !programmingLanguage.isEmpty {
                    parsedSoftwareEngineeringSalaries.append(SoftwareEngineeringSalary(
                        city: city,
                        jobPosition: jobPosition,
                        workingExperience: workingExperience,
                        salary: salary,
                        programmingLanguage: programmingLanguage
                    ))
                }

                if !specialization.isEmpty {
                    parsedQualityAssuranceSalaries.append(QualityAssuranceSalary(
                        city: city,
                        jobPosition: jobPosition,
                        workingExperience: workingExperience,
                        salary: salary,
                        specialization: specialization
                    ))
                }

                if (
                    programmingLanguage.isEmpty &&
                    specialization.isEmpty &&
                    self.managementJobPositions.contains(jobPosition)
                ) {
                    parsedManagementSalaries.append(ManagementSalary(
                        city: city,
                        jobPosition: jobPosition,
                        workingExperience: workingExperience,
                        salary: salary
                    ))
                }

                if (
                    programmingLanguage.isEmpty &&
                    specialization.isEmpty &&
                    !self.managementJobPositions.contains(jobPosition)
                ) {
                    parsedOtherSalaries.append(OtherSalary(
                        city: city,
                        jobPosition: jobPosition,
                        workingExperience: workingExperience,
                        salary: salary
                    ))
                }
            }

            return (
                parsedSoftwareEngineeringSalaries,
                parsedQualityAssuranceSalaries,
                parsedManagementSalaries,
                parsedOtherSalaries,
                cities
            )
        } catch {
            return nil
        }
    }
}
