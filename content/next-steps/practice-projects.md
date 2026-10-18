---
title: "Dart Practice Projects and Exercises for Beginners"
seoTitle: "Dart Exercises and Practice Projects for Beginners"
linkTitle: "Practice projects"
description: "Fifteen Dart project ideas from beginner to advanced, with the skills each one practises, to turn what you have learned into real ability."
weight: 2
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart projects"
  - "dart exercises"
  - "dart practice"
  - "beginner dart projects"
  - "dart project ideas"
---

Reading about Dart gives you knowledge. Building things gives you skill. This page lists projects in rising order of difficulty. All of them can be written as command-line programs with plain Dart, with no Flutter needed.

## How to get the most from a project

1. **Build the smallest version first.** One feature, working end to end.
2. **Type the code yourself.** Do not copy and paste.
3. **Get stuck on purpose.** Struggle for twenty minutes before searching. That is when the learning happens.
4. **Refactor when it works.** Rename things, split big functions, remove repetition.
5. **Add tests** to at least one project.
6. **Put it on GitHub**, with a README. A few finished projects are worth more than many unfinished ones.

## Beginner projects

These use the first five chapters: basics, control flow, functions and collections.

### 1. Number guessing game

The program picks a random number from 1 to 100. The player guesses, and the program replies "too high" or "too low" until they get it, then reports the number of attempts.

- **Practises:** `Random`, `stdin`, `int.tryParse`, `while` loops, `if`/`else`.
- **Extend it:** difficulty levels, a limit on guesses, a best score saved to a file.

### 2. Unit converter

Convert between Celsius and Fahrenheit, kilometres and miles, kilograms and pounds. Show a menu and ask for the value.

- **Practises:** functions, `switch`, `double` formatting, input validation.
- **Extend it:** store the conversions in a map so that adding one needs no new code.

### 3. Grade calculator

Read marks for several subjects, then print the total, the average, the highest and lowest, and a letter grade for each.

- **Practises:** lists, `reduce` and `fold`, `map`, string formatting.

### 4. Word counter

Given some text, report the number of characters, words and sentences, and the five most common words.

- **Practises:** string methods, `split`, maps for counting, sorting map entries.

### 5. Simple calculator

Read an expression such as `12 * 4` and print the answer. Handle division by zero and bad input.

- **Practises:** string parsing, `switch` expressions, exceptions.
- **Extend it:** support several operations in one line, with correct precedence.

## Intermediate projects

These bring in null safety, classes, error handling, files and JSON.

### 6. To-do list manager

Add, list, complete and delete tasks from the command line. Save them in a JSON file so they are still there next time.

- **Practises:** classes, `fromJson` and `toJson`, file reading and writing, command-line arguments.
- **Extend it:** due dates, priorities with an enum, filtering and sorting.

### 7. Contact book

Store contacts with a name, phone number and email. Support search, edit and delete, and validate phone numbers and emails.

- **Practises:** classes, maps, regular expressions, custom exceptions.

### 8. Bank account simulator

Model `Account`, `SavingsAccount` and `CurrentAccount`. Support deposits, withdrawals and transfers, and keep a transaction history.

- **Practises:** inheritance, abstract classes, getters and setters, private fields, custom exceptions, `DateTime`.
- **Extend it:** monthly interest, overdraft limits, a statement saved to a file.

### 9. Quiz game

Load questions from a JSON file, ask them in random order, keep score, and show the results with the correct answers at the end.

- **Practises:** JSON, model classes, `shuffle`, records for returning a score and a total.
- **Extend it:** categories, a time limit per question using `Future.timeout`.

### 10. Library management system

Track books and members. Members borrow and return books; the program prevents borrowing unavailable books and calculates late fees.

- **Practises:** several classes working together, enums, collections, date arithmetic.

### 11. Expense tracker

Record expenses with an amount, a category and a date. Report totals per category and per month.

- **Practises:** enhanced enums, grouping with maps, `fold`, date handling, extension methods.

## Advanced projects

These use async code, HTTP, streams, generics, patterns and packages.

### 12. Weather command-line app

Take a city name, call a free weather API, and display the current conditions and forecast.

- **Practises:** the `http` package, `async`/`await`, JSON decoding, error handling, timeouts, the `args` package.
- **Extend it:** cache responses in a file for ten minutes, compare several cities in parallel with `Future.wait`.

### 13. File organiser

Scan a folder and move files into sub-folders by type (images, documents, videos) or by month. Offer a dry-run mode that only prints what would happen.

- **Practises:** `dart:io` directories, the `path` package, streams, `switch` on extensions, command-line flags.

### 14. Text adventure game

A game where the player moves between rooms, picks up items and solves puzzles by typing commands.

- **Practises:** sealed classes for commands, pattern matching, maps of rooms, state management, saving and loading the game.

### 15. A small REST API server

Build a JSON API for the to-do list using the `shelf` package: list, create, update and delete tasks over HTTP.

- **Practises:** server-side Dart, routing, JSON, async handlers, status codes, testing with a fake store.
- **Extend it:** store the data in SQLite, and build a Flutter app that talks to your API.

## Quick exercises for daily practice

Ten minutes each. Try them without looking anything up.

1. Reverse a string without using `split` or `reversed`.
2. Check whether a string is a palindrome, ignoring spaces and case.
3. Find the second-largest number in a list.
4. Remove duplicates from a list while keeping the original order.
5. Count the vowels in a sentence.
6. Print FizzBuzz from 1 to 100 using a switch expression.
7. Check whether two strings are anagrams of each other.
8. Flatten a list of lists into a single list.
9. Group a list of words by their first letter into a map.
10. Find all pairs of numbers in a list that add up to a target.
11. Write a function that returns the minimum, maximum and average as a record.
12. Convert a number from 1 to 3999 into Roman numerals.
13. Write a generic `Stack<T>` and a generic `Queue<T>`.
14. Merge two sorted lists into one sorted list.
15. Write an `async` function that retries a failing operation three times.

Sites such as Exercism, LeetCode and Advent of Code accept Dart solutions and provide endless further practice.

## After these

- **Learn Flutter** and rebuild one of the projects above as a mobile app. Start with [what Flutter is](https://flutter.dart-tutorial.dev/getting-started/what-is-flutter/).
- **Read other people's code.** Popular packages on pub.dev are excellent teachers.
- **Contribute** a small fix or a documentation improvement to an open-source package.
- **Publish a package** of your own. See [publishing packages](/libraries-and-packages/publishing-packages/).

## Try it yourself

Choose one project from the beginner list and finish it today, however rough. Tomorrow, choose one from the intermediate list and give it a week.
