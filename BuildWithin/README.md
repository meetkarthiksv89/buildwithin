# BuildWithin Fitness App MVP

## Overview

This is an iOS fitness app MVP built with SwiftUI and MVVM architecture. The app loads workout programs from local JSON files and allows users to track their workout progress.

## Architecture

- **Models**: Codable structs matching JSON schema (`Models/`)
- **Repository**: Loads program content from JSON files (`Repository/`)
- **Storage**: Progress tracking with UserDefaults (Firebase-ready interface) (`Storage/`)
- **ViewModels**: Business logic and state management (`ViewModels/`)
- **Views**: SwiftUI screens and reusable components (`Views/`)

## File Structure

```
BuildWithin/
├── Models/              # Data models (Program, WorkoutDay, Exercise, etc.)
├── Repository/         # Program loading logic
├── Storage/            # Progress tracking (UserDefaults MVP)
├── ViewModels/         # MVVM view models
├── Views/              # SwiftUI screens and components
├── Resources/
│   └── Programs/       # JSON program files
└── Utilities/          # Color extensions and utilities
```

## Adding a New Program

1. Create a new JSON file following the schema in `prog_fatloss_4day.json`
2. Place it in `Resources/Programs/`
3. Add the filename to `Resources/Programs/program_index.json`:

```json
{
  "programFiles": [
    "prog_fatloss_4day.json",
    "your_new_program.json"
  ]
}
```

## JSON Schema Requirements

Each program JSON must follow this structure:

```json
{
  "program": {
    "id": "unique_program_id",
    "title": "Program Title",
    "subtitle": "Category • Type",
    "category": "strength|running|mobility|recovery",
    "coverImageURL": "image_name.jpg",
    "totalDays": 4,
    "isActive": true
  },
  "workoutDays": [...],
  "exercises": [...]
}
```

### ID Rules

- All IDs must be **stable and unique**
- Program IDs: `prog_<name>_<number>`
- Workout Day IDs: `day_<type>_<number>`
- Exercise IDs: `ex_<day>_<name>`
- Set IDs: `ex_<day>_<name>_s<number>`

## Progress Storage

Progress is stored in UserDefaults with keys: `progress_<programId>`

The storage structure includes:
- `WorkoutDayCompletion`: Tracks completed workout days
- `ExerciseSetLog`: Tracks completed sets with reps/weight

To migrate to Firebase later, implement `ProgressStoreProtocol` with Firebase backend.

## Key Features

- ✅ Load programs from local JSON files
- ✅ Navigate: Programs → Days → Workout Detail → Active Workout
- ✅ Track set completion and workout progress
- ✅ Persist progress across app launches
- ✅ Dark green theme matching design screenshots

## Dependencies

- SwiftUI (built-in)
- Foundation (Codable, UserDefaults)
- Swift Concurrency (async/await)

No external dependencies required.

## Running the App

1. Open `BuildWithin.xcodeproj` in Xcode
2. Select a simulator or device
3. Build and run (⌘R)

The app will automatically load programs from `Resources/Programs/` on launch.
