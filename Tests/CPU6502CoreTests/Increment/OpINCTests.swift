import XCTest
@testable import CPU6502Core

final class OpINCTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = PlainMemory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testINCZeroPage() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xE6, 0x00])
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 3)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.P, 0b10110100)
        XCTAssertEqual(self.memory[0x0000], 0xE7)
    }
    
    func testINCZeroPageX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xF6, 0x10])
        self.memory.setBytes(start: 0x0010, bytes: [0xAB, 0xFF])
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.P, 0b00110110)
        XCTAssertEqual(self.memory[0x0011], 0x00)
    }
    
    func testINCAbsolute() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xEE, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0x10])
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.P, 0b00110100)
        XCTAssertEqual(self.memory[0xABCD], 0x11)
    }
    
    func testINCAbsoluteX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xFE, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0xFC])
        self.memory.setBytes(start: 0xAC2D, bytes: [0xFA])
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        var actualCycle = try self.cpu.execute(memory, maxCycle: 7)
        XCTAssertEqual(actualCycle, 7)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.P, 0b10110100)
        XCTAssertEqual(self.memory[0xABCE], 0xFD)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 0x60
        actualCycle = try self.cpu.execute(memory, maxCycle: 7)
        XCTAssertEqual(actualCycle, 7)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.P, 0b10110100)
        XCTAssertEqual(self.memory[0xAC2D], 0xFB)
    }
    
}
