#  DesafioTecnicoIOS App

The DesafioTecnicoIOS App is a sample app that simulates a store that displays products of different categories. It allows viewing a collection of products, displaying a detail view for each one, filtering them by category and adding products to a shopping cart.

It uses the https://fakestoreapi.com/ API to obtain product data.

To build the app, open the DesafioTecnicoIOS.xcodeproj with Xcode.

The project has no dependencies, so it should compile without problems.

The app requires a minimum iOS 13 version to operate. To choose the minimum version, a middle ground was settled between the CL Lider App (iOS 11), and the US Walmart App (iOS 15)

The project uses a clean architecture / VIP architecture. This architecture was chosen because each feature component required some ellaboration upon the fakestoreapi JSON responses, such as the business logic to order the apps according to the product between app rating and rating count, the currency operations needed to transform the prices from dollars to CL pesos, and the combination of local data and API data needed to display the CartTab list of products.
The VIP architecture is separated enough that if any Feature component needs to grow, there's space to add more functionality while keeping things organized.

Each Feature component is composed by a ViewController, a View, an Interactor and a Presenter. The ViewController initiates procedures on the interactor, which fetches the data online or locally and hands those responses to the presenter, which will process the data into a separate model passed to the View. This helps to decouple the View from the API response's format.
The Interactor, Presenter, ViewController and Views have a reference to an abstraction of the object they communicate with, which helps testing by switching the implementation of the protocols in the unit tests. That way, in the unit tests, the interactor will have a reference to a PresenterSpy with which we can assert that business logic or connections between objects is not broken.
The ViewController is connected to the Interactor, which is connected to the Presenter, which loops back to the ViewController. The View only has connection to its owner ViewController through a couple of delegate methods exposed in a protocol implemented by the ViewController.
All the feature components are built in the ComponentBuilder factory class.

The LandingPageTab, which is the most complicated feature component, receives information from the ProductDetailPage and the Categories via closures passed to the constructors of their ViewControllers. Most of these closures are actions that must be performed when closing those presented ViewControllers, such as reloading data or updating the TabBar Cart Item's counter.

To manage the API calls, the FakeStoreApiClient was developed to leverage Swift's URLSession Async await. This makes error handling much simpler, since all API call methods return a model or throw an error, and all these errors can be caught at the interactor, which pass the error to the corresponding presenter method. The CartInteractor leverages the async capabilities with a ThrowingTaskGroup to simultaneously fetch product data for all stored productIds simmultaneously.

The LocalStorage actor is an async wrapper over UserDefaults. Given it is an actor, any data races are avoided, keeping the Cart in a correct state. Initially planned to use CoreData, the time constraint led to using UserDefaults to store the cart data locally, storing the product Id's and quantities.

The extra development time was devoted to adding UI feedback, especially when adding products to the cart. A confirmation modal was included when trying to decrease the quantity of a product below, removing the product if the user confirms that is the intention.


