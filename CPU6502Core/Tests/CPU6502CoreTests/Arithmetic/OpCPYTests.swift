import XCTest
@testable import CPU6502Core

final class OpCPYTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testCPYImmediate() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xC0, 0x42])
        self.cpu.PC = 0x0000
        self.cpu.Y = 0x42
        var actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.Y, 0x42)
        XCTAssertEqual(self.cpu.P, 0b00100111)
        
        self.memory.setBytes(start: 0x0000, bytes: [0xC0, 0x41])
        self.cpu.PC = 0x0000
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.P, 0b00100101)
        
        self.memory.setBytes(start: 0x0000, bytes: [0xC0, 0x43])
        self.cpu.PC = 0x0000
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.P, 0b10100100)
    }
    
    func testCPYZeroPage() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xC4, 0x00])
        self.cpu.PC = 0x0000
        self.cpu.Y = 0xAA
        let actualCycle = try self.cpu.execute(memory, maxCycle: 3)
        XCTAssertEqual(actualCycle, 3)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.P, 0b10100100)
    }
    
    func testCPYAbsolute() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xCC, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE])
        self.cpu.PC = 0x0000
        self.cpu.Y = 0xAA
        let actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.P, 0b10100100)
    }
    
}
