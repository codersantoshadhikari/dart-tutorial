# How to publish this repository on GitHub

1. Go to github.com → **+** (top right) → **New repository**.
2. Name: `dart-flutter-learning` (or `learn-dart-and-flutter`).
   Description: `Free Dart and Flutter tutorials, 30 Dart examples, Flutter apps and Flame game source code`
   Choose **Public** → **Create repository**.
3. Click the **uploading an existing file** link.
4. Drag in everything **inside** the `dart-flutter-learning` folder (README.md, LESSONS.md, LICENSE, examples, scripts) → **Commit changes**.
5. The `.github` folder may be hidden on your computer. On GitHub click **Add file → Create new file**, type the name
   `.github/workflows/update-lessons.yml`, paste the content of that file from this zip → **Commit**.
6. Click the ⚙️ next to **About** on the right side of the repo page:
   - Website: `https://www.dart-tutorial.dev`
   - Topics: `dart` `flutter` `tutorial` `flame` `riverpod` `flutter-games` `dart-examples`
7. **Settings → Actions → General → Workflow permissions → Read and write permissions** → Save.
8. **Actions** tab → "Update lesson list" → **Run workflow** (once, to test it).

After that it runs by itself every Monday and commits only when a new lesson has been added.

## To get more backlinks from it
- Share the repo link on LinkedIn, Facebook groups and in your dev.to articles.
- Ask friends and classmates to ⭐ star it.
- When you send the awesome-flutter pull request (backlink kit, file 08), you can mention this repo too.
