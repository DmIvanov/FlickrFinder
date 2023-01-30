Here is a simple client for the [Flickr API](https://www.flickr.com/services/api/)

## Implemented features

- List view with images and their titles
- Details view with bigger photo when the item in the list is selected
- An interface for inputting search terms
- When the term is inserted (starting from the 3rd character in the input field) the API is requested for the photos according to the term (via `flickr.photos.search`)
- When there is no term (before any search term is inserted or if the search canceled) random recent photos are requested (via `flickr.photos.getRecent`)
- The items are requested in batches of 25
- The pagination is implemented so when you reach the bottom of the list the next batch is requested
- Simple image cache is implemented in `ImageLoader` (without any purging strategy yet)
- Simple error handling is added
- Couple UnitTests are added

## Technical details

- MVVM+C is used as main pattern to build the scenes/screens
- Different concurrency-handling approaches are used as showcasing: GCD for image loading, Modern Concurrency (aka async/await + actors) for the rest
- Dependency injection is used for better maintainability and testability of the code
- UI is built in code (via UIKit)