
const http = require("http");

const PORT = 3000;

let tasks = [
    {
        id: 1,
        title: "Learn REST API basics",
        description: "Understand HTTP methods and status codes",
        completed: false
    },
    {
        id: 2,
        title: "Practise JavaScript",
        description: "Build small projects using Node.js",
        completed: true
    }
];

let nextId = 3;


function sendResponse(response, statusCode, data) {
    response.writeHead(statusCode, {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type"
    });

    response.end(JSON.stringify(data, null, 2));
}


function readRequestBody(request) {
    return new Promise((resolve, reject) => {
        let body = "";

        request.on("data", chunk => {
            body += chunk;

            if (body.length > 100000) {
                reject(new Error("Request body is too large."));
                request.destroy();
            }
        });

        request.on("end", () => {
            try {
                const data = JSON.parse(body || "{}");
                resolve(data);
            } catch (error) {
                reject(new Error("Invalid JSON format."));
            }
        });

        request.on("error", reject);
    });
}


function findTask(id) {
    return tasks.find(task => task.id === id);
}


const server = http.createServer(async (request, response) => {
    const url = new URL(request.url, `http://${request.headers.host || "localhost"}`);
    const pathname = url.pathname;

    if (request.method === "OPTIONS") {
        response.writeHead(204, {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
            "Access-Control-Allow-Headers": "Content-Type"
        });

        response.end();
        return;
    }

    // Main API information
    if (pathname === "/" && request.method === "GET") {
        sendResponse(response, 200, {
            message: "Welcome to the Task Management API",
            availableRoutes: [
                "GET /tasks",
                "GET /tasks/:id",
                "POST /tasks",
                "PUT /tasks/:id",
                "DELETE /tasks/:id"
            ]
        });

        return;
    }

    // Return all tasks
    if (pathname === "/tasks" && request.method === "GET") {
        sendResponse(response, 200, {
            count: tasks.length,
            tasks: tasks
        });

        return;
    }

    // Create a new task
    if (pathname === "/tasks" && request.method === "POST") {
        try {
            const data = await readRequestBody(request);

            if (!data.title || typeof data.title !== "string" || !data.title.trim()) {
                sendResponse(response, 400, {
                    error: "A valid task title is required."
                });

                return;
            }

            if (
                data.description !== undefined &&
                typeof data.description !== "string"
            ) {
                sendResponse(response, 400, {
                    error: "Description must be text."
                });

                return;
            }

            if (
                data.completed !== undefined &&
                typeof data.completed !== "boolean"
            ) {
                sendResponse(response, 400, {
                    error: "Completed must be true or false."
                });

                return;
            }

            const newTask = {
                id: nextId++,
                title: data.title.trim(),
                description: data.description || "",
                completed: data.completed ?? false
            };

            tasks.push(newTask);

            sendResponse(response, 201, {
                message: "Task created successfully.",
                task: newTask
            });
        } catch (error) {
            sendResponse(response, 400, { error: error.message });
        }

        return;
    }

    // Routes that need a task ID
    const taskRoute = pathname.match(/^\/tasks\/(\d+)$/);

    if (taskRoute) {
        const id = Number(taskRoute[1]);
        const task = findTask(id);

        // Get one task
        if (request.method === "GET") {
            if (!task) {
                sendResponse(response, 404, {
                    error: "Task not found."
                });
            } else {
                sendResponse(response, 200, task);
            }

            return;
        }

        // Update a task
        if (request.method === "PUT") {
            if (!task) {
                sendResponse(response, 404, {
                    error: "Task not found."
                });

                return;
            }

            try {
                const data = await readRequestBody(request);

                if (
                    data.title !== undefined &&
                    (typeof data.title !== "string" || !data.title.trim())
                ) {
                    sendResponse(response, 400, {
                        error: "Title must be a non-empty string."
                    });

                    return;
                }

                if (
                    data.description !== undefined &&
                    typeof data.description !== "string"
                ) {
                    sendResponse(response, 400, {
                        error: "Description must be text."
                    });

                    return;
                }

                if (
                    data.completed !== undefined &&
                    typeof data.completed !== "boolean"
                ) {
                    sendResponse(response, 400, {
                        error: "Completed must be true or false."
                    });

                    return;
                }

                if (data.title !== undefined) {
                    task.title = data.title.trim();
                }

                if (data.description !== undefined) {
                    task.description = data.description;
                }

                if (data.completed !== undefined) {
                    task.completed = data.completed;
                }

                sendResponse(response, 200, {
                    message: "Task updated successfully.",
                    task: task
                });
            } catch (error) {
                sendResponse(response, 400, { error: error.message });
            }

            return;
        }

        // Delete a task
        if (request.method === "DELETE") {
            if (!task) {
                sendResponse(response, 404, {
                    error: "Task not found."
                });

                return;
            }

            tasks = tasks.filter(item => item.id !== id);

            sendResponse(response, 200, {
                message: "Task deleted successfully."
            });

            return;
        }
    }

    sendResponse(response, 404, {
        error: "Route not found."
    });
});


server.listen(PORT, () => {
    console.log(`Task API is running at http://localhost:${PORT}`);
});
