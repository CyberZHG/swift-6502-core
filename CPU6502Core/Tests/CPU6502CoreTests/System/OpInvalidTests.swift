import XCTest
@testable import CPU6502Core

final class OpInvalidTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testInvalidCode() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xB2])
        self.cpu.PC = 0x0000
        XCTAssertThrowsError(try self.cpu.execute(memory, maxCycle: 2)) { error in
            XCTAssertEqual(error as! EmulateError, EmulateError.invalidOpCode)
        }
    }
}
