import XCTest
@testable import CPU6502Core

final class OpLSRTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testLSRAccumulator() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x4A])
        self.cpu.PC = 0x0000
        self.cpu.A = 0b00110010
        var actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.A, 0b00011001)
        XCTAssertEqual(self.cpu.P, 0b00110100)
        
        self.cpu.PC = 0x0000
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.A, 0b00001100)
        XCTAssertEqual(self.cpu.P, 0b00110101)
        
        self.cpu.PC = 0x0000
        self.cpu.A = 0x01
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.A, 0x00)
        XCTAssertEqual(self.cpu.P, 0b00110111)
    }
    
    func testLSRZeroPage() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x46, 0x02, 0b00110010])
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.P, 0b00110100)
        XCTAssertEqual(self.memory[0x0002], 0b00011001)
    }
    
    func testLSRZeroPageX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x56, 0x10])
        self.memory.setBytes(start: 0x0010, bytes: [0xAB, 0b00011001])
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.P, 0b00110101)
        XCTAssertEqual(self.memory[0x0011], 0b00001100)
    }
    
    func testLSRAbsolute() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x4E, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0b00011001])
        self.cpu.PC = 0x0000
        self.cpu.X = 0
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.P, 0b00110101)
        XCTAssertEqual(self.memory[0xABCD], 0b00001100)
    }
    
    func testLSRAbsoluteX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x5E, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0x00])
        self.memory.setBytes(start: 0xAC2D, bytes: [0xFA])
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 7)
        XCTAssertEqual(actualCycle, 7)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.P, 0b00110110)
        XCTAssertEqual(self.memory[0xABCE], 0x00)
    }
    
}
