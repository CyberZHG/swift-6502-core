import XCTest
@testable import CPU6502Core

final class OpRTITests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = PlainMemory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testRTIImplied() throws {
        self.memory.setBytes(start: 0x0800, bytes: [0x00])
        self.memory.setBytes(start: 0xABCD, bytes: [0x40])
        self.memory.setBytes(start: 0xFFFE, bytes: [0xCD, 0xAB])
        self.cpu.PC = 0x0800
        var actualCycle = try self.cpu.execute(memory, maxCycle: 7)
        XCTAssertEqual(actualCycle, 7)
        XCTAssertEqual(self.cpu.PC, 0xABCD)
        XCTAssertEqual(self.cpu.P, 0b00110110)
        XCTAssertEqual(self.cpu.SP, 0xFC)
        XCTAssertEqual(self.memory[0x1FF], 0x08)
        XCTAssertEqual(self.memory[0x1FE], 0x02)
        XCTAssertEqual(self.memory[0x1FD], 0b00110110)
        
        self.cpu.P = 0b11111111
        actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0802)
        XCTAssertEqual(self.cpu.P, 0b00110110)
        XCTAssertEqual(self.cpu.SP, 0xFF)
    }
}
