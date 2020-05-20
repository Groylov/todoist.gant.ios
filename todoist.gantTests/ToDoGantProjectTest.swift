//
//  ToDoGantProjectTest.swift
//  todoist.gantTests
//
//  Created by Aleksey Groylov on 26.04.2020.
//  Copyright © 2020 Aleksey Groylov. All rights reserved.
//

import XCTest


class VisualObjectFreeTest: XCTestCase {
    // TODO: Переделать тестирование под вариативный вариант класса
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
    }
    
    func testInitObject() throws {
        let project = ToDoGantProject(id: 1, name: "Project 1", color: 39)
        let visualProject = VisualObjectFree<ToDoGantProject>(object: project)
        XCTAssertEqual(visualProject.visibleArray[0].depth, 0, "Не совпадает глубина дерева")
        XCTAssertEqual(visualProject.visibleArray[0].order, 0, "Не совпадает сортировка")
        XCTAssertEqual(visualProject.visibleArray[0].object, project, "Не совпадает проект")
    }
    
    func testAddArray() throws {
        let project1 = ToDoGantProject(id: 1, name: "Project 1", color: 39)
        let project2 = ToDoGantProject(id: 2, name: "Project 2", color: 39)
        var visualProject1 = VisualObjectFree<ToDoGantProject>(object: project1)
        let visualProject2 = VisualObjectFree<ToDoGantProject>(object: project2)
        visualProject1.addArray(add: visualProject2)
        XCTAssertEqual(visualProject1.visibleArray.count, 2, "Не совпадает количество проектов")
        XCTAssertEqual(visualProject1.visibleArray[0].order, 0,"Не совпадает сортировка")
        XCTAssertEqual(visualProject1.visibleArray[1].order, 1,"Не совпадает сортировка")
    }
    
    func testAddObjectBegin() throws {
        let project1 = ToDoGantProject(id: 1, name: "Project 1", color: 39)
        let project2 = ToDoGantProject(id: 2, name: "Project 2", color: 39)
        var visualProject1 = VisualObjectFree<ToDoGantProject>(object: project1)
        visualProject1.addObjectBegin(add: project2, depth: 0)
        XCTAssertEqual(visualProject1.visibleArray.count, 2,"Не совпадает количество проектов")
        XCTAssertEqual(visualProject1.visibleArray[0].order, 0, "Не совпадает сортировка")
        XCTAssertEqual(visualProject1.visibleArray[1].order, 1, "Не совпадает сортировка")
        XCTAssertEqual(visualProject1.visibleArray[0].object, project2, "Не совпадают проекты")
    }
    
    func testAddObjectEnd() throws {
        let project1 = ToDoGantProject(id: 1, name: "Project 1", color: 39)
        let project2 = ToDoGantProject(id: 2, name: "Project 2", color: 39)
        var visualProject1 = VisualObjectFree<ToDoGantProject>(object: project1)
        visualProject1.addObjectEnd(add: project2, depth: 0)
        XCTAssertEqual(visualProject1.visibleArray.count, 2)
        XCTAssertEqual(visualProject1.visibleArray[0].order, 0)
        XCTAssertEqual(visualProject1.visibleArray[1].order, 1)
        XCTAssertEqual(visualProject1.visibleArray[0].object, project1)
    }
    
    func testIncObjectDepth() throws {
        let project1 = ToDoGantProject(id: 1, name: "Project 1", color: 39)
        let project2 = ToDoGantProject(id: 2, name: "Project 2", color: 39)
        var visualProject1 = VisualObjectFree<ToDoGantProject>(object: project1)
        visualProject1.addObjectEnd(add: project2, depth: 0)
        visualProject1.incObjectDepth(inc: 1)
        XCTAssertEqual(visualProject1.visibleArray[0].depth, 1)
        XCTAssertEqual(visualProject1.visibleArray[1].depth, 1)
        XCTAssertEqual(visualProject1.visibleArray[0].object, project1)
        XCTAssertEqual(visualProject1.visibleArray[1].object, project2)
    }
    
    func testIncObjectOrder() throws {
        let project1 = ToDoGantProject(id: 1, name: "Project 1", color: 39)
        let project2 = ToDoGantProject(id: 2, name: "Project 2", color: 39)
        var visualProject1 = VisualObjectFree(object: project1)
        visualProject1.addObjectEnd(add: project2, depth: 0)
        visualProject1.incObjectOrder(inc: 1)
        XCTAssertEqual(visualProject1.visibleArray[0].order, 1)
        XCTAssertEqual(visualProject1.visibleArray[1].order, 2)
        XCTAssertEqual(visualProject1.visibleArray[0].object, project1)
        XCTAssertEqual(visualProject1.visibleArray[1].object, project2)
    }
    
    func testSubscript() throws {
        let project1 = ToDoGantProject(id: 1, name: "Project 1", color: 39)
        let project2 = ToDoGantProject(id: 2, name: "Project 2", color: 39)
        var visualProject1 = VisualObjectFree<ToDoGantProject>(object: project1)
        visualProject1.addObjectEnd(add: project2, depth: 0)
        let readProject1 = visualProject1[0]
        let readProject2 = visualProject1[1]
        XCTAssertEqual(readProject1.object, project1)
        XCTAssertEqual(readProject2.object, project2)
    }
    
    func testGetVisualArray() throws {
        let project1 = ToDoGantProject(id: 1, name: "Project 1", color: 39)
        let project2 = ToDoGantProject(id: 2, name: "Project 2", color: 39)
        var visualProject1 = VisualObjectFree<ToDoGantProject>(object: project1)
        visualProject1.addObjectEnd(add: project2, depth: 0)
        let visualArray = visualProject1.getVisualArray()
        XCTAssertEqual(visualArray.count, 2, "Не верное количество элементов в массиве")
        let readProject1 = visualArray[0].object ?? nil
        let readProject2 = visualArray[1].object ?? nil
        XCTAssertEqual(readProject1,project1, "Не верный проект в результатирующем массиве")
        XCTAssertEqual(readProject2,project2, "Не верный проект в результатирующем массиве")
    }
}

class ToDoGantProjectTest: XCTestCase {
    // Для тестирования создается структура проекта вида
    // Проект 1
    // -Проект 1_1
    // --Проект 1_1_1
    // --Проект 1_1_2
    // -Проект 1_2
    // -Проект 1_3
    // --Проект 1_3_1
    // ---Проект 1_3_1_1
    // --Проект 1_3_2
    // -Проект 1_4
    
    var projectTest: ToDoGantProject!
    
    let project1_1 = ToDoGantProject(id: 11, name: "Проект 1_1", color: 39, parent_id: 1, child_order: 1)
    let project1_2 = ToDoGantProject(id: 12, name: "Проект 1_2", color: 39, parent_id: 1, child_order: 2)
    let project1_3 = ToDoGantProject(id: 13, name: "Проект 1_3", color: 39, parent_id: 1, child_order: 3)
    let project1_4 = ToDoGantProject(id: 11, name: "Проект 1_4", color: 39, parent_id: 1, child_order: 4, is_arhive: true)
    let project1_1_1 = ToDoGantProject(id: 111, name: "Проект 1_1_1", color: 39, parent_id: 11, child_order: 1)
    let project1_1_2 = ToDoGantProject(id: 112, name: "Проект 1_1_2", color: 39, parent_id: 11, child_order: 2)
    let project1_3_1 = ToDoGantProject(id: 131, name: "Проект 1_3_1", color: 39, parent_id: 13, child_order: 1)
    let project1_3_2 = ToDoGantProject(id: 132, name: "Проект 1_3_2", color: 39, parent_id: 13, child_order: 2)
    let project1_3_1_1 = ToDoGantProject(id: 1311, name: "Проект 1_3_1_1", color: 39, parent_id: 131, child_order: 1)
    let project2 = ToDoGantProject(id: 2, name: "Проект 2", color: 39)
    
    override func setUpWithError() throws {
        projectTest = ToDoGantProject(id: 1, name: "Проект 1", color: 39, parent_id: nil, child_order: nil)
        try project1_1.createArrayChildProject(arrayProject: [project1_1_1,project1_1_2])
        try project1_3_1.addChildProject(project: project1_3_1_1)
        try project1_3.createArrayChildProject(arrayProject: [project1_3_1,project1_3_2])        
    }

    override func tearDownWithError() throws {
        projectTest = nil
    }
    // TODO: Проверить верную инициализацию переменной использования проекта в зависимости от параметров удаления и архивации

    
    func testHexStringToUIColor() throws {
        // проверка на не верный параметр
        let returnNilColor = ToDoGantProject.hexStringToUIColor(hex: nil)
        XCTAssertNil(returnNilColor)
        let returnErrorColor =
        ToDoGantProject.hexStringToUIColor(hex: "")
        XCTAssertNil(returnErrorColor)
        // проверка всего массива цветов
        for element in todoistProjectColor {
            let returnColor = ToDoGantProject.hexStringToUIColor(hex: element.value)
            XCTAssertNotNil(returnColor, String(element.key) + " не смог быть определен как UIColor")
        }
    }
    
    func testEquatable() {
        XCTAssertEqual(projectTest, projectTest)
    }
    
    func testAddChildProject() throws {
        let countBegin = projectTest.childProjects.count
        try projectTest.addChildProject(project: project1_4)
        let countEnd = projectTest.childProjects.count - countBegin
        XCTAssertEqual(countEnd, 1)
        XCTAssertThrowsError(try projectTest.addChildProject(project: project2),"Не возникло ошибки формирования дерева") { error in
            if case ToDoGantProjectError.invalidStructFreeProject = error {}
            else {
                XCTAssert(false, "Возвращен не верный тип ошибки")
            }
        }
        // проверка, что содержание массива не изменилось
        XCTAssertEqual(projectTest.childProjects.count - countBegin, countEnd)
    }
    
    func testCreateArrayChildProject() throws {
        let countBegin = projectTest.childProjects.count
        let addChildArray = [project1_1,project1_2,project1_3]
        try projectTest.createArrayChildProject(arrayProject: addChildArray)
        let countEnd = projectTest.childProjects.count - countBegin
        XCTAssertEqual(countEnd, 3)
        XCTAssertThrowsError(try projectTest.createArrayChildProject(arrayProject: [project2]),"Не возникло ошибки формирования дерева") { error in
            if case ToDoGantProjectError.invalidStructFreeProject = error {}
            else {
                XCTAssert(false, "Возвращен не верный тип ошибки")
            }
        }
        // проверка, что содержание массива не изменилось
        XCTAssertEqual(projectTest.childProjects.count - countBegin, countEnd)
    }
    
    func testSaveDataCore() throws {
        // установка у подпроекта пометки на изменение
        try projectTest.createArrayChildProject(arrayProject: [project1_1,project1_2,project1_3,project1_4])
        project1_1_2.setUseProject(use: true)
        let saveProjects = projectTest.saveDataCore()
        XCTAssertEqual(saveProjects.count,1,"Функция вернула не верное количество проектов")
        let saveProject0 = saveProjects[saveProjects.startIndex]
        XCTAssertEqual(saveProject0,project1_1_2,"Функция вернула не верный проект для сохранения")
    }
    
    func testSetUseProject() throws {
        project1_3.setUseProject(use: true)
        XCTAssertTrue(project1_3.useProject, "Не изменился параметр у самого объекта")
        XCTAssertTrue(project1_3_1.useProject, "Не изменился параметр у подчененного объекта")
        XCTAssertTrue(project1_3_2.useProject, "Не изменился параметр у подчененного объекта")
        XCTAssertTrue(project1_3_1_1.useProject, "Не изменился параметр у подчененного объекта")
        project1_4.setUseProject(use: true)
        XCTAssertFalse(project1_4.useProject, "Изменился не изменяемый параметр у объекта")
        
    }
}
