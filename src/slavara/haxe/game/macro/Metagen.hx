package slavara.haxe.game.macro;
import haxe.Log;
import haxe.macro.Context;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.Position;
import haxe.macro.Expr.TypeDefinition;
import haxe.macro.Expr.TypeDefKind;
import haxe.macro.Expr.TypePath;
import slavara.haxe.core.sys.io.Directory;
import slavara.haxe.core.sys.io.SearchOption;
using slavara.haxe.core.utils.Utils.StringUtil;
using slavara.haxe.game.macro.Metagen.StructParser;
using sys.io.File;
using StringTools;

typedef Settings = {
	metaPath:String,
	metaExt:String,
	assetsPath:String,
	assetExt:String,
	pack:Array<String>
}

/**
 * @author SlavaRa
 */
class Metagen {
	
	static inline var STRUCT = "struct";
	
	macro public static function init(settings:Settings):Array<Field> {
		var files = Directory.getFiles(settings.metaPath, settings.metaExt, SearchOption.AllDirectories);
		for(file in files) {
			var content = removeCommentLines(file.getContent());
			var filePos = Context.makePosition( { min:0, max:0, file:file } );
			for(it in getStructs(content, settings, filePos)) {
				Context.defineType(it);
			}
		}
		return Context.getBuildFields();
	}
	
	static inline function removeCommentLines(v:String):String return ~/\/\/.*/gm.replace(v, "");
	
	static inline function getStructs(content:String, settings:Settings, filePos:Position):Array<TypeDefinition> {
		var result:Array<TypeDefinition> = [];
		var startIndex = 0;
		var endIndex = 0;
		while(content.length > 0) {
			startIndex = content.indexOf(STRUCT);
			if(startIndex == -1) {
				break;
			}
			endIndex = content.indexOf(STRUCT, startIndex + STRUCT.length);
			if(endIndex == -1) {
				endIndex = content.length;
			}
			result.push(StructParser.parse(content.substring(startIndex, endIndex), settings, filePos));
			content = content.substring(endIndex);
		}
		return result;
	}
}

/**
 * @author SlavaRa
 * @private
 */
@:noCompletion extern class StructParser {
	
	public static inline function parse(v:String, settings:Settings, filePos:Position):TypeDefinition {
		var header = v.getHeader();
		var body = v.getBody();
		var s = "struct";
		var e = "extends";
		var i = header.indexOf(s);
		s = header.substring(i + s.length);
		i = s.indexOf(e);
		
		var sName:String;
		var sType:TypePath;
		if(i == -1) {
			sName = s.trim();
			sType = null;
		} else {
			sName = s.substring(0, i).trim();
			var superClassName = s.substring(i + e.length).trim();
			var superClassPack:Array<String> = switch(superClassName) {
				case "UnknownProto": "slavara/haxe/game/Models".split("/");
				case _: settings.pack;
			}
			sType = { name:superClassName, pack:superClassPack, params:[] };
		}
		return {
			pack : settings.pack,
			name : sName,
			pos : filePos,
			meta : [],
			params : [],
			isExtern : false,
			kind : TypeDefKind.TDClass(sType, null, false),
			fields : [for(it in body) it.field]
		};
	}
	
	static inline function removeCommentDocs(v:String):String return v;//TODO: IMPLEMENT ME
	
	static inline function getHeader(v:String):String return v.substring(0, v.indexOf("{"));
	
	static inline function getBody(v:String):Array<LineModel> {
		var list = v.substring(v.indexOf("{") + 1, v.lastIndexOf("}"))
			.replace("\t", "")
			.replace("\n", "")
			.split("\r")
			.filter(function(v) return !v.isNullOrEmpty())
			.map(function(v) return v.replace(" ", ""));
		return [for(it in list) new LineModel(it)];
	}
	
}

/**
 * @author SlavaRa
 * @private
 */
private class LineModel {
	
	public function new(text:String) {
		this.text = text;
		
		var sfield = getSField(text);
		var meta = getMeta(text);
		var i = sfield.indexOf(":");
		field = { 
			name:sfield.substring(0, i),
			doc:null,
			meta:[],
			kind:getMemberKind(sfield.substring(i + 1)),
			access:[Access.APublic], //TODO
			pos:Context.currentPos()
		};
	}
	
	public var text(default, null):String;
	public var field(default, null):Field;
	
	inline function getSField(v:String):String {
		var i = v.indexOf("@");
		return i == -1 ? v : v.substring(0, i);
	}
	
	inline function getMeta(v:String):Array<String> {
		var i = v.indexOf("@");
		return i == -1 ? [] : v.substring(i).split("@").filter(function(v) return !v.isNullOrEmpty());
	}
	
	inline function getMemberKind(stype:String, svalue:String = ""):FieldType {
		var stype2haxetype:Map<String, String> = [
			"int" => "Int",
			"uint" => "Int",
			"float" => "Float",
			"string" => "String",
			"[]" => "Array<Dynamic>"
		];
		return FieldType.FVar(ComplexType.TPath( { pack:[], name:stype2haxetype.get(stype), params:[], sub:null } ));
	}
}