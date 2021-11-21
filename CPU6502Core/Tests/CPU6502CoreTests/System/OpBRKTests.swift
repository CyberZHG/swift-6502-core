import XCTest
@testable import CPU6502Core

final class OpBRKTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testBRKImplied() throws {
        self.memory.setBytes(start: 0x0800, bytes: [0x00])
        self.memory.setBytes(start: 0xFFFE, bytes: [0xCD, 0xAB])
        self.cpu.PC = 0x0800
        let actualCycle = try self.cpu.execute(memory, maxCycle: 7)
        XCTAssertEqual(actualCycle, 7)
        XCTAssertEqual(self.cpu.PC, 0xABCD)
        XCTAssertEqual(self.cpu.P, 0b00110110)
        XCTAssertEqual(self.cpu.SP, 0xFC)
        XCTAssertEqual(self.memory[0x1FF], 0x08)
        XCTAssertEqual(self.memory[0x1FE], 0x02)
        XCTAssertEqual(self.memory[0x1FD], 0b00110110)
    }
}
