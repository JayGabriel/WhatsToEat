# WhatsToEat
Copyright © 2020 Jay Gabriel

## App Description
Do you ever find yourself indecisive when it comes to food?  WhatsToEat helps you to find the best places to eat!  Whether you want to search for spots nearest you or anywhere around the world, WhatsToEat helps you find a great random selection of restaurants to choose from!  So what are you waiting for?  Discover WhatsToEat?

* Restaurant data provided by Yelp: https://www.yelp.com/
* Icons provided by Icons8: https://icons8.com

## App Usage 

### Setting the search location
Upon first launch, WhatsToEat will request permission to access your location while using the app.  

If you allow this, your current location will be used each time the app starts.  Otherwise, you must manually set the search location by typing it in the text field titled "Where to look?"

### Searching for a style
To search for restaurants based on style (such as "ramen", "pizza", or "burgers") simply type the keyword into the text field titled "What kind of food?"

### Searching for a random restaurant
To find restaurants based on a randomized style keyword, tap the button with the `?` icon.

### Restarting a search
To find more restaurants based on the current search keyword and location, tap the button with the refresh icon.

### Toggling between the map and the list
To toggle the home screen view, tap the map or list button (which will alternate based on which view is showing).

### Viewing Restaurant Details
To view more information about a restaurant, either tap its pin on the map or its cell in the list. The restaurant's main photo, name, style, distance, rating, price, address, additional photos, and current hours will be displayed.  

You can also open directions to the restaurant in Apple Maps, view the business on Yelp, and make a phone call by tapping each respective button.

### Viewing the About Page
Tapping the info icon in the top right hand corner of the home screen will display the app name, app author, as well as links to Yelp.com, Icons8.com, and this GitHub repository.

## Code

### Architecture
This project utilizes an MVVM design pattern to separate business logic from the user facing interface.  The app's main features use a view controller coupled with a view model.  The delegate pattern is used for handling user input and network responses.

### UI
Views are setup programmatically using Auto Layout.  Custom UIViews such as `SearchView`, `ToolbarView`, as well as custom table and collection view cell classes have been created to simplify building out the UI for each view controller.

### Networking
The `YelpAPI` class is used to handle network calls to the Yelp Fusion API.

### Assets & Other
All static image assets are located in the project's local assets folder.  These images, along with fonts and colors, are referenced through extensions on their type. 

## About this project

Originally released in October 2017, WhatsToEat was my first published iOS App on the Apple App Store: https://appadvice.com/game/app/whatstoeat/1315432302. The first iteration of this app was submitted as the final project for an online course in iOS Development.

In this updated repo, I refactored the codebase to adhere to many of the best practices I have learned during my time working as a professional iOS Developer.  I plan to revisit this project every now and then to incrementally improve it as I continue to learn new skills within the iOS Development world.
