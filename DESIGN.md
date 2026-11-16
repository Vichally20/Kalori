# Kalori Design System

> **Modern Minimalism, data-first.** Kalori is a conversational calorie tracker for Nigerian users. The UI should feel calm, clinical-but-friendly, and get out of the way of the numbers. One bold number per screen, soft white cards on a cool blue-white canvas, green for "you're doing fine".

This document is the source of truth referenced by `lib/core/theme/*`. Tokens here map 1:1 to `KaloriColors`, `KaloriTypography`, `KaloriSpacing`, and `KaloriRadius`. When code and this file disagree, fix one of them; don't let them drift.

---

## 1. Principles

1. **Data first.** The calorie number is the hero. Use `display-num` for exactly one figure per screen.
2. **Conversation over forms.** Logging happens by typing or speaking naturally. Prefer a chat input over a form with fields.
3. **Calm surfaces, loud status.** Surfaces stay neutral (white / blue-white). Color is reserved for status (on track, warning, over) and macro identity.
4. **Rounded and soft.** Large radii (16 to 24px), 1px slate borders, very soft shadows. No hard drop shadows, no sharp corners on interactive elements.
5. **Thumb-reachable.** Primary actions live at the bottom (floating input bar, bottom nav). Minimum touch target is 44 x 44.

---

## 2. Color

### 2.1 Brand and semantic

| Token | Hex | Use |
|---|---|---|
| `successGreen` | `#10B981` | Brand. Primary buttons, active nav pill, calorie ring progress, user chat bubble, "ON TRACK" badge |
| `primary` | `#006C49` | Deep green. Links ("VIEW ALL"), selected filter pill, send button on Log, unread accents |
| `inversePrimary` | `#4EDEA3` | Accent text on dark surfaces (e.g. "TIP OF THE DAY") |
| `primaryFixed` | `#6FFBBE` | Avatar ring |
| `warningOrange` | `#F59E0B` | Approaching daily limit |
| `error` | `#BA1A1A` | Over limit, destructive actions, notification count badge |
| `neutralSlate` | `#334155` | Default body text |
| `borderSlate` | `#E2E8F0` | 1px borders on cards, inputs, nav bar top edge |
| `lightSlate` | `#F8FAFC` | Alternate canvas tint |
| `cardShadow` | `rgba(51,65,85,0.08)` | The only card shadow color |

### 2.2 Surfaces (Material 3 roles)

| Token | Hex | Level / use |
|---|---|---|
| `background` / `surface` | `#F8F9FF` | Level 0: app canvas |
| `surfaceContainerLowest` | `#FFFFFF` | Level 1: cards, nav bar, input bars, AI chat bubble |
| `surfaceContainerLow` | `#EFF4FF` | Grouping wells (Recent Logs container), unread notification, input fill, food icon tile |
| `surfaceContainer` | `#E6EEFF` | Calorie ring track |
| `surfaceContainerHigh` | `#DDE9FF` | Icon buttons (bell), unselected filter pills, collapse chevrons |
| `surfaceContainerHighest` | `#D5E3FD` | Avatar fill, read-state action button |
| `inverseSurface` | `#233144` | Dark feature card (Tip of the Day) |
| `onSurface` | `#0D1C2F` | Headings, numbers, primary text |
| `onSurfaceVariant` | `#3C4A42` | Labels inside cards (CARBS, PROTEIN) |
| `outline` | `#6C7A71` | Hints, secondary metadata, inactive nav |
| `outlineVariant` | `#BBCABF` | Muted text on dark cards, dividers |

### 2.3 Macro identity

Macros always use the same hue everywhere (ring card bars, meal breakdown tiles, charts).

| Macro | Foreground | Tile background | Icon |
|---|---|---|---|
| Carbs | `tertiary` `#005AC2` | `#EFF4FF` | `water_drop_outlined` |
| Protein | `primary` `#006C49` | `#F1F5F9` (+1.5px primary border when highlighted) | `fitness_center_outlined` |
| Fat | `secondary` `#855300` | `#FEF3C7` | `water_drop` |

Quick stats use: Eaten = `primary` + `restaurant_outlined`, Burned = `secondary` + `local_fire_department_outlined`, Net = `tertiary` + `balance_outlined`.

### 2.4 Category / status containers

Pair a `*Container` background with its `on*Container` foreground for icon badges, toasts and chips.

| Meaning | Container | On-container |
|---|---|---|
| Success / reminder | `primaryContainer` `#10B981` | `onPrimaryContainer` `#00422B` |
| Achievement / warning | `secondaryContainer` `#FEA619` | `onSecondaryContainer` `#684000` |
| Insight / info | `tertiaryContainer` `#71A1FF` | `onTertiaryContainer` `#00367A` |
| Error | `errorContainer` `#FFDAD6` | `onErrorContainer` `#93000A` |
| System | `surfaceContainerHighest` | `onSurfaceVariant` |
| Social | `#E8DEFF` | `#381E72` *(not yet a token)* |

### 2.5 Day status

A day's total compared with the calorie goal gets one status. The same colors are used for chart bars, calendar cells and badges.

| Status | Rule | Bar / fill | Badge (bg / text) |
|---|---|---|---|
| ON TRACK | under 90% of goal | `successGreen` | `primaryContainer` / `onPrimaryContainer` |
| CLOSE | 90% to 100% | `warningOrange` | `secondaryContainer` / `onSecondaryContainer` |
| OVER | over 100% (show `+N`) | `error` | `errorContainer` / `onErrorContainer` |
| MISSED | nothing logged | `surfaceContainerHigh` stub, dashed `outlineVariant` border | none; show a "LOG THIS DAY" action |
| IN PROGRESS | today | `successGreen` dashed outline on `#E6F8F0` | `#E6F8F0` / `primary` |

Always print the number next to the color (bar labels, `1,620 / 2,000`) so the status never depends on hue alone.

### 2.6 Dark mode

Not implemented. Only `KaloriTheme.light` exists. When added, map the same role names; never hardcode hex in widgets so the switch is free.

---

## 3. Typography

Family: **Inter**. All sizes in logical px.

| Token | Size / line | Weight | Tracking | Use |
|---|---|---|---|---|
| `display-num` | 48 / 56 | 700 | -0.02em | The single hero number (calories remaining) |
| `headline-lg` | 30 / 38 | 700 | -0.01em | Large screen titles (tablet / onboarding) |
| `headline-lg-mobile` | 24 / 32 | 700 | 0 | Stat values (750, 42g) |
| `headline-md` | 20 / 28 | 600 | 0 | Section titles, card titles, app bar titles, date header (as 700) |
| `body-lg` | 16 / 24 | 400 | 0 | Body, list titles (as 600), inputs, chat text |
| `body-sm` | 14 / 20 | 400 | 0 | Subtitles, metadata, descriptions |
| `label-caps` | 12 / 16 | 700 | +0.05em | ALL CAPS labels: REMAINING, CARBS, VIEW ALL, nav labels, chips |

Rules:
- Numbers use `onSurface`; labels above numbers use `label-caps` in `outline` or `onSurfaceVariant`.
- Never put two `display-num` values on one screen.
- `label-caps` is always uppercase in the string itself.

> **Known gap:** `pubspec.yaml` has no `fonts:` entry, so Inter is not bundled and Flutter falls back to the platform font. Add Inter (or `google_fonts`) before visual QA.

---

## 4. Spacing and layout

Base unit is 4.

| Token | px | Typical use |
|---|---|---|
| `base` | 4 | Icon-to-text micro gaps |
| `xs` | 8 | Chip gaps, between label and value |
| `sm` | 12 | Between list cards |
| `md` | 16 | Card padding, between stacked cards |
| `lg` | 24 | Between sections, large card padding |
| `xl` | 32 | Bottom list padding |
| `containerMargin` | 20 | Screen horizontal padding |
| `gutter` | 12 | Between columns (quick stats, macro tiles) |

Screen scaffold:
- Horizontal padding `20`, top padding `16` inside `SafeArea`.
- Scrollable content ends with ~90px bottom spacer when a floating bar overlaps it.
- Header row height 44 (avatar / icon button size).

---

## 5. Shape

| Token | px | Use |
|---|---|---|
| `sm` | 4 | Small inline buttons in toasts, "VIEW ALL" ink |
| `default` | 8 | Chips, notification action buttons, dialog buttons |
| `md` | 12 | Icon tiles (48px food icon, 42px category badge) |
| `lg` | 16 | Standard cards, stat tiles, macro tiles, toasts, dialogs |
| `xl` | 24 | Grouping wells, meal breakdown card, primary buttons, inputs |
| `full` | 9999 | Pills: badges, filter chips, input bar on Log, nav active pill (16 on a 32-high pill) |

---

## 6. Elevation

Kalori uses **borders first, shadows second**.

| Level | Surface | Border | Shadow |
|---|---|---|---|
| 0 | `background` | none | none |
| 1 (card) | `#FFFFFF` | 1px `borderSlate` | `0 4 20 cardShadow` |
| 1 (list item in well) | `#FFFFFF` | none | `0 2 12 cardShadow` |
| 2 (floating) | `#FFFFFF` | 1px `borderSlate` | `0 8 24 rgba(13,28,47,0.12)` |
| Feature | `inverseSurface` | none | `0 6 20 cardShadow` |

---

## 7. Components

### Navigation
- **Bottom nav (`KaloriBottomNavBar`)**: 4 tabs, Home / Log / History / Profile. White bar, 1px top border. Active item: 56x32 `successGreen` pill behind a filled icon in `onPrimaryContainer`, label `label-caps` in `onSurface`. Inactive: outlined icon and label in `outline`. 200ms transitions.
- **Screen header (tabs)**: left = calendar icon (`successGreen`) + date in `headline-md` 700; right = 44px bell button (`surfaceContainerHigh` circle, red count badge) + 44px avatar with 2.5px `primaryFixed` ring.
- **App bar (pushed screens)**: `surface` background, no elevation, back arrow, left-aligned `headline-md` 700 title, text-button actions in `primary`.

### Data display
- **Calorie ring card (`GenericCalorieRingWidget`)**: Level 1 card. 230px ring, 20px stroke, round caps, starts at 12 o'clock. Center: `REMAINING` label, `display-num` value, `kcal` unit. Pill badge overlapping the ring bottom (`ON TRACK` with check icon). Divider, then 3 macro columns: label, 6px rounded progress bar, value.
- **Quick stats row (`GenericQuickStatsRow`)**: 3 equal Level 1 tiles: icon, `label-caps`, `headline-lg-mobile` value.
- **Tip card**: `inverseSurface` card, `label-caps` eyebrow in `inversePrimary`, `headline-md` white headline, `body-sm` in `outlineVariant`.
- **Recent logs well**: `surfaceContainerLow` container (r24, padding 20) holding white list cards (r16). Each row: 48px icon tile (r12), title `body-lg` 600, subtitle `body-sm` outline, trailing kcal `body-lg` 700.
- **Meal breakdown card**: r24 Level 1. Expanded: header (restaurant icon in `secondary`, title, `LOGGED` pill, collapse chevron), item rows with dividers (pending = spinner, failed = red retry), then 3 macro tiles. Collapsed: single row "Meal Breakdown • N kcal" + expand chevron.

### Input
- **Floating chat input (Home)**: Level 2, r28, mic icon, borderless field "What did you eat?", 48px `successGreen` send button (r20, `send` icon).
- **Log input bar**: pill (`full`), add icon, field "What else did you eat?", 40px `primary` send button (r14, `arrow_upward`).
- **Suggestion chips**: `#E2E8F0` pill, `label-caps` "ADD BLACK COFFEE", wrap with 8/10 spacing.
- **Filter pills**: selected = `primary` bg / white text 600; unselected = `surfaceContainerHigh` / `onSurfaceVariant`. Optional count bubble.

### Conversation
- **User bubble**: right aligned, `successGreen` fill, `onSurface` text 500, radii 18 except top-right 4, 48px left inset.
- **AI bubble**: left aligned, white, 1px border, faint shadow, radii 18 except top-left 4, 48px right inset.
- **AI thinking indicator**: 3 orbiting dots with comet trails around a pulsing core, hue-shifted per dot; optional label with cycling ellipsis.

### Feedback
- **Toast (`KaloriToast`)**: top snackbar, white r16 card with 1.5px tinted border, 42px animated icon tile (pop-in; error shakes; info spins), title 15/700, message 13, optional action chip, auto-dismiss progress bar.
- **Notification card**: r16. Unread = `surfaceContainerLow` fill, 1.5px primary border at 40%, primary timestamp, 10px green dot, filled `primary` action button. Read = white, faint border, muted action button. Swipe left to delete (red container background).
- **Empty state**: 80px `surfaceContainerHigh` circle with 40px `primary` icon, 18/700 title, 14 body centered, 40px side padding.
- **Confirm dialog**: white r16, `headline-md` 700 title, `body-sm` body, text Cancel + red filled destructive button (r8).

### Buttons (theme defaults)
- **Primary**: `successGreen`, white `headline-md` label, min height 48, r24, no elevation.
- **Secondary**: outlined, `borderSlate` 1px, `neutralSlate` 600 label, r24.

---

## 8. Iconography

Material Icons, **outlined** by default, **filled** for active/selected state. Sizes: 24 standard, 22 in macro tiles and category badges, 18 to 20 in inline actions, 14 to 16 inside pills. Food icons come from `FoodIconHelper` keyword matching and sit on a 48px `surfaceContainerLow` tile.

---

## 9. Motion

| What | Duration | Curve |
|---|---|---|
| Nav pill, filter pill, card state | 200 to 250ms | `easeInOut` |
| Toast enter | 350ms slide | default |
| Toast icon | 1100ms pop (0 to 1.25 to 0.95 to 1) | `easeOutCubic` / `elasticOut` |
| AI thinking | 2400ms orbit, 1200ms pulse, 3000ms glow | linear / reverse repeat |

Motion confirms state; it never delays it.

---

## 10. Voice and content

- Friendly, brief, encouraging. Emoji allowed in notification titles only (🥗 🔥 💡 💧 📊).
- Use local foods in examples: jollof rice, plantain, moi moi, eba and egusi, akara, suya.
- Numbers: thousands separator (`1,250`), units lowercase (`kcal`, `g`).
- Status words in caps badges: `ON TRACK`, `LOGGED`, `OVER`, `CLOSE`.

---

## 11. Screen inventory

| Screen | Route | Status |
|---|---|---|
| Home dashboard | `/home` (tab 0) | Built |
| Log (AI chat) | `/log` (tab 1) | Built |
| History | `/history` (tab 2), `/history/day` | Built: Month (default), Week, Day detail (see §13) |
| Profile | `/profile` (tab 3) | Built (see §14) |
| Onboarding | `/onboarding` (initial route until a profile exists) | Built: Welcome + 4 steps + Your plan; steps reopen as edit screens from Profile (see §14) |
| Notifications | `/notifications` | Built |
| Settings, Account, Subscriptions, Help & Feedback, Privacy, Terms, Integrations, Insights, Water Tracker, Food Library | declared in `AppRoutes` | Not built |

---

## 12. Known inconsistencies to clean up

1. Log widgets hardcode hex (`0xFF855300`, `0xFF006C49`, `0xFFE6F8F0`, `0xFFF1F5F9`, `0xFFFEF3C7`, `0xFFE2E8F0`) instead of tokens. Promote the tile backgrounds to `macroCarbsBg` / `macroProteinBg` / `macroFatBg` and `successTint`.
2. Two send buttons: Home uses 48px `successGreen` r20 `send`; Log uses 40px `primary` r14 `arrow_upward`. Pick one.
3. Two input bar shapes: Home r28, Log `full`.
4. Header date is hardcoded "Today, Oct 24".
5. Social notification colors are not tokens.
6. Inter font is not bundled.
7. Several widgets use raw `TextStyle(fontSize: 13)` instead of a type token; add a `label-md` (13/600) token if that size is needed.

---

## 13. History

Built in `lib/features/history/`. **Month is the default view**; tapping any past or current day (calendar cell, week bar or day card) opens Day detail at `/history/day`. Future days can't be tapped.

**Week view.** Screen header with "History" in `headline-lg-mobile`, then a Month / Week segmented control (pill track `surfaceContainerHigh`, selected segment white with a soft shadow). Range stepper with 44px round buttons; "next" is disabled on the current week.
- **Summary card:** `DAILY AVERAGE` with the screen's one `display-num`, the difference from goal, and a trend pill. Below it, a 7-day bar chart: bars up to 28px wide, radius 8/8/4/4, a value label above each bar, a dashed goal line labelled `GOAL 2,000`, and day initials with today in an inverted pill. A legend sits under a divider.
- **Average macros card:** three columns using the macro colors, each showing `value / goal`.
- **Habit tiles:** LOGGED x/7, STREAK, ON TRACK x/full days.
- **Day list:** one card per day with the day name, date and meal count, `kcal / goal`, a status badge and a 6px progress bar. A day expands in place to show one row per meal, plus "VIEW DAY DETAILS". Missed days use a dashed card with "LOG THIS DAY".

**Month view.** Month stepper and summary (average, days logged, a stacked status bar with counts), then a calendar of 40px day circles filled by status: today has a 2px `onSurface` ring, missed days a dashed outline, future days plain text. Current and best streak tiles go underneath.

**Day detail (pushed route, no bottom nav).** App bar shows the full date with previous/next day arrows. Then:
- `GenericCalorieRingWidget` at `ringSize: 180`, `centerLabel: 'EATEN'`, unit `of 2,000 kcal`, with the macro row.
- A dark AI "DAY INSIGHT" card (same style as Tip of the Day).
- Meals grouped as `BREAKFAST · 8:10 AM` with a kcal subtotal, each a white r16 list of 60px item rows.
- A secondary "Add food to this day" button.

**Data:** streak = consecutive days with at least one log. Averages leave out today and missed days.

---

## 14. Onboarding & Profile

Built in `lib/features/onboarding/` and `lib/features/profile/`. The profile is stored as JSON in the app documents folder; `UserProfileService` (registered in `main()`) exposes it and the derived `DailyTargets` to History and Profile. The welcome hero plays `assets/lottie/kalori_wordmark.json` (regenerate with `python tool/lottie/make_wordmark.py assets/lottie/kalori_wordmark.json`).

### Onboarding
Shown once, before Home, when no profile is saved. No bottom nav. Primary CTA pinned to the bottom (52px, r24, `successGreen`).

- **Step header:** back arrow, a 4-segment progress bar (6px pills, done = `successGreen`, to do = `surfaceContainerHigh`) and `N OF 4` in `label-caps`.
- **Choice cards:** white r16 with a 1px border. Selected = `successTint` fill, 1.5px `primary` border and a filled radio dot. Every choice is a real radio (`role="radio"`).
- **Inputs:** r24, `surfaceContainerLow` fill, 52px tall. Focused = 1.5px `primary` border. Big numeric values (height, weight) use `display-num` with a unit toggle pill (cm / ft·in, kg / lb).

| Step | Collects | Notes |
|---|---|---|
| 0 Welcome | nothing | Lottie hero: "KALORI" wordmark (letters rise in, the O is a calorie ring that fills, soft green glow, 3.2s loop; static under reduce-motion). Title "Track what you eat and build your body.", "Get started" |
| 1 About you | name, sex, age | Sex is explained as a formula input only |
| 2 Your body | height, weight | Ruler sliders; "stored only on this phone" |
| 3 Activity | multiplier | Sitting 1.2, Light 1.375, Moderate 1.55, Very 1.725, Athlete 1.9 |
| 4 Goal | lose / maintain / gain, target weight, pace | Gentle 0.25, Steady 0.5 (suggested), Faster 0.75 kg/week; live preview of kcal and date |
| 5 Your plan | — | Target ring split by macro, "How we worked it out" breakdown, timeline, "Start logging" |

**Calculation** (`CalculateTDEE`, Mifflin-St Jeor): BMR × activity = TDEE. Pace sets the deficit or surplus (7,700 kcal per kg ÷ 7, so 0.5 kg/week ≈ 550 kcal/day). Floor: 1,500 kcal (male) / 1,200 kcal (female). Macros: protein 1.6 g per kg body weight, fat 25% of calories, carbs the rest. These replace the fixed values in `NutritionGoals`.

### Profile (tab 3)
In order, top to bottom:
1. Identity row: a 64px initials avatar with a `primaryFixed` ring, the name, "Logging since…" and an edit button.
2. Three habit tiles: streak, days logged, % of days on track.
3. Weight card: current weight (36px), the change since the start, a sparkline, a start → goal progress bar and "Log today's weight".
4. A dark `inverseSurface` **Daily targets** card (kcal + macros) with EDIT.
5. Grouped lists (white r16, 52px rows, chevrons): **Body & goal** (opens the matching onboarding step as an edit screen), **App** (meal-reminder switch, water tracker, health apps) and **Support** (help, privacy, terms).
6. A red text "Reset all data" button, then the version line.
