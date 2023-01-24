# themoviedb_app
An iOS UIKit app that fetches the most popular movies from `themoviedb.com` with their API. It also contains the essentials of a collection view with a search bar.

## Screenshots (Explanations below)

Home View                  |  Movie View
:-------------------------:|:-------------------------:
<img src="https://github.com/berketuranlioglu/themoviedb_app/blob/main/movie-app/homeScreen.png" alt="homeScreen Screenshot" style="float: right;" width="240"/>  |  <img src="https://github.com/berketuranlioglu/themoviedb_app/blob/main/movie-app/movieScreen.png" alt="movieScreen Screenshot" width="240"/>

## Home View
`Search bar` benefits from the TMDB API with their built-in search query. Entered text is continuously searched until the user returns.

`Collection view` is flexible and rearrangable, i.e., user can change the number of columns so that he/she can look for one or two movies per row.

Collection view shows the first 20 movies initially. `Load more` button dynamically updates the collection view by adding 20 movies every time.

## Movie View
Shows the general information about the selected movie, such as its poster, name, rating, release date, and description. Image data has been taken from different URL owned by TMDB due to their API implementations.
