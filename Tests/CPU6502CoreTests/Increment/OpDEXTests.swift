import XCTest
@testable import CPU6502Core

final class OpDEXTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = PlainMemory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testDEXImplied() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xCA])
        self.cpu.PC = 0x0000
        self.cpu.X = 0x05
        var actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.X, 0x04)
        XCTAssertEqual(self.cpu.P, 0b00110100)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 0x01
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.X, 0x00)
        XCTAssertEqual(self.cpu.P, 0b00110110)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 0x00
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.X, 0xFF)
        XCTAssertEqual(self.cpu.P, 0b10110100)
    }
    
}
