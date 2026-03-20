# GEMINI.md

## Project Overview
**Gif Hunter** is a high-performance, Flutter-based web application designed for searching, viewing, and sharing animated GIFs. Leveraging the **Giphy API**, the project focuses on delivering robust results without over-engineering, emphasizing a frictionless user experience.

- **Repository:** `gif-hunter`
- **Version:** `1.0.0` (Strictly follows **Semantic Versioning**: MAJOR.MINOR.PATCH)

### Core Technologies
- **Framework:** Flutter (Dart) - targeting Web.
- **HTTP Client:** `dio` for robust API requests and interceptors.
- **State Management:** Standard `StatefulWidget` (MVP-first approach), with clear separation of UI and data fetching logic.
- **Sharing:** `share` package for social media integration (Telegram, Facebook, WhatsApp).
- **Image Handling:** `transparent_image` for smooth, optimized loading transitions.
- **CI/CD:** GitHub Actions for automated web builds and deployment to GitHub Pages.
- **Containerization:** Docker for a consistent, isolated local development environment.

---

## Architecture & Environment

The project follows a standard but strictly organized Flutter directory structure to separate concerns:
- `lib/main.dart`: Application entry point, theme configuration, and environment initialization.
- `lib/ui/views/`: Contains the minimalist UI components.
    - `home.view.dart`: Main search interface, high-density trending GIF grid, and state-based pagination logic.
    - `gif.view.dart`: Detailed modal-like view for a selected GIF with sharing options.
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
