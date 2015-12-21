/**
 * 
 */

var EventUtil = {
	addHandler: function(element, type, handler) {
		if(element.addEventListener) {
			element.addEventListener(type, handler, false);
		} else if(element.attachEvent) {
			element.attachEvent("on" + type, handler);
		} else {
			element["on" + type] = handler;
		}
	},
	
	getEvent: function(event) {
		return event || window.event;
	},
	
	getTarget: function(event) {
		return event.target || event.srcElement;
	},
	
	getRelatedTarget: function(event) {
		if(event.relatedTarget) {
			return event.relatedTarget;
		} else if (event.toElement) {
			return event.toElement;
		} else if(event.fromElement) {
			return event.fromElement;
		} else {
			return null;
		}
	},
	
	getButton: function(event) {
		if(document.implementation.hasFeature("MouseEvents", "2.0")) {
			return event.button;
		} else {
			switch(event.button) {
			case 0:
			case 1:
			case 3:
			case 5:
			case 7:
				return 0;
			case 2:
			case 6:
				return 2;
			case 4:
				return 1;
			}
		}
	},
	
	getWheelDelta: function(event) {
		if(event.wheelDelta) {
			return event.wheelDelta;
		} else {
			return -event.detail * 40;
		}
	},
	
	getCharCode: function(event) {
		if(typeof event.charCode == "number") {
			return event.charCode;
		} else {
			return event.keyCode;
		}
	},
	
	preventDefault: function(event) {
		if(event.preventDefault) {
			event.preventDefault();
		} else {
			event.returnValue = false;
		}
	}
};