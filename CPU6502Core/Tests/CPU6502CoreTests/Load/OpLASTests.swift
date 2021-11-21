import XCTest
@testable import CPU6502Core

final class OpLASTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testLASAbsoluteY() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xBB, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0xFC])
        self.memory.setBytes(start: 0xAC2D, bytes: [0xAF])
        self.cpu.PC = 0x0000
        self.cpu.Y = 0
        var actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xFE)
        XCTAssertEqual(self.cpu.X, 0xFE)
        XCTAssertEqual(self.cpu.SP, 0xFE)
        XCTAssertEqual(self.cpu.P, 0b10110100)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 1
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xFC)
        XCTAssertEqual(self.cpu.X, 0xFC)
        XCTAssertEqual(self.cpu.SP, 0xFC)
        XCTAssertEqual(self.cpu.P, 0b10110100)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 0x60
        actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xAC)
        XCTAssertEqual(self.cpu.X, 0xAC)
        XCTAssertEqual(self.cpu.SP, 0xAC)
        XCTAssertEqual(self.cpu.P, 0b10110100)
    }
    
}
