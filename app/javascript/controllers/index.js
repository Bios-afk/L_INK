// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
import ArtistCardController from "./artist_card_controller";
application.register("artist_card", ArtistCardController);
import MapController from "./map_controller";
application.register("map", MapController);
eagerLoadControllersFrom("controllers", application);
