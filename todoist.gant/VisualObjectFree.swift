//
//  VisualObjectFree.swift
//  todoist.gant
//
//  Created by Aleksey Groylov on 21.05.2020.
//  Copyright © 2020 Aleksey Groylov. All rights reserved.
//
//  Класс, используемый для получения деревовидной структуры любых
//  объектов соответствующих протоколу
//  VisualPerfomanceObjectProtocol

import Foundation

/// Структура визуального представления объекта
struct VisualPerfomanceObject {
    var name: String
}

/// Протокол наличия функции представления у объекта класса
protocol VisualPerfomanceObjectProtocol: AnyObject {
    func perfomanceObjec() -> VisualPerfomanceObject
}

/// Структура для хранения визуального отображения проекта и задачи
struct VisualObjectFreeStruct<T: VisualPerfomanceObjectProtocol> {
    // сортировка
    var order: Int
    // уровень сдвига от основания дерева хранения
    var depth: Int
    weak var object: T?
}

/// Структура формирования дерева отображения проектов и задач
struct VisualObjectFree <T: VisualPerfomanceObjectProtocol> {
    
    // массив хранения
    //private (set)
    private (set) var visibleArray: [VisualObjectFreeStruct<T>] = []
    
    /// Пустой инициализатор
    init () {}
    
    init (object: T) {
        let newObjectFree = VisualObjectFreeStruct<T>(order: 0, depth: 0, object: object)
        visibleArray.append(newObjectFree)
    }
    
    mutating func incObjectDepth(inc: Int) {
        visibleArray.forEach {
            $0.depth += inc
        }
    }
    
    mutating func incObjectOrder(inc: Int) {
        visibleArray.forEach {
            $0.order += inc
        }
    }
    
    mutating func addArray(add: VisualObjectFree<T>) {
        let inc = visibleArray.count
        var newAdd = add
        newAdd.incObjectOrder(inc: inc)
        visibleArray = visibleArray + newAdd.visibleArray
    }
    
    mutating func addObjectBegin(add: T, depth: Int) {
        self.incObjectOrder(inc: 1)
        let newFreeStruct = VisualObjectFreeStruct<T>(order: 0, depth: depth, object: add)
        visibleArray.insert(newFreeStruct, at: 0)
    }
    
    mutating func addObjectEnd(add: T, depth: Int) {
        let newFreeStruct = VisualObjectFreeStruct<T>(order: visibleArray.count, depth: depth, object: add)
        visibleArray.append(newFreeStruct)
    }
    
    subscript (index: Int) -> VisualObjectFreeStruct<T> {
        return visibleArray[index]
    }
    
    func getVisualArray() -> [VisualObjectFreeStruct<T>] {
        return visibleArray
    }
}
