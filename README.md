# Recipe-iOS-App

### Summary: Include screen shots or a video of your app highlighting its features
<img src="https://github.com/SamuelFolledo/Recipe-iOS-App/blob/main/static%20files/demos/Recipe%20Demo.gif">

##### Features
- Shows recipe list and its details side by side on landscape mode, and shows recipe list or details as a sheet on portrait mode
- Caches seen recipes and images when loaded using a generic `DataCache` and `CacheManager` to manage cached recipes and images  
- Fetch/cache recipe's small images on list when item is shown and fetch/cache large image when showing recipe's details
- Show cached recipes when there is no internet, and merge recipe data when internet is available
- Search and/or sort recipes by name or cuisine
- Change endpoints and sort by using settings button


### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
- **Generic caching system for seen images and recipes using DataCache**: To optimize performance and reduce network usage, I implemented a reusable disk cache for images and recipe data.

- **Supporting various screen sizes (side-by-side look on regular horizontal size classes)**: I prioritized adaptive layouts to ensure a great user experience on both iPhone and iPad, using NavigationSplitView for regular size classes.

- **SwiftUI and MVVM architecture**: I focused on using modern SwiftUI patterns and a clear MVVM separation to make the codebase maintainable and scalable.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
**Total time spent**: 8–10 hours
**Time allocation**:
- Planning: ~1 hour
- UI/UX design and layout: ~3 hours
- Implementing and testing caching: ~2 hours
- Networking and data modeling: ~2 hours
- Debugging, code cleanup, and documentation: ~1–2 hours

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
- **Recipe object storage**: I chose to store Recipe objects based on their endpoint source, which can result in duplicate Recipe objects if the same recipe appears from multiple sources. This simplifies caching logic but may increase storage usage.

- **Caching simplicity over advanced management**: The cache does not track total size or implement eviction policies, trading off long-term storage management for simplicity and speed of implementation.

- **Limited localization and accessibility**: I decided not to implement translations or advanced accessibility features to focus on core app functionality within the project time constraints.  

### Weakest Part of the Project: What do you think is the weakest part of your project?
- **RecipeDetailView UI**: The detail view's interface could be improved with richer visuals and better layout.

- **Testing approach**: My use of Apple’s new Testing framework was limited, and more comprehensive tests could be added.

- **Cache management**: The caching system does not currently track total cache size, remove old items, or respond to system low disk space, which could lead to excessive storage usage over time.

- **Accessibility and localization**: The app currently lacks accessibility optimizations and localization support.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
- **State Synchronization Across Orientations**: Managing navigation state between portrait `NavigationStack` and landscape `NavigationSplitView` modes presents challenges. Currently, when switching from portrait to landscape, the app does not automatically scroll to or highlight the previously focused recipe. With more time, I would implement seamless state restoration and synchronization so that the selected recipe remains in focus regardless of device orientation changes, providing a smoother and more consistent user experience.
