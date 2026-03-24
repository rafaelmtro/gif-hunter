# GEMINI.md

## Project Overview
**Gif Hunter** is a high-performance, Flutter-based web application designed for searching, viewing, and sharing animated GIFs. Leveraging the **Giphy API**, the project focuses on delivering robust results without over-engineering, emphasizing a frictionless user experience.

- **Repository:** `gif-hunter`
- **Version:** `2.0.1` (Strictly follows **Semantic Versioning**: MAJOR.MINOR.PATCH)

### Core Technologies
- **Framework:** Flutter (Dart) - targeting Web.
- **HTTP Client:** `dio` for robust API requests and interceptors.
- **State Management:** **Riverpod** (`flutter_riverpod`) with `StateNotifier` for clean, scalable state handling, separating UI from business logic.
- **Sharing:** `share` package for social media integration (Telegram, Facebook, WhatsApp).
- **Image Handling:** `transparent_image` for smooth, optimized loading transitions.
- **CI/CD:** GitHub Actions for automated web builds and deployment to GitHub Pages. Uses latest stable versions of `actions/checkout@v4`, `actions/upload-artifact@v4`, and `actions/download-artifact@v4` to ensure reliable builds. The CI pipeline includes a step to **dynamically create the `.env` file** from GitHub Secrets (e.g., `GIPHY_API_KEY`) to prevent build failures due to missing environment assets.
- **Containerization:** Docker for a consistent, isolated local development environment.

---

## Architecture & Environment

The project follows a standard but strictly organized Flutter directory structure to separate concerns:
- `lib/main.dart`: Application entry point, theme configuration, and environment initialization.
- `lib/ui/views/`: Contains the minimalist UI components for top-level views.
    - `home.view.dart`: Main search interface.
- `lib/ui/components/`: Modular, reusable UI components extracted from views to ensure clean code and better maintainability.
    - `gif_item.dart`: Individual GIF display with hover effects and actions.
    - `gif_actions_overlay.dart`: Hover/Overlay actions for GIFs (favorite, copy).
    - `gif_detail_modal.dart`: Full-screen/Dialog detail view for a specific GIF.
    - `favorites_modal.dart`: Gallery view for saved GIFs.
    - `skeleton_loading.dart`: Shimmer effect for initial data fetching.
    - `trending_tags_sidebar.dart`: Sidebar for browsing trending search terms.
- `lib/providers/`: State management using Riverpod.
    - `giphy_notifier.dart`: Manages the state of GIF searches, trending, and pagination.
- `lib/services/`: Data fetching and API integration layers.
    - `giphy.service.dart`: Encapsulates Giphy API logic.
- `images/`: Local assets.

**Environment Configuration & Security:**
- All sensitive information (e.g., the Giphy API key) and environment-specific variables **MUST** be stored in a `.env` file at the root of the project.
- **Implementation:** The project uses `flutter_dotenv` to load environment variables at runtime. Initialization is performed in `main.dart` before `runApp()`.
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
    - **Responsive Design (Desktop & Mobile):** Adaptive layout that provides an optimal experience across all screen sizes. 
        - **Adaptive Sidebars:** On Desktop, "Favorites" and "Trending Tags" are displayed as fixed sidebars. On Mobile, they are elegantly moved into a slide-out Navigation Drawer accessed via a hamburger menu, featuring a dedicated close button for easy navigation back to the feed.
        - **Dynamic Grid Layout:** High-density grid automatically adjusts its column count (e.g., 5 columns on Desktop, 2 columns on Mobile) to maintain content density and readability. On very small screens, GIF items employ optimized action button sizes and increased edge spacing to ensure rounded corners remain visible and buttons don't overlap boundaries.
        - **Persistent Header:** The header is always visible at the top, providing immediate access to the search experience. On smaller screens, the header collapses to favor a full-width search bar with an integrated search icon, ensuring maximum utility across all devices.
        - **Responsive Modals:** Dialogs (GIF details and favorites) adjust their width, height, and internal padding based on the device's screen dimensions.
    - **Debounced "Search-as-you-type":** Instantaneous and fluid search that automatically triggers API fetch after 500ms of user inactivity.
    - **Skeleton Loading States:** Custom shimmer effect in the high-density grid and trending tags sidebar provides better visual feedback that content is specifically "loading" rather than just "missing," ensuring a smooth experience for all asynchronous content.
    - **Infinite Scroll with Smart Pre-fetching & Duplicate Filter:** Automatically fetches the next set of results when the user is 80% down the current list, creating an "endless" browsing experience. This includes a robust client-side duplicate filter (by GIF ID) and correct pagination offsets for all API endpoints. This strategy utilizes `NotificationListener` and `LayoutBuilder` with `postFrameCallback` to ensure the feed is robust and responsive: it automatically triggers new fetches if screen resizing (e.g., window expansion on Desktop) reveals more of the feed or if the initial load doesn't fully fill the available viewport.
    - **Loading Indicators:** Visual feedback (CircularProgressIndicator) when loading more content during infinite scroll.
    - **One-Tap Copy to Clipboard:** Quick-access "Copy Link" button on grid items with a smooth, in-place "Copied!" overlay for immediate visual confirmation.
    - **Hover-to-Play/Preview:** Grid items show static thumbnails by default, playing animations only on hover (Web) or long-press (Mobile) to reduce visual noise.
    - **Hero Animation Stability:** Enhanced `Hero` animation reliability by implementing unique tags using a `heroTagPrefix` system. This prevents animation conflicts when identical GIFs are displayed across different views (e.g., Favorites and Search). The transition is further optimized using **Static Placeholders** and `frameBuilder` to ensure the animation remains smooth even when the high-quality animated GIF is still loading.
    - **GIF Detail Modal:** Clicking a GIF opens a compact, high-fidelity modal displaying the animation, its title, and publisher name. The modal features a seamless **Image-to-Modal Zoom Transition** and integrated action buttons (heart and copy) in the header, keeping the GIF display clear and focused. The header uses a **top-aligned layout** and limits titles to **two lines with an ellipsis** to ensure UI consistency. A **"Copied!" overlay** provides immediate visual feedback when the link is copied via the header button, matching the grid item experience. To further reduce visual clutter and prevent redundancy during transitions, action buttons for the specific GIF being viewed are **smoothly hidden** in the main grid using `AnimatedOpacity` while its modal is active.
    - **Personalized "Favorites" Gallery:** Local storage persistence (`shared_preferences`) allowing users to "heart" GIFs. A right-aligned sidebar item opens a modal gallery with a smooth grey background and "Favorite GIFs" header. Unhearting a GIF within this gallery triggers a smooth **scale-down animation** before removal, providing a more fluid and polished user experience. This animation is robustly managed using `ValueKey` and `didUpdateWidget` to prevent Flutter state reuse issues and ensure consistent grid updates.
    - **Multi-Tag Selection Box:** Dedicated section on the right displaying trending tags. Supports multi-selection with light orange "aura" backgrounds; manual search is automatically cleared when tags are selected for a clean transition.
    - **Modern Minimalist UI:** Deep black backgrounds with orange highlights, featuring rounded shapes (grid items, search bar) for a smooth visual experience and consistent screen margins. Interactive elements like the **Favorites button** and **Trending Tags** feature enhanced hover effects (orange tint backgrounds and bold text) for clear, intuitive feedback. Highlights (text selection in search bar) use a themed light orange color.
    - **Google-style Header Refactor:** App name integrated to the left of a constrained search bar (supporting line breaks). The grid starts after the header row, maintaining a dedicated horizontal offset that keeps the space below the app name clean.

---

## Development Conventions

### Version Control & Git Strategy
This project strictly follows a feature-branch workflow to maintain a stable codebase:
- **Branching Model:**
  - `master` (or `main`): Reserved strictly for production-ready code.
  - `develop`: The active development branch. All integration of new features and testing happens here.
  - `feature/<feature-name>`: Create a new branch off `develop` for every individual feature or bug fix (e.g., `feature/whatsapp-sharing`).

### Project Workflow
For every update (feature, fix, or adjustment), the following workflow must be followed:
1.  **Analyze** the requested update and the current state of the codebase.
2.  **Create** a new branch off `develop` specifically for the update.
3.  **Implement** and **Commit** the changes following the Conventional Commits pattern.
4.  **Incorporate** the update into the `develop` branch (via merge or pull request).
5.  **Delete** the temporary update branch once it has been successfully merged.

### Commit Messages
We adhere to the **Conventional Commits** pattern to maintain a readable history and allow for automated changelogs.
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
