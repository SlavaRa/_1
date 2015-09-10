package slavara.haxe.game.macro;
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
using slavara.haxe.core.Utils.StringUtil;
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

enum Lang {
	AS3;
	Haxe;
}

/**
 * @author SlavaRa
 */
class Metagen {
	
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
		var struct = "struct";
		var result:Array<TypeDefinition> = [];
		var startIndex = 0;
		var endIndex = 0;
		while(content.length > 0) {
			startIndex = content.indexOf(struct);
			if(startIndex == -1) {
				break;
			}
			endIndex = content.indexOf(struct, startIndex + struct.length);
			if(endIndex == -1) {
				endIndex = content.length;
			}
			result.push(StructParser.getTypeDefinition(content.substring(startIndex, endIndex), settings, filePos));
			content = content.substring(endIndex);
		}
		return result;
	}
}

/**
 * @author SlavaRa
 */
@:noCompletion extern class StructParser {
	
	public static inline function getTypeDefinition(v:String, settings:Settings, filePos:Position):TypeDefinition {
		var header = v.getHeader(settings.pack);
		return {
			pack : settings.pack,
			name : header.name,
			pos : filePos,
			meta : [],
			params : [],
			isExtern : false,
			kind : TypeDefKind.TDClass(header.superClass, null, false),
			fields : [for(it in v.getBody()) it.field]
		};
	}
	
	public static inline function getStringDefinition(v:String, settings:Settings):String {
		var header = v.getHeader(settings.pack);
		var body = v.getBody();
		return "";
	}
	
	static inline function getHeader(v:String, pack:Array<String>):HeaderModel {
		return new HeaderModel(v.substring(0, v.indexOf("{")), pack);
	}
	
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
private class HeaderModel {
	public function new(text:String, pack:Array<String>) {
		this.text = text;
		this.pack = pack;
		var s = "struct";
		var e = "extends";
		var i = text.indexOf(s);
		s = text.substring(i + s.length);
		i = s.indexOf(e);
		if(i == -1) {
			name = s.trim();
		} else {
			name = s.substring(0, i).trim();
			var superClassName = s.substring(i + e.length).trim();
			superClass = {
				name:superClassName,
				pack:switch(superClassName) {
					case "UnknownProto", "UnknownData": "slavara/haxe/game/Models".split("/");
					case _: pack;
				},
				params:[]
			};
		}
	}
	
	public var text(default, null):String;
	public var pack(default, null):Array<String>;
	public var name(default, null):String;
	public var superClass(default, null):TypePath;
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