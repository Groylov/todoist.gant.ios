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
/// - Todo: Сделать правильную структуру представления для проектов и задач
struct VisualPerfomanceObject {
    var name: String
}

/// Протокол наличия функции представления у объекта класса
/// Классы с данным протоколом возможно использовать для получения дерева представления **VisualObjectFree**
protocol VisualPerfomanceObjectProtocol: AnyObject {
    func perfomanceObjec() -> VisualPerfomanceObject
}

/// Структура для хранения визуального отображения проекта и задачи с соблюдением сортировки
/// и сдвига от родительских проектов
struct VisualObjectFreeStruct<T: VisualPerfomanceObjectProtocol> {
    /// сортировка
    var order: Int
    /// уровень сдвига от основания дерева хранения
    var depth: Int
    /// объект хранения
    weak var object: T?
}

/// Структура формирования дерева отображения проектов и задач
struct VisualObjectFree <T: VisualPerfomanceObjectProtocol> {
    
    /// массив хранения
    private (set) var visibleArray: [VisualObjectFreeStruct<T>] = []
    
    /// Пустой инициализатор
    init () {}
    
    /// Инициализатор на основание объекта возвращаемого класса
    /// - Parameter object: Первый объект возвращаемого класса
    init (object: T) {
        let newObjectFree = VisualObjectFreeStruct<T>(order: 0, depth: 0, object: object)
        visibleArray.append(newObjectFree)
    }
    
    /// Изменение сдвига всех объектов, хранящихся в структуре
    /// - Parameter inc: Шаг изменения сдвига
    mutating func incObjectDepth(inc: Int) {
        visibleArray.forEach {
            $0.depth += inc
        }
    }
    
    /// Изменение сортировки всех объектов хранящихся в структуре
    /// - Parameter inc: Шаг изменения сортировки
    mutating func incObjectOrder(inc: Int) {
        visibleArray.forEach {
            $0.order += inc
        }
    }
    
    /// Функция добавления структуры дерева в текущую структуру
    /// - Parameter add: Структура хранения дерева с тем же шаблонным класом
    /// - Note: Передаваемая структура добавляется в конец текущего списка
    mutating func addArray(add: VisualObjectFree<T>) {
        let inc = visibleArray.count
        var newAdd = add
        newAdd.incObjectOrder(inc: inc)
        visibleArray = visibleArray + newAdd.visibleArray
    }
    
    /// Функция добавления шаблонного объекта в начало всего списка
    /// - Parameters:
    ///   - add: добавляемый объект шаблонного типа
    ///   - depth: сдвиг от основания дерева нового объекта
    mutating func addObjectBegin(add: T, depth: Int) {
        self.incObjectOrder(inc: 1)
        let newFreeStruct = VisualObjectFreeStruct<T>(order: 0, depth: depth, object: add)
        visibleArray.insert(newFreeStruct, at: 0)
    }
    
    /// Функция добавления шаблонного объекта в конец всего списка
    /// - Parameters:
    ///   - add: добавляемый объект шаблонного типа
    ///   - depth: сдвиг от основания дерева нового объекта
    mutating func addObjectEnd(add: T, depth: Int) {
        let newFreeStruct = VisualObjectFreeStruct<T>(order: visibleArray.count, depth: depth, object: add)
        visibleArray.append(newFreeStruct)
    }
        
    subscript (index: Int) -> VisualObjectFreeStruct<T> {
        return visibleArray[index]
    }
    
    /// Функция получения количества элементов в массиве объектов отображения
    /// - Returns: Количество элементов
    func count() -> Int {
        return visibleArray.count
    }
}
