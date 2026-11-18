
# Text Classification System
# A simple prototype that sorts text into different categories.

import re


categories = {
    "Technology": [
        "computer", "software", "programming", "python",
        "robot", "artificial intelligence", "technology",
        "internet", "database", "algorithm"
    ],

    "Sports": [
        "football", "basketball", "player", "team",
        "match", "goal", "tournament", "coach",
        "training", "championship"
    ],

    "Entertainment": [
        "movie", "music", "actor", "film",
        "concert", "series", "song", "cinema",
        "artist", "show"
    ]
}


def clean_text(text):
    """Prepare text for comparison."""
    text = text.lower()
    text = re.sub(r"[^a-z0-9\s]", " ", text)
    return text.split()


def classify_text(text):
    words = clean_text(text)
    scores = {}

    for category, keywords in categories.items():
        score = 0

        for keyword in keywords:
            # Some keywords contain more than one word.
            if " " in keyword:
                if keyword in text.lower():
                    score += 1
            elif keyword in words:
                score += 1

        scores[category] = score

    best_category = max(scores, key=scores.get)
    total_matches = sum(scores.values())

    if scores[best_category] == 0:
        return "Unclassified", 0, scores

    confidence = (scores[best_category] / total_matches) * 100

    return best_category, confidence, scores


def show_result(text, category, confidence, scores):
    print("\n========== CLASSIFICATION RESULT ==========")
    print("Text:", text)
    print("Category:", category)

    if category == "Unclassified":
        print("No matching keywords were found.")
    else:
        print(f"Confidence score: {confidence:.1f}%")

    print("\nCategory scores:")

    for name, score in scores.items():
        print(f"{name}: {score}")

    print("===========================================")


def main():
    history = []

    print("===================================")
    print("      TEXT CLASSIFICATION TOOL")
    print("===================================")

    while True:
        print("\n1. Classify text")
        print("2. Show classification history")
        print("3. Show available categories")
        print("0. Exit")

        choice = input("\nChoose an option: ").strip()

        if choice == "1":
            text = input("\nEnter your text: ").strip()

            if not text:
                print("Please enter some text.")
                continue

            category, confidence, scores = classify_text(text)

            show_result(text, category, confidence, scores)

            history.append({
                "text": text,
                "category": category,
                "confidence": confidence
            })

        elif choice == "2":
            if not history:
                print("\nNo classifications have been made yet.")
            else:
                print("\n========== HISTORY ==========")

                for number, item in enumerate(history, start=1):
                    print(f"\n{number}. {item['text']}")
                    print("Category:", item["category"])
                    print(f"Confidence: {item['confidence']:.1f}%")

        elif choice == "3":
            print("\nAvailable categories:")

            for category in categories:
                print("-", category)

        elif choice == "0":
            print("\nThnx  for using our  classifier!")
            break

        else:
            print("Invalid option. will u try again !!!.")


if __name__ == "__main__":
    main()
