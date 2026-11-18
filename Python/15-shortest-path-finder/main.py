
import heapq

graph = {
    "A": {"B": 4, "C": 2},
    "B": {"A": 4, "C": 1, "D": 5},
    "C": {"A": 2, "B": 1, "D": 8, "E": 10},
    "D": {"B": 5, "C": 8, "E": 2, "F": 6},
    "E": {"C": 10, "D": 2, "F": 3},
    "F": {"D": 6, "E": 3}
}


def find_shortest_path(start, destination):
    distances = {node: float("inf") for node in graph}
    previous = {}

    distances[start] = 0
    queue = [(0, start)]

    while queue:
        distance, current = heapq.heappop(queue)

        if distance > distances[current]:
            continue

        if current == destination:
            break

        for neighbor, cost in graph[current].items():
            new_distance = distance + cost

            if new_distance < distances[neighbor]:
                distances[neighbor] = new_distance
                previous[neighbor] = current
                heapq.heappush(queue, (new_distance, neighbor))

    if distances[destination] == float("inf"):
        return None, None

    path = []
    current = destination

    while current != start:
        path.append(current)
        current = previous[current]

    path.append(start)
    path.reverse()

    return path, distances[destination]


print("Available locations:", ", ".join(graph))

start = input("Starting point: ").upper()
destination = input("Destination: ").upper()

if start not in graph or destination not in graph:
    print("Please enter valid locations.")
else:
    path, distance = find_shortest_path(start, destination)

    if path is None:
        print("No route found.")
    else:
        print("Shortest path:", " -> ".join(path))
        print("Total distance:", distance)
