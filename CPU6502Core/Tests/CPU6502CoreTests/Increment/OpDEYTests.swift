import XCTest
@testable import CPU6502Core

final class OpDEYTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testDEYImplied() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x88])
        self.cpu.PC = 0x0000
        self.cpu.Y = 0x05
        var actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.Y, 0x04)
        XCTAssertEqual(self.cpu.P, 0b00100100)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 0x01
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.Y, 0x00)
        XCTAssertEqual(self.cpu.P, 0b00100110)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 0x00
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.Y, 0xFF)
        XCTAssertEqual(self.cpu.P, 0b10100100)
    }
    
}
