# AGENTS.md — Flutter Project Instructions

These rules are mandatory for every feature, bug fix, refactor, and code modification. Read and follow them before inspecting or changing code.

## 1. Mandatory First Steps

Before implementing any task:

1. Read this file and `.antigravity/style_guide.md`.
2. Inspect the relevant feature, existing architecture, providers, repositories, models, and reusable widgets.
3. Check `pubspec.yaml` for the package name, dependencies, and supported SDK versions.
4. Understand the existing behavior and identify the smallest safe change.
5. Follow established project conventions. Do not invent APIs, files, or backend behavior.

Do not modify unrelated code or overwrite existing user changes.

## 2. Architecture and Folder Structure

Every feature must follow this structure:

```text
lib/feature/<feature_name>/
├── logic/
│   ├── models/
│   ├── providers/
│   └── repo/
└── view/
    ├── screens/
    └── widgets/
```

Responsibilities:

- `models/`: Typed data models, serialization, and mapping.
- `providers/`: State management and business workflow orchestration.
- `repo/`: APIs, Firebase, databases, local storage, and data access.
- `screens/`: Full pages and screen composition.
- `widgets/`: Reusable or independently meaningful UI components.

Rules:

- Keep features self-contained.
- Use `hooks_riverpod` for state management.
- Keep data access inside repositories.
- UI must access application state through providers, not repositories directly.
- Providers must depend on repositories for data-access operations.
- Repositories must not depend on UI or `BuildContext`.
- Do not introduce unnecessary `domain/`, `use_cases/`, service layers, or global feature-specific folders.
- Shared components are allowed when genuinely reused across features.
- Do not introduce new architecture patterns without a clear need and approval.

## 3. Widget Rules — Strict

### Never Create Custom Widget-Building Functions

**NEVER create custom functions or methods returning `Widget`, `List<Widget>`, or other widget collections to construct, extract, or organize UI.**

This applies to public and private methods, including methods inside screen classes.

Forbidden:

```dart
Widget _buildHeader() {
  return const Text('Welcome');
}

Widget buildContent() {
  return const Center(child: Text('Content'));
}

List<Widget> buildItems() {
  return items.map((item) => Text(item)).toList();
}
```

Required: Extract meaningful UI into dedicated widget classes.

```dart
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Welcome');
  }
}
```

Use the widget directly:

```dart
const HeaderWidget()
```

### Choose the Correct Widget Type

- `StatelessWidget`: Default for UI without its own mutable state, Hooks, or Riverpod access.
- `StatefulWidget`: For local mutable state or lifecycle requirements.
- `HookConsumerWidget`: When Riverpod access through `ref`, Flutter Hooks, or both is required.
- `ConsumerWidget`: When Riverpod access is needed without Hooks and this fits project conventions.

Do not force every widget to use `HookConsumerWidget`.

### Allowed Exceptions

The prohibition on custom widget-building functions does not prohibit:

- The required `Widget build(BuildContext context)` override.
- Flutter API callbacks such as `ListView.builder`'s `itemBuilder`.
- Required builder callbacks in `LayoutBuilder`, `FutureBuilder`, `StreamBuilder`, and `AnimatedBuilder`.
- Other callbacks whose return types are defined by Flutter APIs.
- Functions returning non-UI values, including models, strings, booleans, and calculations.

Do not create custom builder functions merely because Flutter provides builder APIs.

### Widget Quality

- Extract meaningful UI sections into focused widget classes.
- Do not create a separate widget for every trivial expression.
- Prefer `const` constructors and widgets wherever possible.
- Avoid huge `build()` methods, deeply nested UI, and meaningless wrapper widgets.
- Keep business logic out of widget classes.
- Use `BuildContext` safely after asynchronous operations.
- Reuse existing components before creating new ones.

## 4. State Management and Dependencies

Use `hooks_riverpod` exclusively unless explicitly authorized otherwise.

- Place feature providers in `logic/providers/`.
- Use appropriate provider types, including `Notifier` and `AsyncNotifier`, where suitable.
- Handle asynchronous state using `AsyncValue` and the existing project conventions.
- Handle loading, error, empty, and success states.
- Avoid duplicated state, unnecessary invalidations, and unrelated rebuilds.
- Use existing provider-based dependency injection.
- Never access Firebase or external APIs directly from UI widgets.
- Do not introduce another state management library without approval.

Expected dependency flow:

```text
UI → Riverpod Providers → Repositories → Data Sources
```

## 5. Imports, Naming, and Code Organization

- Always use package imports for project code; never use relative imports.
- Read `pubspec.yaml` to determine the correct package name.
- Use `snake_case` for filenames and `UpperCamelCase` for classes.
- Follow existing naming conventions for models, providers, repositories, screens, and widgets.
- Remove unused imports and avoid circular dependencies.
- Keep production Dart files under approximately 300 lines whenever practical.
- Split files according to responsibility, not arbitrary line counts.
- Follow SOLID principles pragmatically without overengineering.
- Use early returns when they improve readability.
- Avoid duplicated code, magic numbers, and unexplained constants.
- Never manually edit generated files unless required by the generator.

## 6. UI, UX, and Localization

- Follow the existing theme, design system, spacing, typography, and colors.
- Reuse existing buttons, forms, dialogs, cards, and other shared components.
- Use the existing localization mechanism for user-facing text.
- Avoid hardcoded strings when localization is supported.
- Support appropriate loading, error, empty, and success states.
- Consider accessibility, safe areas, keyboard behavior, scrolling, and different screen sizes.
- Preserve existing user flows unless the task requires a change.
- Do not redesign unrelated screens.

## 7. Repositories, Errors, and Security

- Keep networking, Firebase operations, and persistent storage inside repositories.
- Use typed models and follow existing serialization conventions.
- Validate unexpected or malformed data where appropriate.
- Never silently swallow exceptions.
- Show user-friendly errors while preserving useful diagnostic information.
- Never expose secrets, credentials, tokens, or internal stack traces.
- Prevent duplicate submissions when necessary.
- Dispose of owned controllers, subscriptions, and listeners appropriately.
- Never hardcode secrets or private keys in source code.

## 8. Performance

- Prefer `const` widgets wherever possible.
- Never perform API calls or other side effects inside `build()`.
- Avoid expensive repeated parsing, sorting, filtering, or calculations during rebuilds.
- Use providers or non-UI helpers for appropriate computations.
- Use lazy lists and pagination for large datasets when appropriate.
- Minimize unnecessary rebuilds and duplicated state.
- Optimize based on actual needs; avoid speculative complexity.

## 9. Mandatory Feature Workflow

For substantial features, follow these phases sequentially. Use actual subagents only when supported; otherwise, perform the phases yourself.

### Phase 1 — Planner

- Understand requirements and acceptance criteria.
- Inspect relevant code and dependencies.
- Identify affected features and potential regressions.

### Phase 2 — Architect

- Determine files to create or modify.
- Define model, repository, provider, and widget responsibilities.
- Identify reusable components and verify dependency flow.
- Prefer the simplest implementation that fits the architecture.

### Phase 3 — Logic

- Implement models, repositories, and providers in the correct folders.
- Handle asynchronous states and errors.
- Add or update relevant tests.

### Phase 4 — UI and Validation

- Implement screens and dedicated widget classes.
- Never create custom UI-building functions returning `Widget` or `List<Widget>`.
- Handle loading, error, empty, and data states.
- Run applicable formatting, analysis, and tests.
- Review the final diff.

For small fixes, apply the same principles without unnecessary planning documents or extra ceremony.

## 10. Testing and Completion

Select tests appropriate to the change:

- Unit tests for business logic, models, and repositories.
- Provider tests for state transitions and asynchronous behavior.
- Widget tests for UI behavior and interactions.
- Integration tests when validating multiple connected components.

When possible, run:

```bash
dart format lib test
flutter analyze
flutter test
```

Adapt commands to the project's actual structure and changed files.

Before completing any task:

1. Review the final diff.
2. Confirm that architecture and import rules are respected.
3. Check that no prohibited custom widget-building functions were introduced.
4. Run applicable tests and checks.
5. Report what changed, which checks passed, and anything that could not be verified.

Never claim that a command or test passed unless it actually ran successfully.

## 11. Dependencies and Change Safety

- Inspect existing dependencies before adding packages.
- Do not upgrade unrelated packages or SDK versions.
- Do not change signing, permissions, identifiers, deployment settings, or environment configuration without a task-related reason.
- Do not discard user changes or execute destructive Git commands without explicit authorization.
- Preserve existing behavior unless the task requires changing it.
- Ask for clarification only when an essential requirement cannot be reliably inferred.

## Final Principle

**Follow the existing architecture. Prefer dedicated widget classes over custom functions returning widget trees. Keep changes focused, simple, testable, and maintainable. Never add complexity without a concrete reason.**