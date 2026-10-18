---
title: "Lists in Dart: Create, Access, Add, Remove and Sort"
linkTitle: "Lists"
description: "Complete guide to List in Dart: creating lists, indexing, adding and removing items, searching, sorting, sublists and fixed-length lists."
weight: 2
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart list"
  - "dart array"
  - "list methods"
  - "add remove list"
  - "sort list dart"
  - "List.generate"
aliases:
  - "/dart-collections/lists/"
  - "/fr/dart-collections/lists/"
---

A `List` is an ordered collection, the same idea other languages call an array. Each item has a position, called its **index**, starting at 0.

## Creating and reading

```dart
void main() {
  var fruits = ['apple', 'banana', 'cherry'];

  print(fruits[0]);
  print(fruits[fruits.length - 1]);
  print(fruits.first);
  print(fruits.last);
  print(fruits.length);
}
```

```output
apple
cherry
apple
cherry
3
```

Asking for an index that does not exist, such as `fruits[5]`, throws a `RangeError`.

## Changing items

```dart
void main() {
  var fruits = ['apple', 'banana', 'cherry'];

  fruits[1] = 'blueberry';          // replace
  fruits.add('date');               // add to the end
  fruits.addAll(['fig', 'grape']);  // add several
  fruits.insert(0, 'apricot');      // add at a position

  print(fruits);
}
```

```output
[apricot, apple, blueberry, cherry, date, fig, grape]
```

## Removing items

```dart
void main() {
  var numbers = [10, 20, 30, 40, 50, 60];

  numbers.remove(30);                 // by value
  numbers.removeAt(0);                // by index
  numbers.removeLast();
  numbers.removeWhere((n) => n > 45); // by condition

  print(numbers);
  numbers.clear();
  print(numbers);
}
```

```output
[20, 40]
[]
```

## Searching

```dart
void main() {
  var names = ['Ram', 'Sita', 'Hari', 'Gita'];

  print(names.contains('Hari'));
  print(names.indexOf('Hari'));
  print(names.indexOf('Nobody'));  // -1 means not found
  print(names.firstWhere((n) => n.endsWith('ita')));
  print(names.indexWhere((n) => n.startsWith('G')));
}
```

```output
true
2
-1
Sita
3
```

## Sorting and reversing

`sort` changes the list itself. `reversed` gives back a new view and leaves the list alone.

```dart
void main() {
  var scores = [72, 95, 58, 81];

  scores.sort();
  print(scores);

  scores.sort((a, b) => b.compareTo(a)); // highest first
  print(scores);

  print(scores.reversed.toList());
}
```

```output
[58, 72, 81, 95]
[95, 81, 72, 58]
[58, 72, 81, 95]
```

## Slicing

```dart
void main() {
  var letters = ['a', 'b', 'c', 'd', 'e'];

  print(letters.sublist(1, 3)); // index 1 up to, not including, 3
  print(letters.take(2).toList());
  print(letters.skip(3).toList());
  print(letters.join('-'));
}
```

```output
[b, c]
[a, b]
[d, e]
a-b-c-d-e
```

## Other ways to build a list

```dart
void main() {
  var zeros = List.filled(3, 0);                 // fixed length
  var squares = List.generate(5, (i) => i * i);  // from a function
  var copy = List.of(squares);                   // a separate copy
  var locked = List.unmodifiable([1, 2, 3]);     // cannot be changed

  print(zeros);
  print(squares);
  print(copy);
  print(locked);
}
```

```output
[0, 0, 0]
[0, 1, 4, 9, 16]
[0, 1, 4, 9, 16]
[1, 2, 3]
```

`List.filled` creates a fixed-length list: you can change its items but `add` throws an error.

## Lists are shared, not copied

Assigning a list to another variable does not copy it. Both names refer to the same list.

```dart
void main() {
  var a = [1, 2, 3];
  var b = a;        // same list
  var c = [...a];   // a real copy

  b.add(4);
  print(a);
  print(c);
}
```

```output
[1, 2, 3, 4]
[1, 2, 3]
```

## Lists of lists

```dart
void main() {
  var grid = [
    [1, 2, 3],
    [4, 5, 6],
  ];
  print(grid[1][2]);
}
```

```output
6
```

## Try it yourself

Start with `[34, 12, 45, 12, 9]`. Remove the duplicate, sort it from highest to lowest, add `50` at the front, and print the middle item.
