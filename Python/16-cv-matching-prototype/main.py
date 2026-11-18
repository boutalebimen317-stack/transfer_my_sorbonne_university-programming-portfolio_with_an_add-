
# CV Matching Prototype
# A small tool to compare a candidate's skills with a job offer.

import re


def clean_skills(skills):
    """Clean skill names and remove duplicates."""
    cleaned = []

    for skill in skills:
        skill = skill.strip().lower()

        if skill and skill not in cleaned:
            cleaned.append(skill)

    return cleaned


def read_skills(message):
    print(message)
    answer = input("Enter skills separated by commas: ")

    skills = answer.split(",")
    return clean_skills(skills)


def calculate_match(candidate_skills, required_skills):
    if not required_skills:
        return 0, [], []

    matched = []
    missing = []

    for skill in required_skills:
        if skill in candidate_skills:
            matched.append(skill)
        else:
            missing.append(skill)

    percentage = (len(matched) / len(required_skills)) * 100

    return percentage, matched, missing


def show_result(name, percentage, matched, missing):
    print("\n========== MATCHING REPORT ==========")
    print("Candidate:", name)
    print(f"Matching score: {percentage:.1f}%")

    print("\nSkills that match:")
    if matched:
        for skill in matched:
            print("-", skill)
    else:
        print("No matching skills found.")

    print("\nSkills to improve:")
    if missing:
        for skill in missing:
            print("-", skill)
    else:
        print("All required skills are covered!")

    print("\nAssessment:")

    if percentage >= 80:
        print("Strong match for this position.")
    elif percentage >= 50:
        print("Partial match. Some skills need improvement.")
    else:
        print("Low match. More preparation is recommended.")

    print("=====================================")


def main():
    print("================================")
    print("       CV MATCHING SYSTEM")
    print("================================")

    candidate_name = input("Candidate name: ").strip()

    if not candidate_name:
        candidate_name = "Unknown candidate"

    candidate_skills = read_skills(
        "\nEnter the candidate's skills:"
    )

    required_skills = read_skills(
        "\nEnter the skills required by the job:"
    )

    if not candidate_skills:
        print("\nNo candidate skills were entered.")
        return

    if not required_skills:
        print("\nNo job requirements were entered.")
        return

    percentage, matched, missing = calculate_match(
        candidate_skills,
        required_skills
    )

    show_result(
        candidate_name,
        percentage,
        matched,
        missing
    )


if __name__ == "__main__":
    main()
