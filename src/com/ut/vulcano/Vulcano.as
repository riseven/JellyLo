package com.ut.vulcano 
{
	import flash.system.System;
	import flash.utils.getDefinitionByName;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Vulcano 
	{	
		private static var _instance:Vulcano = new Vulcano(SingletonLock);
		private var context:XML;
		private var singletonForges:Object;
		
		public function Vulcano(lock:Class) 
		{
			if ( lock != SingletonLock ) {
				throw new Error("Singleton violation");
			}
		}
		
		public static function get instance():Vulcano { 
			return _instance; 
		}
		
		public function loadContextFromXML(context:XML):void {
			this.context = context;
			singletonForges = new Object();
		}
		
		public function loadContextFromString(context:String):void {
			loadContextFromXML(new XML(context));
		}
		
		public function getForge(id:String):Object {
			// Check if a singleton instance with that id already exists
			if ( singletonForges[id] != undefined ) {
				return singletonForges[id];
			}
			
			// Search for root forge with correct id
			for each ( var forge:XML in context.forge ) {
				if ( forge.@id == id ) {
					return instantiateForge(forge);
				}
			}
			
			throw new Error("Forge do not exists: " + id);
		}
		
		private function instantiateForge(forge:XML):Object {
			// Create instance
			var forgeClass:Class = getDefinitionByName(forge["@class"]) as Class;			
			var forgeInstance:Object = new forgeClass();
			
			// Register singleton instance
			if ( forge.@context == "singleton" || forge.@context == undefined ) {
				singletonForges[forge.@id] = forgeInstance;
			}
			
			// Set properties
			for each ( var property:XML in forge.property ) {
				var value:Object = null;
				
				if ( property.@value != undefined ) {
					value = property.@value;
				} else if ( property.@ref != undefined ) {
					value = getForge(property.@ref);
				} else if ( property.value != undefined ) {
					value = property.value[0].toString();
				} else if ( property.ref != undefined ) {
					value = getForge(property.ref[0].toString());
				} else if ( property.forge != undefined ) {
					value = instantiateForge( property.forge[0] );
				} else if ( property.list != undefined ) {
					value = instantiateList( property.list[0] );
				} else if ( property.map != undefined ) {
					value = instantiateMap( property.map[0] );
				} else if ( property.props != undefined ) {
					value = instantiateProps( property.props[0] );
				} else if ( property["null"] != undefined ) {
					value = null;
				} else {
					throw new Error("Value not specified in: " + property.toXMLString());
				}
				
				forgeInstance[property.@name] = value;
			}
			
			return forgeInstance;
		}
		
		private function instantiateList(list:XML):Array {
			var newArray:Array = new Array();
			
			for each ( var elem:XML in list.* ) {
				if ( elem.localName() == "value" ) {
					newArray.push( elem.toString() );
				} else if ( elem.localName() == "ref" ) {
					newArray.push( getForge( elem.toString() ) );
				} else if ( elem.localName() == "forge" ) {
					newArray.push( instantiateForge( elem ) );
				} else if ( elem.localName() == "list" ) {
					newArray.push( instantiateList( elem ) );
				} else if ( elem.localName() == "map" ) {
					newArray.push( instantiateMap( elem ) );
				} else if ( elem.localName() == "props" ) {
					newArray.push( instantiateProps( elem ) );
				} else if ( elem.localName() == "null" ) {
					newArray.push( null );
				} else {
					throw new Error("Not valid node: " + elem.toXMLString());
				}
			}
			
			return newArray;
		}
		
		private function instantiateMap(map:XML):Object {
			var newMap:Object = new Object();
			
			for each ( var entry:XML in map.entry ) {
				var key:Object = null;
				
				if ( entry.@key != undefined ) {
					key = entry.@key;
				} else if ( entry.@keyRef != undefined ) {
					key = getForge( entry.@keyRef );
				} else {
					throw new Error("Key not specified in: " + entry.toXMLString());
				}
				
				var value:Object = null;
				if ( entry.@value != undefined ) {
					value = entry.@value;
				} else if ( entry.@valueRef != undefined ) {
					value = getForge(entry.@ref);
				} else if ( entry.value != undefined ) {
					value = entry.value[0].toString();
				} else if ( entry.ref != undefined ) {
					value = getForge(entry.ref[0].toString());
				} else if ( entry.forge != undefined ) {
					value = instantiateForge( entry.forge[0] );
				} else if ( entry.list != undefined ) {
					value = instantiateList( entry.list[0] );
				} else if ( entry.map != undefined ) {
					value = instantiateMap( entry.map[0] );
				} else if ( entry.props != undefined ) {
					value = instantiateProps( entry.props[0] );
				} else if ( entry["null"] != undefined ) {
					value = null;
				} else {
					throw new Error("Value not specified in: " + entry.toXMLString());
				}
				
				newMap[key] = value;
			}
			
			return newMap;
		}
		
		private function instantiateProps(props:XML):Object {
			var newMap:Object = new Object();
			
			for each ( var prop:XML in props.prop ) {
				newMap[ prop.@key ] = prop.toString();
			}
			
			return newMap;
		}
	}
	
}

class SingletonLock {

}