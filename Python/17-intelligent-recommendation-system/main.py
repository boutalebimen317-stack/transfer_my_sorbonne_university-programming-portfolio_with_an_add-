
# Movie Recommendation System
# Suggests movies based on the user's interests.

movies = [
    {
        "title": "Inception",
        "genre": ["Science Fiction", "Action"],
        "rating": 8.8,
        "keywords": ["dreams", "technology", "mind", "mystery"]
    },
    {
        "title": "Interstellar",
        "genre": ["Science Fiction", "Adventure"],
        "rating": 8.7,
        "keywords": ["space", "time", "science", "family"]
    },
    {
        "title": "The Pursuit of Happyness",
        "genre": ["Drama"],
        "rating": 8.0,
        "keywords": ["motivation", "family", "success", "life"]
    },
    {
        "title": "The Dark Knight",
        "genre": ["Action", "Drama"],
        "rating": 9.0,
        "keywords": ["hero", "crime", "justice", "mystery"]
    },
    {
        "title": "The Martian",
        "genre": ["Science Fiction", "Adventure"],
        "rating": 8.0,
        "keywords": ["space", "science", "survival", "technology"]
    },
    {
        "title": "Coco",
        "genre": ["Animation", "Adventure"],
        "rating": 8.4,
        "keywords": ["family", "music", "dreams", "memory"]
    },
    {
        "title": "The Imitation Game",
        "genre": ["Drama", "History"],
        "rating": 8.0,
        "keywords": ["technology", "mathematics", "history", "intelligence"]
    },
    {
        "title": "Finding Nemo",
        "genre": ["Animation", "Adventure"],
        "rating": 8.2,
        "keywords": ["family", "ocean", "friendship", "adventure"]
    }
]


def show_genres():
    genres = set()

    for movie in movies:
        for genre in movie["genre"]:
            genres.add(genre)

    print("\nAvailable genres:")

    for genre in sorted(genres):
        print("-", genre)


def get_user_preferences():
    show_genres()

    answer = input(
        "\nEnter your favorite genres separated by commas: "
    )

    preferred_genres = [
        genre.strip().lower()
        for genre in answer.split(",")
        if genre.strip()
    ]

    answer = input(
        "Enter keywords you are interested in, separated by commas: "
    )

    preferred_keywords = [
        word.strip().lower()
        for word in answer.split(",")
        if word.strip()
    ]

    return preferred_genres, preferred_keywords


def calculate_score(movie, preferred_genres, preferred_keywords):
    score = 0

    for genre in movie["genre"]:
        if genre.lower() in preferred_genres:
            score += 3

    for keyword in movie["keywords"]:
        if keyword.lower() in preferred_keywords:
            score += 2

    # Give a small bonus to highly rated movies.
    if movie["rating"] >= 8.5:
        score += 1

    return score


def recommend_movies(preferred_genres, preferred_keywords):
    recommendations = []

    for movie in movies:
        score = calculate_score(
            movie,
            preferred_genres,
            preferred_keywords
        )

        if score > 0:
            recommendations.append((movie, score))

    recommendations.sort(
        key=lambda item: (item[1], item[0]["rating"]),
        reverse=True
    )

    return recommendations


def display_recommendations(recommendations):
    print("\n========== YOUR RECOMMENDATIONS ==========")

    if not recommendations:
        print("No suitable movies found.")
        print("Try selecting different genres or keywords.")
        return

    for number, (movie, score) in enumerate(recommendations, start=1):
        print(f"\n{number}. {movie['title']}")
        print("Genres:", ", ".join(movie["genre"]))
        print("Rating:", movie["rating"])
        print("Matching score:", score)

    print("\nThese suggestions are based on your preferences.")
    print("===========================================")


def main():
    print("===================================")
    print("     INTELLIGENT MOVIE FINDER")
    print("===================================")

    while True:
        preferred_genres, preferred_keywords = get_user_preferences()

        recommendations = recommend_movies(
            preferred_genres,
            preferred_keywords
        )

        display_recommendations(recommendations)

        again = input(
            "\nWould you like to try different preferences? (yes/no): "
        ).strip().lower()

        if again not in ["yes", "y"]:
            print("\nThank you for using my recommendation system!")
            break


if __name__ == "__main__":
    main()
