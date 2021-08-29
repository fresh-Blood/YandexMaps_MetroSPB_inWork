import UIKit



struct Station : Hashable {
    var id : Int 
    var name : String
}

struct Vertex<T> { // вершины графа - станции
    let data : T
    var visited = false
}


struct Edge<T> { // ребра графа - ж/д пути
    let source : Vertex<T>  // станция от которой берет начало путь
    let destination : Vertex<T>  // станция к которой прибудем
    let weight : Int
}

extension Vertex : Hashable where T : Hashable {}
extension Vertex : Equatable where T : Equatable {}
extension Vertex : CustomStringConvertible {
    var description : String {
        return "\(data)"
    }
    
}

protocol Graph {
    associatedtype Element
    func createVertex(data: Element) -> Vertex<Element>
    func add(from source: Vertex<Element>, to destination: Vertex<Element>, weight: Int)
    func edges(from source: Vertex<Element>) -> [Edge<Element>]
}

class AdjacencyList <T:Hashable>: Graph {
    
    var adjacencies : [Vertex<T>:[Edge<T>]] = [:] //  словарь где ключ - вершина а значение - массив ребер или ребро у которого ( рых ) есть weight
    init() {}
    
    func createVertex(data: T) -> Vertex<T> {
        let vertex = Vertex(data: data, visited: false)
        adjacencies[vertex] = []
        return vertex
    }
    
    func add(from source:Vertex<T>, to destination: Vertex<T>, weight: Int) {
        let edge = Edge(source: source, destination: destination, weight: weight)
        adjacencies[source]?.append(edge)
    }
    
    func edges(from source: Vertex<T>) -> [Edge<T>] {
        return adjacencies[source] ?? []
    }
    
    
}

extension AdjacencyList: CustomStringConvertible { // визуализация списка смежности в котором хранится граф с его вершинами и ребрами
    public var description: String {
        var result = ""
        for (vertex,edges) in adjacencies {
            var edgeString = ""
            for (index,edge) in edges.enumerated() {
                if index != edges.count - 1 {
                    edgeString.append("\(edge.destination), ")
                } else {
                    edgeString.append("\(edge.destination)")
                }
            }
            result.append("\(vertex) ---> [\(edgeString)]\n")
        }
        return result
    }
}

let graph = AdjacencyList<Station>()  // это граф

var shortestPath : [Vertex<Station>] = [] // массив кратчайшего пути станции вершины

func findVertexViaShortestEdge(from: Vertex<Station>, edges: [Edge<Station>]) -> Vertex<Station> {
    
    var tempV = Vertex(data: Station(id: 0, name: ""), visited: false)
    
    for (index,edge) in edges.enumerated() {
        
        var tempDict : [Int:Vertex<Station>] = [:]
        
        switch index {
        case 0:
            tempDict.updateValue(edge.destination, forKey: edge.weight)
        case 1:
            tempDict.updateValue(edge.destination, forKey: edge.weight)
        case 2:
            tempDict.updateValue(edge.destination, forKey: edge.weight)
        case 3:
            tempDict.updateValue(edge.destination, forKey: edge.weight)
        default : break
        }
        let sortedDict = tempDict.sorted(by: {$0.key < $1.key })
        if let unwrapped = sortedDict.first?.value {
            tempV = unwrapped
        }
    }
    return tempV
}

var visitedVertexes : [Vertex<Station>] = [] // массив посещенных вершин
var tempV = Vertex(data: Station(id: 0, name: ""))
var tempV2 = Vertex(data: Station(id: 0, name: ""))

// Алгоритм Дейкстры

func findPath(from: Vertex<Station>, to: Vertex<Station>) -> [Vertex<Station>] {
    
    for (vertex,edges) in graph.adjacencies where vertex.visited == false {
        
        if vertex == from {
            shortestPath.append(vertex)
            var temp = vertex
            temp.visited = true
            tempV = findVertexViaShortestEdge(from: vertex, edges: edges)
            tempV.visited = true
            shortestPath.append(tempV)
            if tempV == to {
                break
            }
        }
        if vertex == tempV {
                tempV2 = findVertexViaShortestEdge(from: vertex, edges: edges)
                tempV2.visited = true
                shortestPath.append(tempV2)
                if tempV2 == to {
                    break
            
            }
        }
    }
    return shortestPath
}




