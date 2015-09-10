package slavara.haxe.core.sys.io;
import slavara.haxe.core.sys.io.SearchOption;
using slavara.haxe.core.Utils.StringUtil;
using haxe.io.Path;
using sys.FileSystem;
using Lambda;

/**
 * @author SlavaRa
 */
class Directory {
	
	/**
	 * Возвращает имена файлов (включая пути) в заданном каталоге, отвечающие условиям шаблона поиска, используя значение, которое определяет, выполнять ли поиск в подкаталогах.
	 * @param path Каталог, в котором необходимо выполнить поиск.
	 * @param searchPattern Строка поиска, которую необходимо сравнивать с именами файлов, на которые указывает path.
	 * @param searchOption Одно из значений перечисления, определяющее, следует ли выполнять поиск только в текущем каталоге или также во всех его подкаталогах.
	 * @return 
	 */
	public static function getFiles(path:String, searchPattern:String, searchOption:SearchOption):Array<String> {
		return _getFiles(path.addTrailingSlash(), searchPattern, searchOption, []);
	}
	
	static function _getFiles(path:String, pattern:String, option:SearchOption, result:Array<String>):Array<String> {
		var paths = path.readDirectory();
		
		result = result.concat(paths.filter(function(v) {
			return !v.extension().isNullOrEmpty() && (pattern.indexOf("*.*") != -1 || v.indexOf(pattern) != -1);
		})).map(function(v) return path + v);
		
		if(option == SearchOption.AllDirectories) {
			for(it in paths.filter(function(v) return v.extension().isNullOrEmpty())) {
				result = result.concat(_getFiles((path + it).addTrailingSlash(), pattern, option, []));
			}
		}
		return result;
	}
}