import XCTest
@testable import CPU6502Core

final class OpSTYTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = PlainMemory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testSTYZeroPage() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x84, 0x10])
        self.cpu.Y = 0xEF
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 3)
        XCTAssertEqual(actualCycle, 3)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.memory[0x0010], 0xEF)
    }
    
    func testSTYZeroPageY() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x94, 0x10])
        self.memory.setBytes(start: 0x0010, bytes: [0xAB, 0xCD])
        self.cpu.PC = 0x0000
        self.cpu.Y = 0xEF
        self.cpu.X = 0
        var actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.memory[0x0010], 0xEF)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 0xED
        self.cpu.X = 1
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.memory[0x0011], 0xED)
        
        self.memory.setBytes(start: 0x0000, bytes: [0x94, 0xFF])
        self.cpu.PC = 0x0000
        self.cpu.Y = 0xEC
        self.cpu.X = 0x11
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.memory[0x0010], 0xEC)
    }
    
    func testSTYAbsolute() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x8C, 0xCD, 0xAB])
        self.cpu.PC = 0x0000
        self.cpu.Y = 0xEF
        let actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.memory[0xABCD], 0xEF)
    }
    
    
}
