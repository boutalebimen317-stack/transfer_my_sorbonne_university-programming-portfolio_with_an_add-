
const taskForm = document.getElementById("task-form");
const taskName = document.getElementById("task-name");
const taskDate = document.getElementById("task-date");
const taskPriority = document.getElementById("task-priority");

const taskList = document.getElementById("task-list");
const filterTasks = document.getElementById("filter-tasks");
const emptyMessage = document.getElementById("empty-message");

const totalCount = document.getElementById("total-count");
const completedCount = document.getElementById("completed-count");
const pendingCount = document.getElementById("pending-count");
const progressValue = document.getElementById("progress-value");
const progressLabel = document.getElementById("progress-label");
const progressBar = document.getElementById("progress-bar");

let tasks = [];

try {
    const savedTasks = JSON.parse(
        localStorage.getItem("myTasks") || "[]"
    );

    if (Array.isArray(savedTasks)) {
        tasks = savedTasks;
    }
} catch (error) {
    console.log("Could not load saved tasks:", error);
}


function saveTasks() {
    localStorage.setItem("myTasks", JSON.stringify(tasks));
}


function updateStatistics() {
    const total = tasks.length;
    const completed = tasks.filter(task => task.completed).length;
    const pending = total - completed;

    const percentage = total === 0
        ? 0
        : Math.round((completed / total) * 100);

    totalCount.textContent = total;
    completedCount.textContent = completed;
    pendingCount.textContent = pending;

    progressValue.textContent = `${percentage}%`;
    progressLabel.textContent = `${percentage}%`;
    progressBar.style.width = `${percentage}%`;
}


function addTask(event) {
    event.preventDefault();

    const name = taskName.value.trim();
    const date = taskDate.value;
    const priority = taskPriority.value;

    if (!name || !date) {
        alert("Please enter a task name and deadline.");
        return;
    }

    const newTask = {
        id: Date.now(),
        name: name,
        date: date,
        priority: priority,
        completed: false
    };

    tasks.push(newTask);

    saveTasks();
    displayTasks();

    taskForm.reset();
    taskPriority.value = "Medium";
}


function deleteTask(taskId) {
    const answer = confirm("Are you sure you want to delete this task?");

    if (!answer) {
        return;
    }

    tasks = tasks.filter(task => task.id !== taskId);

    saveTasks();
    displayTasks();
}


function toggleTask(taskId) {
    const task = tasks.find(item => item.id === taskId);

    if (task) {
        task.completed = !task.completed;
    }

    saveTasks();
    displayTasks();
}


function getDeadlineMessage(task) {
    if (task.completed) {
        return "Completed";
    }

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const deadline = new Date(`${task.date}T00:00:00`);
    const difference = Math.round(
        (deadline - today) / (1000 * 60 * 60 * 24)
    );

    if (difference < 0) {
        return "Overdue";
    }

    if (difference === 0) {
        return "Due today";
    }

    return `${difference} day(s) left`;
}


function displayTasks() {
    taskList.innerHTML = "";

    const filter = filterTasks.value;

    let visibleTasks = [...tasks];

    if (filter === "pending") {
        visibleTasks = visibleTasks.filter(task => !task.completed);
    } else if (filter === "completed") {
        visibleTasks = visibleTasks.filter(task => task.completed);
    }

    // Show unfinished tasks before completed ones.
    visibleTasks.sort((a, b) => {
        if (a.completed !== b.completed) {
            return Number(a.completed) - Number(b.completed);
        }

        return a.date.localeCompare(b.date);
    });

    emptyMessage.hidden = visibleTasks.length > 0;

    if (tasks.length === 0) {
        emptyMessage.textContent =
            "No tasks yet. Add your first task above!";
    } else if (visibleTasks.length === 0) {
        emptyMessage.textContent =
            "There are no tasks in this category.";
    }

    visibleTasks.forEach(task => {
        const item = document.createElement("div");
        item.className = "task-item";

        const info = document.createElement("div");
        info.className = "task-info";

        if (task.completed) {
            info.classList.add("completed-task");
        }

        const title = document.createElement("h3");
        title.textContent = task.name;

        const date = document.createElement("p");
        date.textContent = `Deadline: ${task.date}`;

        const deadline = document.createElement("p");
        deadline.textContent = getDeadlineMessage(task);

        const priority = document.createElement("span");
        priority.className = `priority ${task.priority}`;
        priority.textContent = task.priority + " Priority";

        info.append(title, date, deadline, priority);

        const actions = document.createElement("div");
        actions.className = "task-actions";

        const completeButton = document.createElement("button");
        completeButton.className = "complete-button";
        completeButton.textContent = task.completed ? "Undo" : "Complete";

        completeButton.addEventListener("click", () => {
            toggleTask(task.id);
        });

        const deleteButton = document.createElement("button");
        deleteButton.className = "delete-button";
        deleteButton.textContent = "Delete";

        deleteButton.addEventListener("click", () => {
            deleteTask(task.id);
        });

        actions.append(completeButton, deleteButton);
        item.append(info, actions);

        taskList.appendChild(item);
    });

    updateStatistics();
}


taskForm.addEventListener("submit", addTask);
filterTasks.addEventListener("change", displayTasks);

displayTasks();
