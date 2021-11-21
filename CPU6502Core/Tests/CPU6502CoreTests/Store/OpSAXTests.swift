import XCTest
@testable import CPU6502Core

final class OpSAXTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testSAXZeroPage() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x87, 0xAB])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAB
        self.cpu.X = 0xCD
        let actualCycle = try self.cpu.execute(memory, maxCycle: 3)
        XCTAssertEqual(actualCycle, 3)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.memory[0x00AB], 0x89)
    }
    
    func testSAXZeroPageY() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x97, 0xAB])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAB
        self.cpu.X = 0xCD
        self.cpu.Y = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.memory[0x00AC], 0x89)
    }
    
    func testSAXAbsolute() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x8F, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAB
        self.cpu.X = 0xCD
        let actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.memory[0xABCD], 0x89)
    }
    
    func testSAXIndexedIndirect() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x83, 0x40])
        self.memory.setBytes(start: 0x0041, bytes: [0xCD, 0xAB])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAB
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.memory[0xABCD], 0x01)
    }
    
}
