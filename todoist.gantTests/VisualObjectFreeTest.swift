//
//  VisualObjectFreeTest.swift
//  todoist.gantTests
//
//  Created by Aleksey Groylov on 23.05.2020.
//  Copyright © 2020 Aleksey Groylov. All rights reserved.
//

import XCTest

class VisualObjectFreeTest: XCTestCase {

    let project1 = ToDoGantProject(id: 1, name: "Project 1", color: 39)
    let project2 = ToDoGantProject(id: 2, name: "Project 2", color: 39)
    var visualProject1: VisualObjectFree<ToDoGantProject>!
    var visualProject2: VisualObjectFree<ToDoGantProject>!
    
    override func setUpWithError() throws {
        visualProject1 = VisualObjectFree<ToDoGantProject>(object: project1)
    }

    override func tearDownWithError() throws {
        visualProject1 = nil
    }
    
    func testInitObject() {
        let visualProject = VisualObjectFree<ToDoGantProject>(object: project1)
        XCTAssertEqual(visualProject.visibleArray[0].depth, 0, "Не совпадает глубина дерева")
        XCTAssertEqual(visualProject.visibleArray[0].order, 0, "Не совпадает сортировка")
        XCTAssertEqual(visualProject.visibleArray[0].object, project1, "Не совпадает проект")
    }
    
    func testAddArray() {
        let visualProject2 = VisualObjectFree<ToDoGantProject>(object: project2)
        visualProject1.addArray(add: visualProject2)
        XCTAssertEqual(visualProject1.visibleArray.count, 2, "Не совпадает количество проектов")
        XCTAssertEqual(visualProject1.visibleArray[0].order, 0,"Не совпадает сортировка")
        XCTAssertEqual(visualProject1.visibleArray[1].order, 1,"Не совпадает сортировка")
    }
    
    func testAddObjectBegin() {
        visualProject1.addObjectBegin(add: project2, depth: 0)
        XCTAssertEqual(visualProject1.visibleArray.count, 2,"Не совпадает количество проектов")
        XCTAssertEqual(visualProject1.visibleArray[0].order, 0, "Не совпадает сортировка")
        XCTAssertEqual(visualProject1.visibleArray[1].order, 1, "Не совпадает сортировка")
        XCTAssertEqual(visualProject1.visibleArray[0].object, project2, "Не совпадают проекты")
    }
    
    func testAddObjectEnd() {
        visualProject1.addObjectEnd(add: project2, depth: 0)
        XCTAssertEqual(visualProject1.visibleArray.count, 2)
        XCTAssertEqual(visualProject1.visibleArray[0].order, 0)
        XCTAssertEqual(visualProject1.visibleArray[1].order, 1)
        XCTAssertEqual(visualProject1.visibleArray[0].object, project1)
    }
    
    func testIncObjectDepth() {
        visualProject1.addObjectEnd(add: project2, depth: 0)
        visualProject1.incObjectDepth(inc: 1)
        XCTAssertEqual(visualProject1.visibleArray[0].depth, 1)
        XCTAssertEqual(visualProject1.visibleArray[1].depth, 1)
        XCTAssertEqual(visualProject1.visibleArray[0].object, project1)
        XCTAssertEqual(visualProject1.visibleArray[1].object, project2)
    }
    
    func testIncObjectOrder() {
        visualProject1.addObjectEnd(add: project2, depth: 0)
        visualProject1.incObjectOrder(inc: 1)
        XCTAssertEqual(visualProject1.visibleArray[0].order, 1)
        XCTAssertEqual(visualProject1.visibleArray[1].order, 2)
        XCTAssertEqual(visualProject1.visibleArray[0].object, project1)
        XCTAssertEqual(visualProject1.visibleArray[1].object, project2)
    }
    
    func testSubscript() {
        visualProject1.addObjectEnd(add: project2, depth: 0)
        let readProject1 = visualProject1[0]
        let readProject2 = visualProject1[1]
        XCTAssertEqual(readProject1.object, project1)
        XCTAssertEqual(readProject2.object, project2)
    }
    
    func testGetVisualArray() {
        visualProject1.addObjectEnd(add: project2, depth: 0)
        let visualArray = visualProject1.visibleArray
        XCTAssertEqual(visualArray.count, 2, "Не верное количество элементов в массиве")
        let readProject1 = visualArray[0].object ?? nil
        let readProject2 = visualArray[1].object ?? nil
        XCTAssertEqual(readProject1,project1, "Не верный проект в результатирующем массиве")
        XCTAssertEqual(readProject2,project2, "Не верный проект в результатирующем массиве")
    }
    
    func testCount() {
        let countTest1 = visualProject1.count()
        visualProject1.addObjectEnd(add: project2, depth: 0)
        let countTest2 = visualProject1.count()
        XCTAssertEqual(countTest1, 1, "Не верное количество элементов в массиве")
        XCTAssertEqual(countTest2, 2, "Не верное количество элементов в массиве")
    }
}
