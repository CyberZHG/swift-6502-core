import XCTest
@testable import CPU6502Core

final class OpSHSTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testSHSAbsoluteY() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x9B, 0xCD, 0xAB])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAB
        self.cpu.X = 0xCD
        self.cpu.Y = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.SP, 0x89)
        XCTAssertEqual(self.memory[0xABCE], 0x88)
    }
    
}
