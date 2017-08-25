###DentalEmergency###


========================================================================
DESCRIPTION:
DentalEmergency is an iPhone app that helps users find a dentist when they have a dental emergency.  The app searches for dentists near your current location and related dental practices will populate the map with relevant information. You can quickly select an office that meets your needs and call for an immediate appointment and get directions right within the app. 


The DentalEmergency app also allows you to search for dentists within your preferred location or for a specific practice. It includes vital office information including office ratings and patient reviews. It will highlight the route to your chosen office from your location and keep track of your selected offices while you search for others and more.   




Supported Formats


=========================================================================
BUILDS REQUIREMENTS:


Xcode 8.2.1,  IOS SDK 8.2 or better, 


=========================================================================
RUNTIME REQUIREMENTS:


iPhone, iPad, or iPod Touch running iOS 8.2.1 or better Xcode 8.2.1,  IOS SDK 8.2.1 or better, 


=========================================================================
PACKAGING LIST:


ViewController/ViewController.swift
A UIViewController implements a root view controller to be the start point of the app .  It conforms with CLLocationManager object to get the location of the user and use this information to search for dentists nearby. It conforms with MKMapViewDelegate to populate the location of the results of dental offices from the search. It uses UISearchBarDelegate to get the user’s personalized search.
 
ViewController/practiceDetailViewController.swift
A UIViewController is implemented to populate dental practice information in more detail.


ViewController/practiceViewUtility.swift
A class that provides the APIs to support common functionalities and algorithm that are needed by multiple view controllers or classes.


ViewController/ReviewTableViewController.swift
A UIViewController that populates the customs’ reviews for the selected dental practice. It conforms with UITableViewDataSource and UITableViewDelegate.


ViewController/SelectedOfficesTableViewController.swift
A UIViewController that conforms with UITableView. It lists all the selected offices that users may consider while searching for dental offices.  
 
ViewController/DirectionsViewController.swift
This view controller uses MKDirections object to search for the best routes from user location to the selected office the user is interesting in using MKMapView and MKMapViewDelegate to customize the map and highlight the route.


ViewController/ReviewTableViewCell.swift
ReviewTableViewCell class conforms UITableViewCell to customize the cell output for each custom review for the selected practice.  


ViewController/SelectedOfficesTableViewCell.swift
SelectedOfficesTableViewCell class conforms UITableViewCell to customize the output of the list of selected practice’s cell. 


ViewController/viewControllerConstant.swift
Define an enum to provide the constant value for each reachable views.  Algorithms are defined to provide the persistence when user resigns from the app.


NetworkService/NetworkRequest.swift
NetworkRequestAPIs class defines the APIs that are commonly used for http request methods,  GET, POST, DELETE, and PUT, from mobile apps. They are well defined to make requests to the RESTful web services who provides REST APIs.    


NetworkService/GoogleConstant.swift
Throughout the app, there are five different type of network requests to the Google RESTful web services. This file defines all the constants, parameters, and values needed to make the requests.   
 
NetworkService/GoogleSearch.swift
GoogleSearchService class provides all the functionalities needed for the network request to Google web services and parse receiving data from Google web services.  


DataStrcuture.swift
PracticePinAnnotation class conforms MKPointAnnotation.  It defines and provides the custom needs for this project.  SelectedOfficeData data structure is defined to contain all the required data needed throughout the app.  


DataModel/CoreDataStack.swift
Defines CoreDataStack data structure to manage and configure persistence framework that allows data organized with related entity and attribute model to be serialized into SQLite stores.


DataModel/DentalEmergencyCoreData.swift
DentalEmergencyDataCore class defines the methods that will be called by view controllers to fetch results of controller and manage attributes with the associated entity.


DataModel/MySelectedOffices+CoreDataClass.swift
MySelectedOffices class to define the data model entity.


DataModel/MySelectedOffices+CoreDataProperties.swift
Extension of MySelectedOffices class. 
 
=========================================================================
CHANGES FROM PREVIOUS VERSION:


1.0 First Release


=========================================================================
Copyright © 2017 Apple Inc. All rights reserved