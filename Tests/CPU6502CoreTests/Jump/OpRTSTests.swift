import XCTest
@testable import CPU6502Core

final class OpRTSTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = PlainMemory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testJSRAndRTS() throws {
        self.memory.setBytes(start: 0x0080, bytes: [0x60])
        self.memory.setBytes(start: 0x0800, bytes: [0x20, 0x80, 0x00, 0xA9, 0x10])
        self.cpu.PC = 0x0800
        var actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0080)
        XCTAssertEqual(self.cpu.P, 0b00110110)
        XCTAssertEqual(self.cpu.SP, 0xFD)
        XCTAssertEqual(self.memory[0x01FE], 0x02)
        XCTAssertEqual(self.memory[0x01FF], 0x08)
        
        actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0803)
        XCTAssertEqual(self.cpu.P, 0b00110110)
        XCTAssertEqual(self.cpu.SP, 0xFF)
        
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0805)
        XCTAssertEqual(self.cpu.P, 0b00110100)
        XCTAssertEqual(self.cpu.A, 0x10)
    }

}
