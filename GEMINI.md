# GEMINI.md

## Project Overview
**Gif Hunter** is a high-performance, Flutter-based web application designed for searching, viewing, and sharing animated GIFs. Leveraging the **Giphy API**, the project focuses on delivering robust results without over-engineering, emphasizing a frictionless user experience.

- **Repository:** `gif-hunter`
- **Version:** `1.0.0` (Strictly follows **Semantic Versioning**: MAJOR.MINOR.PATCH)

### Core Technologies
- **Framework:** Flutter (Dart) - targeting Web.
- **HTTP Client:** `dio` for robust API requests and interceptors.
- **State Management:** **Riverpod** (`flutter_riverpod`) with `StateNotifier` for clean, scalable state handling, separating UI from business logic.
- **Sharing:** `share` package for social media integration (Telegram, Facebook, WhatsApp).
- **Image Handling:** `transparent_image` for smooth, optimized loading transitions.
- **CI/CD:** GitHub Actions for automated web builds and deployment to GitHub Pages.
- **Containerization:** Docker for a consistent, isolated local development environment.

---

## Architecture & Environment

The project follows a standard but strictly organized Flutter directory structure to separate concerns:
- `lib/main.dart`: Application entry point, theme configuration, and environment initialization.
- `lib/ui/views/`: Contains the minimalist UI components.
    - `home.view.dart`: Main search interface, high-density trending GIF grid, and Riverpod-powered pagination.
    - `gif.view.dart`: Detailed modal-like view for a selected GIF with sharing options.
- `lib/providers/`: State management using Riverpod.
    - `giphy_notifier.dart`: Manages the state of GIF searches, trending, and pagination.
- `lib/services/`: Data fetching and API integration layers.
    - `giphy.service.dart`: Encapsulates Giphy API logic.
- `images/`: Local assets.

**Environment Configuration & Security:**
- All sensitive information (e.g., the Giphy API key) and environment-specific variables **MUST** be stored in a `.env` file at the root of the project.
- **Security Rule:** NEVER commit `.env` files to version control. Always maintain an up-to-date `.env.example` file for new developers.
- **Git Authentication:** Use SSH keys for all GitHub operations. The keys are located at `~/.config/ssh/`. Ensure your local git configuration is set to use these keys.

---

## UI/UX & Design Guidelines

- **Design Philosophy:** Minimalist design with a focus on core functionality. Avoid visual clutter to ensure a smooth, frictionless user experience.
- **Color Palette:** The core theme strictly relies on a mix of **Orange and Black**. Use orange to highlight interactive elements, loading states, and primary actions against deep black structural backgrounds.
- **Interface Features:**
    - High-density grid layout for efficient browsing.
    - Smooth image loading transitions to prevent layout shifts.
    - Interactive elements with clear feedback (e.g., hover states, loading indicators).
    - **Debounced "Search-as-you-type":** Instantaneous and fluid search that automatically triggers API fetch after 500ms of user inactivity.
    - **Skeleton Loading States:** Custom shimmer effect in the high-density grid provides better visual feedback that content is specifically "loading" rather than just "missing".
    - **Infinite Scroll with Smart Pre-fetching:** Automatically fetches the next set of results when the user is 80% down the current list, creating an "endless" browsing experience.
    - **One-Tap Copy to Clipboard:** Quick-access "Copy Link" button on grid items to minimize steps for sharing GIFs.
    - **Hover-to-Play/Preview:** Grid items show static thumbnails by default, playing animations only on hover (Web) or long-press (Mobile) to reduce visual noise.
    - **Personalized "Favorites" Gallery:** Local storage persistence (`shared_preferences`) allowing users to "heart" GIFs. A right-aligned sidebar item opens a modal gallery with a smooth grey background, "Favorite GIFs" header, and prominent rounded corners. Empty states feature subtle highlighting for better visibility.
    - **Multi-Tag Selection Box:** Dedicated section on the right displaying trending tags in a clean, text-based grid (no background). Supports multi-selection with light orange "aura" backgrounds for visual feedback; tags are automatically deselected when a new manual search is typed. Aligned precisely with the top of the search results for a balanced layout.
    - **Modern Minimalist UI:** Deep black backgrounds with orange highlights, featuring rounded shapes (grid items, search bar) for a smooth visual experience and consistent screen margins. Highlights (text selection in search bar) use a themed light orange color.
    - **Google-style Header Refactor:** App name integrated to the left of a constrained search bar (supporting line breaks). The grid starts after the header row, maintaining a dedicated horizontal offset that keeps the space below the app name clean.

---

## Development Conventions

### Version Control & Git Strategy
This project strictly follows a feature-branch workflow to maintain a stable codebase:
- **Branching Model:**
  - `master` (or `main`): Reserved strictly for production-ready code.
  - `develop`: The active development branch. All integration of new features and testing happens here.
  - `feature/<feature-name>`: Create a new branch off `develop` for every individual feature or bug fix (e.g., `feature/whatsapp-sharing`).

- **Commit Messages:** We adhere to the **Conventional Commits** pattern to maintain a readable history and allow for automated changelogs.
  - *Format:* `<type>[optional scope]: <description>`
  - *Examples:*
    - `feat(ui): add infinite scrolling to home view`
    - `fix(api): resolve offset pagination bug in Giphy fetch`
    - `chore: update dio dependency to latest stable version`
    - `docs: add gemini model version`
    - `style: enforce orange and black color palette`

### Code Style & Quality
- **Strict Typing:** Avoid `dynamic` types in Dart whenever possible. Leverage strong typing for API models and state variables to prevent runtime errors.
- **Pragmatism:** MVP-first approach. Focus on delivering the end-to-end flow before over-optimizing state management or architectural patterns.
- **Testing:** Comprehensive testing is mandatory for system stability.
    - **Unit Tests:** Implemented for `GiphyService` using `http_mock_adapter` to verify API integration.
    - **Widget Tests:** Required for core UI components (e.g., ensuring the grid renders correctly, sharing buttons trigger appropriately).

---

## Building and Running

### Docker Usage (Recommended Dev Environment)
For the most consistent dev environment, the application should be built within a Docker container and exposed to `localhost`.
- **Base Image:** The project strictly uses `ghcr.io/cirruslabs/flutter:stable` to ensure a reliable and up-to-date Flutter build environment.
**Building and Running the Container:**
```bash
# Build the development image
docker build -t gif-hunter-dev .

# Run the container, mapping the port and volume
# The application will automatically start on port 8080
docker run -p 8080:8080 -v $(pwd):/app -it gif-hunter-dev
```
