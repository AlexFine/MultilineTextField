import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
	[testCase(MultilineTextFieldTests.allTests)]
}
#endif
