//
//  ToDoGantProjectTest.swift
//  todoist.gantTests
//
//  Created by Aleksey Groylov on 26.04.2020.
//  Copyright © 2020 Aleksey Groylov. All rights reserved.
//

import XCTest



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
    
    func testGetVisualProjectFree() throws {
        try projectTest.createArrayChildProject(arrayProject: [project1_1,project1_2,project1_3,project1_4])
        let returnFunc = projectTest.getVisualProjectFree()
        XCTAssertEqual(returnFunc.count(),10, "Не верное количество элеентов в массиве")
        // Первый элемент projectTest
        XCTAssertEqual(returnFunc[0].object,projectTest)
        XCTAssertEqual(returnFunc[0].depth,0)
        XCTAssertEqual(returnFunc[0].order,0)
        // Четвертый элемент project1_1_2
        XCTAssertEqual(returnFunc[3].object,project1_1_2)
        XCTAssertEqual(returnFunc[3].depth,2)
        XCTAssertEqual(returnFunc[3].order,3)
        // Шестой элемент project1_3
        XCTAssertEqual(returnFunc[5].object,project1_3)
        XCTAssertEqual(returnFunc[5].depth,1)
        XCTAssertEqual(returnFunc[5].order,5)
        // Восьмой элемент project1_3_1_1
        XCTAssertEqual(returnFunc[7].object,project1_3_1_1)
        XCTAssertEqual(returnFunc[7].depth,3)
        XCTAssertEqual(returnFunc[7].order,7)
        // Десятый элемент project1_4
        XCTAssertEqual(returnFunc[9].object,project1_4)
        XCTAssertEqual(returnFunc[9].depth,1)
        XCTAssertEqual(returnFunc[9].order,9)
        
    }
}
