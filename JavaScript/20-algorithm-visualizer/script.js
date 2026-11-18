
const arrayContainer = document.getElementById("array-container");
const generateButton = document.getElementById("generate-button");
const sortButton = document.getElementById("sort-button");
const algorithmSelect = document.getElementById("algorithm");
const sizeInput = document.getElementById("array-size");
const sizeValue = document.getElementById("size-value");
const speedInput = document.getElementById("speed");

const comparisonsElement = document.getElementById("comparisons");
const swapsElement = document.getElementById("swaps");
const statusElement = document.getElementById("status");

let numbers = [];
let comparisons = 0;
let swaps = 0;
let isSorting = false;


function createArray() {
    if (isSorting) return;

    const size = Number(sizeInput.value);

    numbers = [];

    for (let i = 0; i < size; i++) {
        numbers.push(Math.floor(Math.random() * 90) + 10);
    }

    comparisons = 0;
    swaps = 0;

    updateStatistics();
    drawArray();
    statusElement.textContent = "Ready";
}


function drawArray(activeIndices = [], sortedIndices = []) {
    arrayContainer.innerHTML = "";

    numbers.forEach((number, index) => {
        const bar = document.createElement("div");

        bar.classList.add("bar");
        bar.style.height = `${number}%`;
        bar.title = number;

        if (activeIndices.includes(index)) {
            bar.classList.add("comparing");
        }

        if (sortedIndices.includes(index)) {
            bar.classList.add("sorted");
        }

        arrayContainer.appendChild(bar);
    });
}


function updateStatistics() {
    comparisonsElement.textContent = comparisons;
    swapsElement.textContent = swaps;
}


function wait() {
    return new Promise(resolve => {
        setTimeout(resolve, Number(speedInput.value));
    });
}


async function showStep(activeIndices = [], sortedIndices = []) {
    drawArray(activeIndices, sortedIndices);
    updateStatistics();
    await wait();
}


async function bubbleSort() {
    const length = numbers.length;

    for (let i = 0; i < length - 1; i++) {
        for (let j = 0; j < length - i - 1; j++) {
            comparisons++;

            await showStep([j, j + 1]);

            if (numbers[j] > numbers[j + 1]) {
                [numbers[j], numbers[j + 1]] =
                    [numbers[j + 1], numbers[j]];

                swaps++;

                await showStep([j, j + 1]);
            }
        }

        await showStep([], Array.from(
            { length: i + 1 },
            (_, index) => length - 1 - index
        ));
    }
}


async function selectionSort() {
    const length = numbers.length;

    for (let i = 0; i < length - 1; i++) {
        let smallest = i;

        for (let j = i + 1; j < length; j++) {
            comparisons++;

            await showStep([smallest, j]);

            if (numbers[j] < numbers[smallest]) {
                smallest = j;
            }
        }

        if (smallest !== i) {
            [numbers[i], numbers[smallest]] =
                [numbers[smallest], numbers[i]];

            swaps++;
        }

        await showStep([i, smallest], Array.from(
            { length: i },
            (_, index) => index
        ));
    }
}


async function insertionSort() {
    const length = numbers.length;

    for (let i = 1; i < length; i++) {
        const current = numbers[i];
        let j = i - 1;

        while (j >= 0) {
            comparisons++;

            await showStep([j, j + 1]);

            if (numbers[j] > current) {
                numbers[j + 1] = numbers[j];
                swaps++;
                j--;
            } else {
                break;
            }
        }

        numbers[j + 1] = current;
        await showStep([j + 1]);
    }
}


async function startSorting() {
    if (isSorting || numbers.length === 0) return;

    isSorting = true;

    generateButton.disabled = true;
    sortButton.disabled = true;
    sizeInput.disabled = true;
    algorithmSelect.disabled = true;

    comparisons = 0;
    swaps = 0;

    statusElement.textContent = "Sorting...";

    try {
        const algorithm = algorithmSelect.value;

        if (algorithm === "bubble") {
            await bubbleSort();
        } else if (algorithm === "selection") {
            await selectionSort();
        } else if (algorithm === "insertion") {
            await insertionSort();
        }

        drawArray([], numbers.map((_, index) => index));
        statusElement.textContent = "Completed!";
    } finally {
        isSorting = false;

        generateButton.disabled = false;
        sortButton.disabled = false;
        sizeInput.disabled = false;
        algorithmSelect.disabled = false;

        updateStatistics();
    }
}


generateButton.addEventListener("click", createArray);

sortButton.addEventListener("click", startSorting);

sizeInput.addEventListener("input", () => {
    sizeValue.textContent = sizeInput.value;
    createArray();
});

createArray();
