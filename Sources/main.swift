import Kitura
import LoggerAPI
import HeliumLogger
import KituraStencil

HeliumLogger.use(.info)
let router = Router()
router.setDefault(templateEngine: StencilTemplateEngine())
router.all("/static", middleware: StaticFileServer())

router.get("/") {
   request, response, next in
   defer { next() }
   try response.render("home", context: [:])
}
router.get("/staff/:name") {
   request, response, next in
   defer { next() }
   //pull out the name of the staff member in question
   guard let name = request.parameters["name"] else { return }

   //create some dummy data to work with
   let bios = [
    "kirk": "My name is James Kirk and I love snakes.",
    "picard": "My name is Jean-Luc Picard and I'm mad for cats.",
    "sisko": "My name is Benjamin Sisko and I am all about the budgies.",
    "janeway": "My name is Kathyrn Janeway and I wan to hug every hamster",
    "archer": "My name is Jonathan Archer and beagles are my thing",
    "logan": "They call me The Wolverine and I deal with the dangerous animals here."
   ]
   //create a context dictionary we'll pass to the template
   var context = [String: Any]()
   context["people"] = bios.keys.sorted()

   //attempt to find a staff member by this name
   if let bio = bios[name] {
    //we found one - set some context details
    context["name"] = name
    context["bio"] = bio
   }

   try response.render("staff", context: context)
}

router.get("/contact") {
   request, response, next in
   defer { next() }
   try response.render("contact", context: [:])
}

Kitura.addHTTPServer(onPort: 8090, with: router)
Log.info("Haters gonna hate")
Kitura.run()
