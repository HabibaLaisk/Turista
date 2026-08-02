# Turista

## Team Information

Team Name: Turista Team #3
Project Name: Turista

Team Members:
- Habiba Saidshah
- Noah Senter
- Ryan Brown
- David Kvanvig

---

## Description

Turista is a desktop travel planning application built using C++, Qt and QML. The application allows users to search for events, restaurants, and attractions by entering a destination, travel dates, budget and category. Search results are retrieved using the Ticketmaster Discovery API and Yelp Fusion API. Users can also create an account, log in and save favorite events.

---

## Tech Stack
- C++
- Qt 6
- Qt Creator
- QML
- CMake
- Git
- GitHub
- Trello
- Ticketmaster Discovery API
- Yelp Fusion API

---

## Dependencies
Before running the project make sure the following are installed:
- Git
- Qt Creator
- Qt 6 Desktop Kit
- CMake
- MinGW 64-bit Compiler
- Internet connection

---

## Build From Scratch

1. Clone the repository.

```bash
git clone https://github.com/HabibaLaisk/Turista.git
```

2. Open Qt Creator.

3. Open the project's `CMakeLists.txt` file.

4. Select the Qt Desktop Kit.

5. Configure the project.

6. In Qt Creator, go to:

```
Projects → Run → Environment
```

7. Add the following environment variables:

```
TICKETMASTER_API_KEY=YOUR_TICKETMASTER_API_KEY
YELP_API_KEY=YOUR_YELP_API_KEY
```

8. Build the project by selecting **Build → Build Project** or pressing **Ctrl + B**.

---

## Running the Application

1. Build the project.
2. Click the green **Run** button in Qt Creator.
3. Log in or create an account.
4. Enter a destination, travel dates, budget, and category.
5. Click **Search** to retrieve recommendations.

---

## Running Unit Tests

1. Open the unit test project in Qt Creator.
2. Build the test project.
3. Select **Build → Run Tests**.
4. Review the results after the tests finish.

---

## Unit Test Output

Unit test results are displayed in the **Test Results** window inside Qt Creator.

Additional debugging information is shown in the **Application Output** window.

---

## Repository
```
Turista/
│
├── models/
├── services/
├── Main.qml
├── LoginPage.qml
├── AccountCreation.qml
├── main.cpp
├── CMakeLists.txt
└── README.md
```

---

## Notes

This project was completed for CS 370 Software Engineering at California State University San Marcos.

GitHub was used for version control, Trello was used for sprint planning, and the project was developed using Agile practices.
