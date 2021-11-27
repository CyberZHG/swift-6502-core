import XCTest
@testable import CPU6502Core

final class OpDECTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = PlainMemory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testDECZeroPage() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xC6, 0x00])
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 3)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.P, 0b10110100)
        XCTAssertEqual(self.memory[0x0000], 0xC5)
    }
    
    func testDECZeroPageX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xD6, 0x10])
        self.memory.setBytes(start: 0x0010, bytes: [0xAB, 0x01])
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.P, 0b00110110)
        XCTAssertEqual(self.memory[0x0011], 0x00)
    }
    
    func testDECAbsolute() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xCE, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0x10])
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.P, 0b00110100)
        XCTAssertEqual(self.memory[0xABCD], 0x0F)
    }
    
    func testDECAbsoluteX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xDE, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0xFC])
        self.memory.setBytes(start: 0xAC2D, bytes: [0xFA])
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        var actualCycle = try self.cpu.execute(memory, maxCycle: 7)
        XCTAssertEqual(actualCycle, 7)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.P, 0b10110100)
        XCTAssertEqual(self.memory[0xABCE], 0xFB)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 0x60
        actualCycle = try self.cpu.execute(memory, maxCycle: 7)
        XCTAssertEqual(actualCycle, 7)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.P, 0b10110100)
        XCTAssertEqual(self.memory[0xAC2D], 0xF9)
    }
    
}
