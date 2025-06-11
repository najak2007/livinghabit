//
//  ClockLocation.swift
//  livinghabit
//
//  Created by 오션블루 on 6/10/25.
//

import MapKit
import Solar

struct ClockLocation: Identifiable {
    var id = UUID()
    var name: String
    var location: CLLocationCoordinate2D
    var timeZone: TimeZone

    init(name: String, location: CLLocationCoordinate2D, timeZone: TimeZone) {
        self.name = name
        self.location = location
        self.timeZone = timeZone
    }

    init(name: String, latitude: String, longitude: String, timezone: String) {
        self.name = name
        let lat = Double(latitude) ?? 0.0
        let lng = Double(longitude) ?? 0.0
        self.location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        self.timeZone = TimeZone(identifier: timezone) ?? TimeZone.current
    }

    var asString: String {
        "\(id)|\(name)|\(location.latitude)|\(location.longitude)|\(String(describing: timeZone.identifier))"
    }

    func timeZoneAbbreviation(on date: Date) -> String {
        timeZone.abbreviation(for: date) ?? "GMT"
    }

    func stringTimeInLocalTimeZone(_ time: Date) -> String {
        let tzFormatter = DateFormatter()
        tzFormatter.timeZone = timeZone
        tzFormatter.dateStyle = .none
        tzFormatter.timeStyle = .short
        return tzFormatter.string(from: time)
    }

    func sunRiseOn(_ date: Date) -> Date? {
        let solar = Solar(for: date, coordinate: location)
        return solar?.sunrise
    }

    func sunSetOn(_ date: Date) -> Date? {
        let solar = Solar(for: date, coordinate: location)
        return solar?.sunset
    }

    func isDaytime(at date: Date) -> Bool {
        guard let solar = Solar(for: date, coordinate: location) else {
            return false
        }
        return solar.isDaytime
    }

    func timeDifferenceString(_ date: Date, to remoteTz: TimeZone) -> String {
        guard let diff = timeDifference(date, to: remoteTz) else {
            return ""
        }

        let dcFormatter = DateComponentsFormatter()
        dcFormatter.allowedUnits = [.hour, .minute]
        let timeString = dcFormatter.string(from: diff) ?? ""
        if diff.hour ?? 0 > 0 {
            return "+\(timeString)"
        } else {
            return timeString
        }
    }

    func timeDifference(_ date: Date, to remoteTz: TimeZone) -> DateComponents? {
        let localComponents = Calendar.current.dateComponents(in: timeZone, from: date)
        let remoteComponents = Calendar.current.dateComponents(in: remoteTz, from: date)

        guard
            let localHour = localComponents.hour,
            let localMinute = localComponents.minute,
            let localSecond = localComponents.second,
            let localDay = localComponents.day,
            let localMonth = localComponents.month,
            let localYear = localComponents.year,
            let remoteHour = remoteComponents.hour,
            let remoteMinute = remoteComponents.minute,
            let remoteSecond = remoteComponents.second,
            let remoteDay = remoteComponents.day,
            let remoteMonth = remoteComponents.month,
            let remoteYear = remoteComponents.year
        else {
            return nil
        }

        let localCompareDate = DateComponents(
            calendar: Calendar.current,
            year: localYear,
            month: localMonth,
            day: localDay,
            hour: localHour,
            minute: localMinute,
            second: localSecond)
        
        let remoteCompareDate = DateComponents(
            calendar: Calendar.current,
            year: remoteYear,
            month: remoteMonth,
            day: remoteDay,
            hour: remoteHour,
            minute: remoteMinute,
            second: remoteSecond)

        let difference = Calendar.current.dateComponents(
            [.hour, .minute, .day],
            from: localCompareDate,
            to: remoteCompareDate)

        return difference
    }

    static var locationChicago: ClockLocation {
        ClockLocation(
            name: "Chicago, IL",
            latitude: "41.8781",
            longitude: "-87.6298",
            timezone: "America/Chicago")
    }

    static var locationSanFrancisco: ClockLocation {
        ClockLocation(
            name: "San Francisco, CA",
            latitude: "37.779379",
            longitude: "-122.418433",
            timezone: "America/Los_Angeles")
    }
    
    static var locationSeoul: ClockLocation {
        ClockLocation(
            name: "Seoul, KR",
            latitude: "37.5665",
            longitude: "126.9780",
            timezone: "Asia/Seoul")
    }
}

extension ClockLocation: Equatable {
    static func == (lhs: ClockLocation, rhs: ClockLocation) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.location.latitude == rhs.location.latitude
            && lhs.location.longitude == rhs.location.longitude && lhs.timeZone == rhs.timeZone
    }
}
