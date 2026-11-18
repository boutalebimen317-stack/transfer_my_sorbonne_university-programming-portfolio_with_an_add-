
const questions = [
    {
        question: "Which language is mainly used for web page structure?",
        answers: ["Python", "HTML", "Java", "C++"],
        correct: 1
    },
    {
        question: "What does CPU stand for?",
        answers: [
            "Central Processing Unit",
            "Computer Personal Unit",
            "Central Program Utility",
            "Control Processing User"
        ],
        correct: 0
    },
    {
        question: "Which data structure follows FIFO?",
        answers: ["Stack", "Tree", "Queue", "Graph"],
        correct: 2
    },
    {
        question: "Which symbol is used for comments in JavaScript?",
        answers: ["<!-- -->", "//", "##", "**"],
        correct: 1
    },
    {
        question: "Which algorithm is used to find the shortest path?",
        answers: [
            "Bubble Sort",
            "Binary Search",
            "Dijkstra's Algorithm",
            "Insertion Sort"
        ],
        correct: 2
    }
];

const questionElement = document.getElementById("question");
const answersContainer = document.getElementById("answers");
const questionNumber = document.getElementById("question-number");
const scoreElement = document.getElementById("score");
const feedbackElement = document.getElementById("feedback");
const nextButton = document.getElementById("next-button");
const restartButton = document.getElementById("restart-button");
const progressBar = document.getElementById("progress-bar");

let currentQuestion = 0;
let score = 0;
let answered = false;


function showQuestion() {
    answered = false;

    const current = questions[currentQuestion];

    questionNumber.textContent =
        `Question ${currentQuestion + 1} of ${questions.length}`;

    scoreElement.textContent = `Score: ${score}`;
    questionElement.textContent = current.question;

    answersContainer.innerHTML = "";
    feedbackElement.textContent = "";
    nextButton.disabled = true;

    progressBar.style.width =
        `${(currentQuestion / questions.length) * 100}%`;

    current.answers.forEach((answer, index) => {
        const button = document.createElement("button");

        button.textContent = answer;
        button.classList.add("answer-button");

        button.addEventListener("click", () => {
            checkAnswer(index);
        });

        answersContainer.appendChild(button);
    });
}


function checkAnswer(selectedIndex) {
    if (answered) {
        return;
    }

    answered = true;

    const current = questions[currentQuestion];
    const buttons = answersContainer.querySelectorAll("button");

    buttons.forEach((button, index) => {
        button.disabled = true;

        if (index === current.correct) {
            button.classList.add("correct");
        } else if (index === selectedIndex) {
            button.classList.add("wrong");
        }
    });

    if (selectedIndex === current.correct) {
        score++;
        feedbackElement.textContent = "Correct answer!";
        feedbackElement.style.color = "#238344";
    } else {
        feedbackElement.textContent = "Not quite! Check the green answer.";
        feedbackElement.style.color = "#c0392b";
    }

    scoreElement.textContent = `Score: ${score}`;
    nextButton.disabled = false;
}


function showResult() {
    questionNumber.textContent = "Quiz completed!";
    questionElement.textContent =
        `You scored ${score} out of ${questions.length}.`;

    answersContainer.innerHTML = "";

    progressBar.style.width = "100%";
    feedbackElement.textContent =
        score === questions.length
            ? "Excellent work! You got every question right."
            : "Good effort! Keep practising.";

    nextButton.hidden = true;
    restartButton.hidden = false;
    scoreElement.textContent = `Final score: ${score}`;
}


nextButton.addEventListener("click", () => {
    if (!answered) {
        return;
    }

    currentQuestion++;

    if (currentQuestion < questions.length) {
        showQuestion();
    } else {
        showResult();
    }
});


restartButton.addEventListener("click", () => {
    currentQuestion = 0;
    score = 0;

    nextButton.hidden = false;
    restartButton.hidden = true;

    showQuestion();
});


showQuestion();
