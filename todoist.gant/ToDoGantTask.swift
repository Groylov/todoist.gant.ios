//
//  ToDoGantTask.swift
//  todoist.gant
//
//  Created by Aleksey Groylov on 21.05.2020.
//  Copyright © 2020 Aleksey Groylov. All rights reserved.
//
//  Модуль описания класса харанения задач

import Foundation

/// Список ошибок класса ToDoGantTask
enum ToDoGantTaskError: Error {
    
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
