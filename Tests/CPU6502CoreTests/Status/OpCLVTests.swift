import XCTest
@testable import CPU6502Core

final class OpCLVTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = PlainMemory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testCLVImplied() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xB8])
        self.cpu.PC = 0x0000
        self.cpu.V = true
        let actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.P, 0b00110110)
        XCTAssertEqual(self.cpu.V, false)
    }
    
}
