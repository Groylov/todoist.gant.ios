//
//  ToDoGantProject.swift
//  todoist.gant
//
//  Created by Aleksey Groylov on 26.04.2020.
//  Copyright © 2020 Aleksey Groylov. All rights reserved.
//
//  Модуль описания класса хранения структуры проектов и задач


import Foundation
import SwiftUI

/// Список ошибок класса ToDoGantProject
enum ToDoGantProjectError: Error {
    case invalidStructFreeProject(project: ToDoGantProject)
}

/// Список ошибок класса ToDoGantTask
enum ToDoGantTaskError: Error {
    
}

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

/// Расшифровка цветов для для проектов
let todoistProjectColor: [Int:String] =
    [30:"#b8255f", 31:"#db4035",32:"#ff9933",33:"#fad000",34:"#afb83b",35:"#7ecc49",36:"#299438",37:"#6accbc",38:"#158fad",39:"#14aaf5",40:"#96c3eb",41:"#4073ff",42:"#884dff",43:"#af38eb",44:"#eb96eb",45:"#e05194",46:"#ff8d85",47:"#808080",48:"#b8b8b8",49:"#ccac93"]


/// Протокол хранения проекта в системе Todoist
protocol TodoistProjectProtocol {
    /// Идентификатор проекта
    var td_id: Int {get}
    // Идентификатор проектов до Апреля 2017 года
    // var td_legacy_id: Int? {get}
    /// Наименование проекта
    var td_name: String {get}
    /// Цвет проекта
    var td_color: Int {get}
    /// Идентификатор родительского проекта
    var td_parent_id: Int? {get}
    // Идентификатор родительского проекта до Апреля 2017
    // var td_legacy_parent_id: Int? {get set}
    /// Сортировка проекта у родительского проекта
    var td_child_order: Int? {get}
    // Отметка свернуты ли подпроекты данного проета
    // var td_collapsed: Bool {get set}
    // Отметка общедоступного проекта
    // var td_shared: Bool {get set}
    // Отметка удаления проекта
    var td_is_deleted: Bool {get}
    // Отметка архивации проекта
    var td_is_archived: Bool {get}
    // Отметка является ли проект избранным
    // var td_is_favorite: Bool {get set}
    // Отметка является ли проект Входящим
    // var td_inbox_project: Bool? {get set}
    // Отметка является ли проект Входящим команды
    // var td_team_inbox: Bool? {get set}
}

/// Протокол проекта в системе Gant
protocol GantProjectProtocol {
    /// Использовать проект для работы в программе
    var useProject: Bool {get}
    /// Дата начала проекта
    var beginProject: Date? {get set}
    /// Дата окончания проекта
    var endProject: Date? {get set}
    /// Время необходимое для проекта в часах
    var durationHours: Int? {get set}
    /// Прогресс проекта
    var progressProject: Int? {get set}
    /// Проект-предшественник
    var precedingProjectId: Int? {get set}
    /// Проект-последователь
    var subsequentProjectId: Int? {get set}
    /// Цвет задач в проекте
    var colorTaskProject: UIColor? {get set}
}

/// Объединенный протокол хранения данных для программы Todoist и Gant
protocol ToDoGantProjectProtocol: TodoistProjectProtocol, GantProjectProtocol,VisualPerfomanceObjectProtocol {}

/// Основной класс хранения структуры проектов
class ToDoGantProject: ToDoGantProjectProtocol, Equatable {
    
    // Протокол программы Todoist
    let td_id: Int
    let td_name: String
    let td_color: Int
    let td_parent_id: Int?
    let td_child_order: Int?
    let td_is_deleted: Bool
    let td_is_archived: Bool
    
    // Протокол программы Гант
    var beginProject: Date?
    var endProject: Date?
    var durationHours: Int?
    var progressProject: Int?
    var precedingProjectId: Int?
    var subsequentProjectId: Int?
    var colorTaskProject: UIColor?
    private (set) var useProject: Bool = false
    
    // ссылка на родительский проект
    private (set) weak var mainProject: ToDoGantProject?
    // массив подчененных проектов
    private (set) var childProjects: [ToDoGantProject] = []
    // массив подчененных задач
    private (set) var childTask: [ToDoGantTask] = []
    // информация о необходимости сохранения данных о проекте
    private var saveData: Bool = true
    // цвет проекта из настроек
    private (set) var colorProject: UIColor = UIColor.gray
    
    /// Функция получения цвета по hex коду
    /// - Parameter hex: строка с hex кодом цвета
    /// - Returns: функция возвращает цвет в формате UIColor или nil, если был переданн не верный hex код
    static func hexStringToUIColor(hex: String?) -> UIColor? {
        if hex == nil {
            return nil
        }
        var cString: String = hex!.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return nil
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    /// Функция эквиволентности проектов
    /// - Parameters:
    ///   - left: левый проект
    ///   - right: правый проект
    /// - Returns: Истина, если проекты эдинтичны по идентификатору и наименованию
    static func == (left: ToDoGantProject, right: ToDoGantProject) -> Bool {
        return left.td_id == right.td_id && left.td_name == right.td_name
    }
    
    /// Инициализация по обязательным параметрам проекта
    /// - Parameters:
    ///   - id: идентификатор проекта
    ///   - name: имя проекта
    ///   - color: номер цвета проекта
    ///   - parent_id: идентификатор родительского проекта
    ///   - child_order: код сортировки в среде родительского проекта
    init(id: Int, name: String, color: Int, parent_id: Int? = nil, child_order: Int? = nil, is_delete: Bool = false, is_arhive: Bool = false) {
        td_id = id
        td_name = name
        td_color = color
        td_parent_id = parent_id
        td_child_order = child_order
        td_is_archived = is_arhive
        td_is_deleted = is_delete
        if td_is_archived || td_is_deleted {
            useProject = false
        }
        colorProject = ToDoGantProject.hexStringToUIColor(hex: todoistProjectColor[td_color]) ?? UIColor.gray
    }
    // TODO: При инициализации объектов подтягивать прошлую и слудующую задачу. Подумать как это реализовать в случае не инициализированности задач наследников
    
    /// Инициализация по протоколу данных о проекте
    /// - Parameter project: данные проекта из источника по протоколу
    init(project: ToDoGantProjectProtocol) {
        td_id = project.td_id
        td_name = project.td_name
        td_color = project.td_color
        td_parent_id = project.td_parent_id
        td_child_order = project.td_child_order
        td_is_deleted = project.td_is_deleted
        td_is_archived = project.td_is_archived
        beginProject = project.beginProject
        endProject = project.endProject
        durationHours = project.durationHours
        progressProject = project.progressProject
        precedingProjectId = project.precedingProjectId
        subsequentProjectId = project.subsequentProjectId
        colorTaskProject = project.colorTaskProject
        if td_is_archived || td_is_deleted {
            useProject = false
        } else {
            useProject = project.useProject
        }
        colorProject = ToDoGantProject.hexStringToUIColor(hex: todoistProjectColor[td_color]) ?? UIColor.gray
    }
    
    /// Функция проверки проектов на соответствие структуре дерева проектов. Добавляемый проект всегда должен подченятся текущему.
    /// - Parameter arrayProject: массив добавляемых проектов
    /// - Throws: если структура подчененности проектов не соблюдается возникает исключение invalidStructFreeProject
    private func checkAddChildProject(arrayProject: [ToDoGantProject]) throws {
        for element in arrayProject {
            if element.td_parent_id != self.td_id {
                throw ToDoGantProjectError.invalidStructFreeProject(project: element)
            }
        }
    }
    
    // TODO: Доработать функцию до правильного представления объекта
    func perfomanceObjec() -> VisualPerfomanceObject {
        let newPerfomance = VisualPerfomanceObject(name: self.td_name)
        return newPerfomance
    }
    
    /// Функция добавления проекта в подчененные проекты
    /// - Parameter project: добавляемый проект
    /// - Throws: если структура подчененности проектов не соблюдается возникает исключение invalidStructFreeProject
    func addChildProject(project: ToDoGantProject) throws {
        try checkAddChildProject(arrayProject: [project])
        childProjects.append(project)
        project.mainProject = self
        sortChildProjects()
    }
    
    /// Функция отчистки массива подпроектов и заполнение новым массивом
    /// - Parameter arrayProject: новый массив подпроектов
    /// - Throws: если структура подчененности проектов не соблюдается возникает исключение invalidStructFreeProject
    func createArrayChildProject(arrayProject: [ToDoGantProject]) throws {
        // проверка подчененности подпроектов
        try checkAddChildProject(arrayProject: arrayProject)
        // отчистка массива подпроекта
        deinitChildProject()
        self.childProjects = arrayProject
        arrayProject.forEach {
            $0.mainProject = self
        }
        sortChildProjects()
    }
    
    /// Функция сортировки подзадач
    private func sortChildProjects() {
        // Подпроекты сортируются по полю td_child_order, если для какого то элемента не утснаовлено значение, то он перемещается в конец списка
        childProjects = childProjects.sorted {$0.td_child_order ?? Int.max < $1.td_child_order ?? Int.max}
    }
    
    /// Функция получения списка проектов для сохранения в базе
    /// - Returns: возвращается массив проектов, которые необходимо сохранить в базу
    func saveDataCore() -> [ToDoGantProject] {
        var returnArray: [ToDoGantProject] = []
        if !saveData {
            returnArray.append(self)
            saveData = true
        }
        for element in childProjects {
            let arrayElements = element.saveDataCore()
            returnArray = returnArray + arrayElements
        }
        return returnArray
    }
    
    /// Функция изменения отметки использования проекта для работы в программе ганта
    /// - Parameter use: новое значения параметра видимости
    func setUseProject(use: Bool) {
        if use && (td_is_archived || td_is_deleted) {
            return
        }
        useProject = use
        saveData = false
        childProjects.forEach {
            $0.setUseProject(use: use)
        }
    }

    
    // TODO: протестировать функции удаления подпроектов и подзадач
    // TODO: добавить функцию возврата данных для визуального отображения с помощью структуры VisualProjectFree
    // TODO: посмотреть возможность универсальности класса VisualProjectFree для использования не только для проектов, но и для задач
    /// Отчистка проекта со всеми подчененными проектами
    func deinitChildProject() {
        for element in childProjects {
            element.deinitChildProject()
        }
        childProjects = []
        mainProject = nil
    }
    
    /// Отчистка всех подчененных задач проекта с подзадачами
    func deinitChildTask() {
        // Рпавильная отчистка подчененных задач
    }
    
    /// Обработка уничтожения проекта
    deinit {
        deinitChildProject()
        deinitChildTask()
    }
}


protocol TodoistTaskProtocol {}
protocol GantTaskProtocol {}
protocol ToDoGantTaskProtocol: TodoistTaskProtocol,GantTaskProtocol {
}

class ToDoGantTask: ToDoGantTaskProtocol, Equatable {
    static func == (left: ToDoGantTask, right: ToDoGantTask) -> Bool {
        return true
    }
}

/// Плагин для изменения массивов
public extension MutableCollection {
  mutating func forEach(_ body: (inout Element) throws -> Void) rethrows {
    var index = self.startIndex
    while index != self.endIndex {
        try body(&self[index])
        self.formIndex(after: &index)
    }
  }
}
