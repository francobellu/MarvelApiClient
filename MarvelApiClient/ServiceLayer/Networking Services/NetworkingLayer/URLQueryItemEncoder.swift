import Foundation

///  Used to transform request parameters (  they are encodables ) in an array of URLQueryItem

// 1) Encode request as JsonData
// 2) Decode the JsonData as a dict of [String: HTTPParameter]
// 3) return an array of URLQueryItem
enum URLQueryItemEncoder {
	static func encode<T: Encodable>(_ encodable: T) throws -> [URLQueryItem] {
		let parametersData = try JSONEncoder().encode(encodable) // 1
		let parameters = try JSONDecoder().decode([String: HTTPParameter].self, from: parametersData) // 2
		return parameters.map { URLQueryItem(name: $0, value: $1.description) } // 3
	}
}
