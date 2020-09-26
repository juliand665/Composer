import XCTest
import ComposerTests

var tests: [XCTestCaseEntry] = []
tests += MachineTests.allTests()
XCTMain(tests)
