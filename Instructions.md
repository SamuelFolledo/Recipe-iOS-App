# **Fetch Mobile Take Home Project**

Thank you for your interest in Fetch! This take home project reflects the kind of challenges you’ll encounter while working at Fetch.

We are looking to be delighted with what you can do and how your unique perspective can contribute to our team. Use this take home project as an opportunity to demonstrate your strengths.

# **Overview**

Your task is to build a recipe app that displays recipes from the provided API endpoint.

At a minimum, each recipe should show its name, photo, and cuisine type. You’re welcome to display additional details, add features, or sort the recipes in any way you see fit.

The app should allow users to refresh the list of recipes at any time, and you can decide how to implement this in the UI. You’re free to include any additional UI elements you think would enhance the experience. The app should consist of at least one screen displaying a list of recipes.

### **Requirements**

1. **Swift Concurrency**: Use `async`/`await` for all asynchronous operations, including API calls and image loading.
2. **No External Dependencies**: Your implementation should rely only on Apple's frameworks. Do not include third-party libraries for ui, networking, image caching, or testing.
3. **Efficient Network Usage**: Load images only when needed in the UI to avoid unnecessary bandwidth consumption. Cache images to disk to minimize repeated network requests. Implement this fully yourself without relying on any third-party solutions, `URLSession`'s HTTP default cache setup, or the `URLCache` implementation.
4. **Testing**: Include unit tests to demonstrate your approach to testing. Use your judgement to determine what should be tested and the appropriate level of coverage. Focus on testing the core logic of your app (e.g., data fetching and caching). UI and integration tests are not required for this exercise.
5. **SwiftUI**: The app's user interface must be built using SwiftUI. This is what we activly use for UI at Fetch. We expect engineers to stay up-to-date on the modern UI tooling available from Apple.

### **Endpoints**

The following JSON endpoints provide the data for your project.

- **All Recipes**: https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json

You’ll also find test endpoints to simulate various scenarios.

- **Malformed Data**: https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json
- **Empty Data**: https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json

If a recipe is malformed, your app should disregard the entire list of recipes and handle the error gracefully. If the recipes list is empty, the app should display an empty state to inform users that no recipes are available.

### **JSON Structure**

| **Key** | **Type** | **Required** | **Notes** |
| --- | --- | --- | --- |
| `cuisine` | string | yes | The cuisine of the recipe. |
| `name` | string | yes | The name of the recipe. |
| `photo_url_large` | string | no | The URL of the recipes’s full-size photo. |
| `photo_url_small` | string | no | The URL of the recipes’s small photo. Useful for list view. |
| `uuid` | string | yes | The unique identifier for the receipe. Represented as a UUID. |
| `source_url` | string | no | The URL of the recipe's original website. |
| `youtube_url` | string | no | The URL of the recipe's YouTube video. |

`{
    "recipes": [
        {
            "cuisine": "British",
            "name": "Bakewell Tart",
            "photo_url_large": "https://some.url/large.jpg",
            "photo_url_small": "https://some.url/small.jpg",
            "uuid": "eed6005f-f8c8-451f-98d0-4088e2b40eb6",
            "source_url": "https://some.url/index.html",
            "youtube_url": "https://www.youtube.com/watch?v=some.id"
        },
        ...
    ]
}`

### **Include a README**

Below is a README template to help us understand your approach and decision-making process. Please fill out the following sections as part of your submission and include the README in your project.

`### Summary: Include screen shots or a video of your app highlighting its features

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

### Weakest Part of the Project: What do you think is the weakest part of your project?

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.`

### **Submitting the Final Project**

When completed, upload your project to a public repository and submit a link to the project through Greenhouse.

# **FAQ**

### **What are you looking for?**

We want to know what production-ready code looks like to you. Imagine you are adding to an existing codebase. If you had to make some compromises or shortcuts for the sake of time be sure to list them in the README.

### **How long should I work on this?**

Use your best judgement.

### **Can I use ChatGPT or other AI code generation tools?**

We are big fans of AI and the potential it unlocks for engineers, but kindly ask that you refrain from using tools like ChatGPT, Copilot or similar tools or to generate your solution to the take-home project.

### **What minimum versions should I support?**

You can decide what minimum version to support. At Fetch, we support iOS 16 and up.

### Sample response
```
{
    "recipes": [
        {
            "cuisine": "Malaysian",
            "name": "Apam Balik",
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
            "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
            "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
            "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
        },
        {
            "cuisine": "British",
            "name": "Apple & Blackberry Crumble",
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
            "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
            "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
            "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
            "youtube_url": "https://www.youtube.com/watch?v=4vhcOwVBDO4"
        },
        {
            "cuisine": "British",
            "name": "Apple Frangipan Tart",
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/large.jpg",
            "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/small.jpg",
            "uuid": "74f6d4eb-da50-4901-94d1-deae2d8af1d1",
            "youtube_url": "https://www.youtube.com/watch?v=rp8Slv4INLk"
        },
        {
            "cuisine": "British",
            "name": "Bakewell Tart",
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/dd936646-8100-4a1c-b5ce-5f97adf30a42/large.jpg",
            "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/dd936646-8100-4a1c-b5ce-5f97adf30a42/small.jpg",
            "uuid": "eed6005f-f8c8-451f-98d0-4088e2b40eb6",
            "youtube_url": "https://www.youtube.com/watch?v=1ahpSTf_Pvk"
        },
        {
            "cuisine": "American",
            "name": "Banana Pancakes",
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/large.jpg",
            "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/small.jpg",
            "source_url": "https://www.bbcgoodfood.com/recipes/banana-pancakes",
            "uuid": "f8b20884-1e54-4e72-a417-dabbc8d91f12",
            "youtube_url": "https://www.youtube.com/watch?v=kSKtb2Sv-_U"
        },
        {
            "cuisine": "British",
            "name": "Battenberg Cake",
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ec1b84b1-2729-4547-99db-5e0b625c0356/large.jpg",
            "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ec1b84b1-2729-4547-99db-5e0b625c0356/small.jpg",
            "source_url": "https://www.bbcgoodfood.com/recipes/1120657/battenberg-cake",
            "uuid": "891a474e-91cd-4996-865e-02ac5facafe3",
            "youtube_url": "https://www.youtube.com/watch?v=aB41Q7kDZQ0"
        },
        {
            "cuisine": "Canadian",
            "name": "BeaverTails",
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/3b33a385-3e55-4ea5-9d98-13e78f840299/large.jpg",
            "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/3b33a385-3e55-4ea5-9d98-13e78f840299/small.jpg",
            "source_url": "https://www.tastemade.com/videos/beavertails",
            "uuid": "b5db2c09-411e-4bdf-9a75-a194dcde311b",
            "youtube_url": "https://www.youtube.com/watch?v=2G07UOqU2e8"
        },
        {
            "cuisine": "British",
            "name": "Blackberry Fool",
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ff52841a-df5b-498c-b2ae-1d2e09ea658d/large.jpg",
            "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ff52841a-df5b-498c-b2ae-1d2e09ea658d/small.jpg",
            "source_url": "https://www.bbc.co.uk/food/recipes/blackberry_fool_with_11859",
            "uuid": "8938f16a-954c-4d65-953f-fa069f3f1b0d",
            "youtube_url": "https://www.youtube.com/watch?v=kniRGjDLFrQ"
        },
    ]
}
```

