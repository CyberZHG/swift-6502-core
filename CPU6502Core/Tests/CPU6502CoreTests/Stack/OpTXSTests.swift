import XCTest
@testable import CPU6502Core

final class OpTXSTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testTXS() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x9A])
        self.cpu.PC = 0x0000
        self.cpu.X = 0xAB
        let actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.P, 0b00100110)
        XCTAssertEqual(self.cpu.SP, 0xFE)
        XCTAssertEqual(self.memory[0x01FF], 0xAB)
    }
}
