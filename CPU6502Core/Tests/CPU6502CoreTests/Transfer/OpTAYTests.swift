import XCTest
@testable import CPU6502Core

final class OpTAYTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testTAY() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xA8])
        self.cpu.PC = 0x0000
        self.cpu.Y = 0xAB
        self.cpu.A = 0x00
        var actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.P, 0b00110110)
        XCTAssertEqual(self.cpu.Y, 0x00)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 0xAB
        self.cpu.A = 0xFE
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.P, 0b10110100)
        XCTAssertEqual(self.cpu.Y, 0xFE)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 0xAB
        self.cpu.A = 0x12
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.P, 0b00110100)
        XCTAssertEqual(self.cpu.Y, 0x12)
    }
}
