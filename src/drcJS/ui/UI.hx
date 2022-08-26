package drcJS.ui;

import js.Browser;
import js.html.CanvasElement;

class UI {
    
    // ** Publics.

    public var root:CanvasElement;

    public function new() {
        
        root = Browser.document.createCanvasElement();

        root.id = "ui";

        root.className = "ui";

        root.width = 640;

        root.height = 480;

        var element = js.Browser.document.getElementById("container");

        if (element != null) {
         
            element.appendChild(root);

            return;
        }
    }
}