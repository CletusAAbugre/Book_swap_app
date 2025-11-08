# BookSwap App Architecture

## System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        BookSwap Flutter App                     │
├─────────────────────────────────────────────────────────────────┤
│                     Presentation Layer                         │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐│
│  │   Auth      │ │   Browse    │ │ My Listings │ │   Chats     ││
│  │  Screens    │ │  Listings   │ │   Screen    │ │   Screen    ││
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘│
│                              │                                  │
├──────────────────────────────┼──────────────────────────────────┤
│                     State Management (Provider)                 │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐│
│  │    Auth     │ │    Book     │ │    Swap     │ │    Chat     ││
│  │  Provider   │ │  Provider   │ │  Provider   │ │  Provider   ││
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘│
│                              │                                  │
├──────────────────────────────┼──────────────────────────────────┤
│                        Service Layer                            │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐│
│  │    Auth     │ │    Book     │ │    Swap     │ │    Chat     ││
│  │   Service   │ │   Service   │ │   Service   │ │   Service   ││
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘│
│                              │                                  │
├──────────────────────────────┼──────────────────────────────────┤
│                        Data Models                              │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐│
│  │    User     │ │    Book     │ │    Swap     │ │    Chat     ││
│  │   Model     │ │   Model     │ │   Model     │ │   Model     ││
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘│
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Firebase Backend                          │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐│
│  │  Firebase   │ │  Firestore  │ │  Firebase   │ │   Cloud     ││
│  │    Auth     │ │  Database   │ │   Storage   │ │ Functions   ││
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘│
└─────────────────────────────────────────────────────────────────┘
```

## Data Flow Architecture

```
User Action → Screen → Provider → Service → Firebase → Real-time Update → Provider → Screen → UI Update
```

## Component Responsibilities

### Presentation Layer
- **Screens**: Handle user interactions and display data
- **Widgets**: Reusable UI components
- **Navigation**: Bottom navigation and routing

### State Management
- **Providers**: Manage app state using Provider pattern
- **Real-time Streams**: Listen to Firebase changes
- **State Updates**: Notify UI of data changes

### Service Layer
- **Firebase Services**: Handle all Firebase operations
- **Data Transformation**: Convert between models and Firebase data
- **Error Handling**: Manage exceptions and errors

### Data Models
- **Structured Data**: Define app data structures
- **Serialization**: Convert to/from JSON
- **Validation**: Ensure data integrity