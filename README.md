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
git clone --branch main https://github.com/HabibaLaisk/Turista.git Turista2
```

2. Put Qt's cmake and mingw compiler on PATH for this session.
```bash
  set PATH=C:\Qt\Tools\CMake_64\bin;C:\Qt\Tools\Ninja;C:\Qt\Tools\mingw1310_64\bin;%PATH%
```

3. Configure the build (Ninja + mingw + the Qt kit).
```bash
  cmake -S Turista2 -B Turista2\build ^
    -G Ninja ^
    -DCMAKE_BUILD_TYPE=Debug ^
    -DCMAKE_PREFIX_PATH=C:/Qt/6.11.1/mingw_64 ^
    -DCMAKE_C_COMPILER=C:/Qt/Tools/mingw1310_64/bin/gcc.exe ^
    -DCMAKE_CXX_COMPILER=C:/Qt/Tools/mingw1310_64/bin/g++.exe
```

4. Build.
```bash
cmake --build Turista2\build
```

5. Run Turista.
```bash
.\Turista2\build\appTurista.exe
```

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
