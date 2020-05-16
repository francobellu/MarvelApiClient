Overview
This project is pretty simple to really need arquitecture overheads like Coordinators, Dependency containers etc. Nevertheless I am including them to demostrate the method


Frameworks used:

RSwift ( cocoaPods)
ALamofireImage ( swiftPakage)

Siterep ( script with installed program)
SwiftLint ( script with installed program)


UI Architecture: MVP + Coordinator 

Coordinators:
  - One AppCoordinator to encapsulate the display of the initial screen
  - Then a Coordinator for each flow. The Coord instantiate the relevant Vcs according to the flow logic managed by the coordinator.
  - The coord defines a delegateProtocol for each VC it manages and such VC use these delegate methods to pass events notifications to the coord which can take the decision of the next step ( VC to instantiate etc).
  - The VC communicates with its coordibnatir by means of delegate
  - The Coord keeps 

Principles: 
  - The VC are instantiated instantiated programmaticvally without segues by the coordinator
  - This means that each VC doens't need to know about about the following VC ( prepare for segue) AND doens't need to tell its owner, the navigator, to push a new VC.
  - So we take the flow control out of the VC so that the VC can be also reused in other flows and can be more easily tested


Wish List:
  1.  Spinner for async list view
  2.  apiClient: should be a singleton or passed as dependency injection by the coordinators chain?


TODO:

Architecture: Interactor with tests?


HTTP:
  - URLQueryItemEncoder is not used??
  
MarvelApiCLient: 
- unit tests con Mock data
- 1 Coordinator for all with deeplinks and no  
- httpCLient in framework? swiftPM, github?

- characterList: take out the api and put it in VM or coordinator
- create open characterDertail with the character sent by deeplink
- intercept back using navcontrollerdelegate

- remove Characterlist coordinator, Comics coord, AvengerCoors( already not used); move al the delegates to the LandingCoord
- unit test deep links
- Refactor: Dep Injection for  ViewModels and services

- https://alisoftware.github.io/swift/protocols/2018/09/02/protocols-private-properties/

Optional
- Create Swift package for networking? 
- controllare memory leaks etc
- the top level json structure is different if server returns an error. { code: int, message = String}

DONE



OLD TODO
  1.  Fare View2, view3 UI
  2.  Coordinators: revisare quali non ho bisogno
  3.  Unit Test API
  4.  Unit Test storage
  5.  creare 3 framwewoks diversi per view, VC,model

